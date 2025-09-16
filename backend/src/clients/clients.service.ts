import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Client, ClientStatus } from './entities/client.entity';
import { CreateClientDto } from './dto/create-client.dto';
import { UpdateClientDto } from './dto/update-client.dto';
import { UserRole } from '../users/entities/user.entity';

@Injectable()
export class ClientsService {
  constructor(
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async create(createClientDto: CreateClientDto): Promise<Client> {
    const existingClient = await this.clientRepository.findOne({
      where: { cnpj: createClientDto.cnpj },
    });

    if (existingClient) {
      throw new BadRequestException('CNPJ já está cadastrado');
    }

    const newClient = this.clientRepository.create({
      ...createClientDto,
      status: createClientDto.status || ClientStatus.ACTIVE,
    });

    return this.clientRepository.save(newClient);
  }

  async findAll(
    requestingUser: any,
    name?: string,
    cnpj?: string,
    city?: string,
    status?: ClientStatus,
    sortBy?: string,
    order?: 'ASC' | 'DESC',
  ): Promise<Client[]> {
    const queryBuilder = this.clientRepository
      .createQueryBuilder('client')
      .leftJoinAndSelect('client.assignedUser', 'assignedUser');

    if (requestingUser.role !== UserRole.ADMIN) {
      queryBuilder.where('client.assignedUserId = :userId', {
        userId: requestingUser.id,
      });
    }

    if (name) {
      queryBuilder.andWhere(
        'client.storeFrontName LIKE :name OR client.companyName LIKE :name',
        {
          name: `%${name}%`,
        },
      );
    }

    if (cnpj) {
      queryBuilder.andWhere('client.cnpj LIKE :cnpj', {
        cnpj: `%${cnpj}%`,
      });
    }

    if (city) {
      queryBuilder.andWhere('client.city LIKE :city', {
        city: `%${city}%`,
      });
    }

    if (status) {
      queryBuilder.andWhere('client.status = :status', { status });
    }

    if (sortBy) {
      const validSortFields = [
        'storeFrontName',
        'companyName',
        'createdAt',
        'status',
      ];
      if (validSortFields.includes(sortBy)) {
        queryBuilder.orderBy(`client.${sortBy}`, order || 'ASC');
      }
    } else {
      queryBuilder.orderBy('client.createdAt', 'DESC');
    }

    return queryBuilder.getMany();
  }

  async findOne(id: number, requestingUser: any): Promise<Client> {
    const queryBuilder = this.clientRepository
      .createQueryBuilder('client')
      .leftJoinAndSelect('client.assignedUser', 'assignedUser')
      .where('client.id = :id', { id });

    if (requestingUser.role !== UserRole.ADMIN) {
      queryBuilder.andWhere('client.assignedUserId = :userId', {
        userId: requestingUser.id,
      });
    }

    const client = await queryBuilder.getOne();

    if (!client) {
      throw new NotFoundException('Cliente não encontrado');
    }

    return client;
  }

  async update(
    id: number,
    updateClientDto: UpdateClientDto,
    requestingUser: any,
  ): Promise<Client> {
    const client = await this.findOne(id, requestingUser);

    if (updateClientDto.cnpj && updateClientDto.cnpj !== client.cnpj) {
      const existingClient = await this.clientRepository.findOne({
        where: { cnpj: updateClientDto.cnpj },
      });

      if (existingClient) {
        throw new BadRequestException('CNPJ já está cadastrado');
      }
    }

    if (
      requestingUser.role !== UserRole.ADMIN &&
      client.assignedUserId !== requestingUser.id
    ) {
      throw new ForbiddenException(
        'Você não tem permissão para atualizar este cliente',
      );
    }

    await this.clientRepository.update(id, updateClientDto);
    return this.findOne(id, requestingUser);
  }

  async remove(id: number, requestingUser: any): Promise<void> {
    if (requestingUser.role !== UserRole.ADMIN) {
      throw new ForbiddenException(
        'Você não tem permissão para excluir clientes',
      );
    }

    const client = await this.findOne(id, requestingUser);
    await this.clientRepository.remove(client);
  }

  async assignUserToClient(
    clientId: number,
    userId: number,
    requestingUser: any,
  ): Promise<Client> {
    if (requestingUser.role !== UserRole.ADMIN) {
      throw new ForbiddenException(
        'Você não tem permissão para atribuir usuários a clientes',
      );
    }

    await this.findOne(clientId, requestingUser);

    await this.clientRepository.update(clientId, { assignedUserId: userId });
    return this.findOne(clientId, requestingUser);
  }
}
