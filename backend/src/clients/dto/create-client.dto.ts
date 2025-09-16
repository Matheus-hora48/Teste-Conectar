import { ApiProperty } from '@nestjs/swagger';
import {
  IsNotEmpty,
  IsString,
  IsOptional,
  IsEnum,
  IsEmail,
} from 'class-validator';
import { ClientStatus } from '../entities/client.entity';

export class CreateClientDto {
  @ApiProperty({
    description: 'Nome na fachada',
    example: 'Loja do João',
  })
  @IsNotEmpty()
  @IsString()
  storeFrontName: string;

  @ApiProperty({
    description: 'CNPJ da empresa',
    example: '12.345.678/0001-90',
  })
  @IsNotEmpty()
  @IsString()
  cnpj: string;

  @ApiProperty({
    description: 'Razão Social da empresa',
    example: 'João Silva Comércio LTDA',
  })
  @IsNotEmpty()
  @IsString()
  companyName: string;

  @ApiProperty({
    description: 'CEP do endereço',
    example: '01234-567',
  })
  @IsNotEmpty()
  @IsString()
  cep: string;

  @ApiProperty({
    description: 'Rua do endereço',
    example: 'Rua das Flores',
  })
  @IsNotEmpty()
  @IsString()
  street: string;

  @ApiProperty({
    description: 'Bairro do endereço',
    example: 'Centro',
  })
  @IsNotEmpty()
  @IsString()
  neighborhood: string;

  @ApiProperty({
    description: 'Cidade do endereço',
    example: 'São Paulo',
  })
  @IsNotEmpty()
  @IsString()
  city: string;

  @ApiProperty({
    description: 'Estado do endereço',
    example: 'SP',
  })
  @IsNotEmpty()
  @IsString()
  state: string;

  @ApiProperty({
    description: 'Número do endereço',
    example: '123',
  })
  @IsNotEmpty()
  @IsString()
  number: string;

  @ApiProperty({
    description: 'Complemento do endereço',
    example: 'Apto 45',
    required: false,
  })
  @IsOptional()
  @IsString()
  complement?: string;

  @ApiProperty({
    description: 'Status do cliente',
    enum: ClientStatus,
    example: ClientStatus.ACTIVE,
    required: false,
  })
  @IsOptional()
  @IsEnum(ClientStatus)
  status?: ClientStatus;

  @ApiProperty({
    description: 'Telefone do cliente',
    example: '(11) 99999-9999',
    required: false,
  })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiProperty({
    description: 'Email do cliente',
    example: 'contato@lojadojoao.com',
    required: false,
  })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiProperty({
    description: 'Pessoa de contato',
    example: 'João Silva',
    required: false,
  })
  @IsOptional()
  @IsString()
  contactPerson?: string;

  @ApiProperty({
    description: 'ID do usuário responsável',
    example: 1,
    required: false,
  })
  @IsOptional()
  assignedUserId?: number;
}
