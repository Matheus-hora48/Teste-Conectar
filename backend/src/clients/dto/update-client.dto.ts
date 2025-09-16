import { PartialType, ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsNumber } from 'class-validator';
import { CreateClientDto } from './create-client.dto';

export class UpdateClientDto extends PartialType(CreateClientDto) {
  @ApiProperty({
    description: 'ID do cliente',
    example: 1,
    required: false,
  })
  @IsOptional()
  @IsNumber()
  id?: number;
}
