import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { ClientsService } from './clients.service';
import { CreateClientDto } from './dto/create-client.dto';
import { UpdateClientDto } from './dto/update-client.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';
import { ClientStatus } from './entities/client.entity';

@ApiTags('Clients')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('clients')
export class ClientsController {
  constructor(private readonly clientsService: ClientsService) {}

  @ApiOperation({ summary: 'Criar novo cliente' })
  @ApiResponse({ status: 201, description: 'Cliente criado com sucesso' })
  @ApiResponse({ status: 400, description: 'CNPJ já está cadastrado' })
  @Post()
  create(@Body() createClientDto: CreateClientDto) {
    return this.clientsService.create(createClientDto);
  }

  @ApiOperation({ summary: 'Listar clientes com filtros' })
  @ApiResponse({ status: 200, description: 'Lista de clientes' })
  @ApiQuery({ name: 'name', required: false, description: 'Buscar por nome' })
  @ApiQuery({ name: 'cnpj', required: false, description: 'Buscar por CNPJ' })
  @ApiQuery({ name: 'city', required: false, description: 'Buscar por cidade' })
  @ApiQuery({
    name: 'status',
    enum: ClientStatus,
    required: false,
    description: 'Filtrar por status',
  })
  @ApiQuery({
    name: 'sortBy',
    enum: ['storeFrontName', 'companyName', 'createdAt', 'status'],
    required: false,
    description: 'Ordenar por campo',
  })
  @ApiQuery({
    name: 'order',
    enum: ['ASC', 'DESC'],
    required: false,
    description: 'Ordem da ordenação',
  })
  @Get()
  findAll(
    @Request() req: any,
    @Query('name') name?: string,
    @Query('cnpj') cnpj?: string,
    @Query('city') city?: string,
    @Query('status') status?: ClientStatus,
    @Query('sortBy') sortBy?: string,
    @Query('order') order?: 'ASC' | 'DESC',
  ) {
    return this.clientsService.findAll(
      req.user,
      name,
      cnpj,
      city,
      status,
      sortBy,
      order,
    );
  }

  @ApiOperation({ summary: 'Buscar cliente por ID' })
  @ApiResponse({ status: 200, description: 'Cliente encontrado' })
  @ApiResponse({ status: 404, description: 'Cliente não encontrado' })
  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number, @Request() req: any) {
    return this.clientsService.findOne(id, req.user);
  }

  @ApiOperation({ summary: 'Atualizar dados do cliente' })
  @ApiResponse({ status: 200, description: 'Cliente atualizado com sucesso' })
  @ApiResponse({ status: 400, description: 'CNPJ já está cadastrado' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiResponse({ status: 404, description: 'Cliente não encontrado' })
  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateClientDto: UpdateClientDto,
    @Request() req: any,
  ) {
    return this.clientsService.update(id, updateClientDto, req.user);
  }

  @ApiOperation({ summary: 'Excluir cliente (apenas admins)' })
  @ApiResponse({ status: 200, description: 'Cliente excluído com sucesso' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiResponse({ status: 404, description: 'Cliente não encontrado' })
  @Roles(UserRole.ADMIN)
  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number, @Request() req: any) {
    return this.clientsService.remove(id, req.user);
  }

  @ApiOperation({ summary: 'Atribuir usuário ao cliente (apenas admins)' })
  @ApiResponse({
    status: 200,
    description: 'Usuário atribuído ao cliente com sucesso',
  })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiResponse({ status: 404, description: 'Cliente não encontrado' })
  @Roles(UserRole.ADMIN)
  @Patch(':clientId/assign/:userId')
  assignUser(
    @Param('clientId', ParseIntPipe) clientId: number,
    @Param('userId', ParseIntPipe) userId: number,
    @Request() req: any,
  ) {
    return this.clientsService.assignUserToClient(clientId, userId, req.user);
  }
}
