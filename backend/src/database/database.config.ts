import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { User } from '../users/entities/user.entity';
import { Client } from '../clients/entities/client.entity';

export const databaseConfig: TypeOrmModuleOptions = {
  type: 'sqlite',
  database: 'database.sqlite',
  entities: [User, Client],
  synchronize: true,
  logging: false,
};
