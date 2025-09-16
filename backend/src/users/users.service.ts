import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User, UserRole } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdatePasswordDto } from './dto/update-password.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const existingUser = await this.userRepository.findOne({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new BadRequestException('Email já está em uso');
    }

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);

    const newUser = this.userRepository.create({
      ...createUserDto,
      password: hashedPassword,
      role: createUserDto.role || UserRole.USER,
    });

    return this.userRepository.save(newUser);
  }

  async findAll(
    role?: UserRole,
    sortBy?: string,
    order?: 'ASC' | 'DESC',
  ): Promise<User[]> {
    const queryBuilder = this.userRepository.createQueryBuilder('user');

    if (role) {
      queryBuilder.where('user.role = :role', { role });
    }

    if (sortBy) {
      const validSortFields = ['name', 'createdAt', 'email'];
      if (validSortFields.includes(sortBy)) {
        queryBuilder.orderBy(`user.${sortBy}`, order || 'ASC');
      }
    }

    return queryBuilder.getMany();
  }

  async findOne(id: number): Promise<User> {
    const user = await this.userRepository.findOne({
      where: { id },
      relations: ['assignedClients'],
    });

    if (!user) {
      throw new NotFoundException('Usuário não encontrado');
    }

    return user;
  }

  async update(
    id: number,
    updateUserDto: UpdateUserDto,
    requestingUser: any,
  ): Promise<User> {
    const user = await this.findOne(id);

    if (
      requestingUser.role !== UserRole.ADMIN &&
      requestingUser.id !== user.id
    ) {
      throw new ForbiddenException(
        'Você não tem permissão para atualizar este usuário',
      );
    }

    if (updateUserDto.email && updateUserDto.email !== user.email) {
      const existingUser = await this.userRepository.findOne({
        where: { email: updateUserDto.email },
      });

      if (existingUser) {
        throw new BadRequestException('Email já está em uso');
      }
    }

    await this.userRepository.update(id, updateUserDto);
    return this.findOne(id);
  }

  async updatePassword(
    id: number,
    updatePasswordDto: UpdatePasswordDto,
    requestingUser: any,
  ): Promise<void> {
    const user = await this.findOne(id);

    if (
      requestingUser.role !== UserRole.ADMIN &&
      requestingUser.id !== user.id
    ) {
      throw new ForbiddenException(
        'Você não tem permissão para atualizar a senha deste usuário',
      );
    }

    const isCurrentPasswordValid = await bcrypt.compare(
      updatePasswordDto.currentPassword,
      user.password,
    );

    if (!isCurrentPasswordValid) {
      throw new BadRequestException('Senha atual incorreta');
    }

    const hashedNewPassword = await bcrypt.hash(
      updatePasswordDto.newPassword,
      10,
    );

    await this.userRepository.update(id, { password: hashedNewPassword });
  }

  async remove(id: number, requestingUser: any): Promise<void> {
    const user = await this.findOne(id);

    if (requestingUser.role !== UserRole.ADMIN) {
      throw new ForbiddenException(
        'Você não tem permissão para excluir usuários',
      );
    }

    if (requestingUser.id === user.id) {
      throw new BadRequestException('Você não pode excluir sua própria conta');
    }

    await this.userRepository.remove(user);
  }

  async findInactiveUsers(days: number = 30): Promise<User[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    return this.userRepository
      .createQueryBuilder('user')
      .where('user.lastLoginAt < :cutoffDate OR user.lastLoginAt IS NULL', {
        cutoffDate,
      })
      .getMany();
  }
}
