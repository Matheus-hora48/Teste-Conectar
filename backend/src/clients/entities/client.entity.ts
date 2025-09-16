import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum ClientStatus {
  ACTIVE = 'Ativo',
  INACTIVE = 'Inativo',
  PENDING = 'Pendente',
}

@Entity()
export class Client {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  storeFrontName: string;

  @Column({ unique: true })
  cnpj: string;

  @Column()
  companyName: string;

  @Column()
  cep: string;

  @Column()
  street: string;

  @Column()
  neighborhood: string;

  @Column()
  city: string;

  @Column()
  state: string;

  @Column()
  number: string;

  @Column({ nullable: true })
  complement: string;

  @Column({
    type: 'text',
    enum: ClientStatus,
    default: ClientStatus.ACTIVE,
  })
  status: ClientStatus;

  @Column({ nullable: true })
  phone: string;

  @Column({ nullable: true })
  email: string;

  @Column({ nullable: true })
  contactPerson: string;

  @ManyToOne(() => User, (user) => user.assignedClients, { nullable: true })
  @JoinColumn({ name: 'assignedUserId' })
  assignedUser: User;

  @Column({ nullable: true })
  assignedUserId: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
