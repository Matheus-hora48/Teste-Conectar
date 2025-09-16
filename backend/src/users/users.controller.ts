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
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdatePasswordDto } from './dto/update-password.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from './entities/user.entity';

@ApiTags('Users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @ApiOperation({ summary: 'Criar novo usuário (apenas admins)' })
  @ApiResponse({ status: 201, description: 'Usuário criado com sucesso' })
  @ApiResponse({ status: 400, description: 'Email já está em uso' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @Roles(UserRole.ADMIN)
  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @ApiOperation({ summary: 'Listar todos os usuários (apenas admins)' })
  @ApiResponse({ status: 200, description: 'Lista de usuários' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiQuery({ name: 'role', enum: UserRole, required: false })
  @ApiQuery({
    name: 'sortBy',
    enum: ['name', 'createdAt', 'email'],
    required: false,
  })
  @ApiQuery({ name: 'order', enum: ['ASC', 'DESC'], required: false })
  @Roles(UserRole.ADMIN)
  @Get()
  findAll(
    @Query('role') role?: UserRole,
    @Query('sortBy') sortBy?: string,
    @Query('order') order?: 'ASC' | 'DESC',
  ) {
    return this.usersService.findAll(role, sortBy, order);
  }

  @ApiOperation({ summary: 'Buscar usuário por ID' })
  @ApiResponse({ status: 200, description: 'Usuário encontrado' })
  @ApiResponse({ status: 404, description: 'Usuário não encontrado' })
  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number, @Request() req: any) {
    if (req.user.role !== UserRole.ADMIN && req.user.id !== id) {
      throw new Error('Você não tem permissão para acessar este perfil');
    }
    return this.usersService.findOne(id);
  }

  @ApiOperation({ summary: 'Atualizar dados do usuário' })
  @ApiResponse({ status: 200, description: 'Usuário atualizado com sucesso' })
  @ApiResponse({ status: 400, description: 'Email já está em uso' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiResponse({ status: 404, description: 'Usuário não encontrado' })
  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateUserDto: UpdateUserDto,
    @Request() req: any,
  ) {
    return this.usersService.update(id, updateUserDto, req.user);
  }

  @ApiOperation({ summary: 'Atualizar senha do usuário' })
  @ApiResponse({ status: 200, description: 'Senha atualizada com sucesso' })
  @ApiResponse({ status: 400, description: 'Senha atual incorreta' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiResponse({ status: 404, description: 'Usuário não encontrado' })
  @Patch(':id/password')
  updatePassword(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePasswordDto: UpdatePasswordDto,
    @Request() req: any,
  ) {
    return this.usersService.updatePassword(id, updatePasswordDto, req.user);
  }

  @ApiOperation({ summary: 'Excluir usuário (apenas admins)' })
  @ApiResponse({ status: 200, description: 'Usuário excluído com sucesso' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiResponse({ status: 404, description: 'Usuário não encontrado' })
  @Roles(UserRole.ADMIN)
  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number, @Request() req: any) {
    return this.usersService.remove(id, req.user);
  }

  @ApiOperation({ summary: 'Listar usuários inativos (apenas admins)' })
  @ApiResponse({ status: 200, description: 'Lista de usuários inativos' })
  @ApiResponse({ status: 403, description: 'Acesso negado' })
  @ApiQuery({
    name: 'days',
    type: 'number',
    required: false,
    description: 'Número de dias para considerar inativo (padrão: 30)',
  })
  @Roles(UserRole.ADMIN)
  @Get('inactive/list')
  findInactiveUsers(@Query('days', ParseIntPipe) days?: number) {
    return this.usersService.findInactiveUsers(days);
  }

  @ApiOperation({ summary: 'Obter perfil do usuário logado' })
  @ApiResponse({ status: 200, description: 'Perfil do usuário' })
  @Get('profile/me')
  getProfile(@Request() req: any) {
    return this.usersService.findOne(req.user.id);
  }

  @ApiOperation({ summary: 'Atualizar perfil do usuário logado' })
  @ApiResponse({ status: 200, description: 'Perfil atualizado com sucesso' })
  @ApiResponse({ status: 400, description: 'Email já está em uso' })
  @Patch('profile/me')
  updateProfile(@Body() updateUserDto: UpdateUserDto, @Request() req: any) {
    return this.usersService.update(req.user.id, updateUserDto, req.user);
  }

  @ApiOperation({ summary: 'Atualizar senha do usuário logado' })
  @ApiResponse({ status: 200, description: 'Senha atualizada com sucesso' })
  @ApiResponse({ status: 400, description: 'Senha atual incorreta' })
  @Patch('profile/me/password')
  updateProfilePassword(
    @Body() updatePasswordDto: UpdatePasswordDto,
    @Request() req: any,
  ) {
    return this.usersService.updatePassword(
      req.user.id,
      updatePasswordDto,
      req.user,
    );
  }
}
