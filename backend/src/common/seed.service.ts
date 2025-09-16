import { Injectable, OnApplicationBootstrap } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User, UserRole } from '../users/entities/user.entity';
import { Client, ClientStatus } from '../clients/entities/client.entity';

@Injectable()
export class SeedService implements OnApplicationBootstrap {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async onApplicationBootstrap() {
    await this.seedUsers();
    await this.seedClients();
  }

  private async seedUsers() {
    const userCount = await this.userRepository.count();
    if (userCount > 0) {
      return;
    }

    const adminPassword = await bcrypt.hash('admin123', 10);
    const admin = this.userRepository.create({
      name: 'Administrador',
      email: 'admin@conectar.com',
      password: adminPassword,
      role: UserRole.ADMIN,
    });
    await this.userRepository.save(admin);

    const userPassword = await bcrypt.hash('user123', 10);
    const user = this.userRepository.create({
      name: 'Usuário Regular',
      email: 'user@conectar.com',
      password: userPassword,
      role: UserRole.USER,
    });
    await this.userRepository.save(user);

    console.log('✅ Usuários iniciais criados com sucesso!');
  }

  private async seedClients() {
    const clientCount = await this.clientRepository.count();
    if (clientCount > 0) {
      return;
    }

    const regularUser = await this.userRepository.findOne({
      where: { email: 'user@conectar.com' },
    });

    const clients = [
      {
        storeFrontName: 'Padaria do João',
        cnpj: '12.345.678/0001-90',
        companyName: 'João Silva Panificação LTDA',
        cep: '01234-567',
        street: 'Rua das Flores',
        neighborhood: 'Centro',
        city: 'São Paulo',
        state: 'SP',
        number: '123',
        status: ClientStatus.ACTIVE,
        phone: '(11) 99999-9999',
        email: 'contato@padariodojoao.com',
        contactPerson: 'João Silva',
        assignedUserId: regularUser?.id,
      },
      {
        storeFrontName: 'Farmácia Saúde',
        cnpj: '98.765.432/0001-10',
        companyName: 'Saúde Medicamentos LTDA',
        cep: '98765-432',
        street: 'Avenida Principal',
        neighborhood: 'Vila Nova',
        city: 'Rio de Janeiro',
        state: 'RJ',
        number: '456',
        status: ClientStatus.ACTIVE,
        phone: '(21) 88888-8888',
        email: 'contato@farmaciasaude.com',
        contactPerson: 'Maria Santos',
      },
      {
        storeFrontName: 'Loja de Roupas Fashion',
        cnpj: '11.222.333/0001-44',
        companyName: 'Fashion Roupas e Acessórios LTDA',
        cep: '11223-344',
        street: 'Rua da Moda',
        neighborhood: 'Bela Vista',
        city: 'Belo Horizonte',
        state: 'MG',
        number: '789',
        status: ClientStatus.INACTIVE,
        phone: '(31) 77777-7777',
        email: 'contato@fashionroupas.com',
        contactPerson: 'Carlos Oliveira',
      },
    ];

    for (const clientData of clients) {
      const client = this.clientRepository.create(clientData);
      await this.clientRepository.save(client);
    }
  }
}
