import {
  Controller,
  Post,
  Body,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
  Get,
  Res,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';
import type { Response } from 'express';
import { AuthService } from './auth.service';
import { LocalAuthGuard } from './guards/local-auth.guard';
import { GoogleAuthGuard } from './guards/google-auth.guard';
import { MicrosoftAuthGuard } from './guards/microsoft-auth.guard';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @ApiOperation({ summary: 'Login do usuário' })
  @ApiResponse({
    status: 200,
    description: 'Login realizado com sucesso',
    schema: {
      type: 'object',
      properties: {
        access_token: { type: 'string' },
        user: {
          type: 'object',
          properties: {
            id: { type: 'number' },
            name: { type: 'string' },
            email: { type: 'string' },
            role: { type: 'string' },
          },
        },
      },
    },
  })
  @ApiResponse({ status: 401, description: 'Credenciais inválidas' })
  @ApiBody({ type: LoginDto })
  @UseGuards(LocalAuthGuard)
  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Request() req: any, @Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @ApiOperation({ summary: 'Registro de novo usuário' })
  @ApiResponse({
    status: 201,
    description: 'Usuário criado com sucesso',
    schema: {
      type: 'object',
      properties: {
        access_token: { type: 'string' },
        user: {
          type: 'object',
          properties: {
            id: { type: 'number' },
            name: { type: 'string' },
            email: { type: 'string' },
            role: { type: 'string' },
          },
        },
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Email já está em uso' })
  @ApiBody({ type: RegisterDto })
  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }

  @ApiOperation({ summary: 'Iniciar autenticação Google OAuth' })
  @ApiResponse({
    status: 302,
    description: 'Redirecionamento para Google OAuth',
  })
  @UseGuards(GoogleAuthGuard)
  @Get('google')
  async googleAuth(@Request() req: any) {}

  @ApiOperation({ summary: 'Callback Google OAuth' })
  @ApiResponse({
    status: 200,
    description: 'Login realizado com sucesso via Google',
  })
  @UseGuards(GoogleAuthGuard)
  @Get('google/callback')
  async googleAuthRedirect(@Request() req: any, @Res() res: Response) {
    const result = await this.authService.oauthLogin(req.user);

    const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:8080';
    res.redirect(`${frontendUrl}/#/auth/callback?token=${result.access_token}`);
  }

  @ApiOperation({ summary: 'Iniciar autenticação Microsoft OAuth' })
  @ApiResponse({
    status: 302,
    description: 'Redirecionamento para Microsoft OAuth',
  })
  @UseGuards(MicrosoftAuthGuard)
  @Get('microsoft')
  async microsoftAuth(@Request() req: any) {}

  @ApiOperation({ summary: 'Callback Microsoft OAuth' })
  @ApiResponse({
    status: 200,
    description: 'Login realizado com sucesso via Microsoft',
  })
  @UseGuards(MicrosoftAuthGuard)
  @Get('microsoft/callback')
  async microsoftAuthRedirect(@Request() req: any, @Res() res: Response) {
    const result = await this.authService.oauthLogin(req.user);

    const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:8080';
    res.redirect(`${frontendUrl}/#/auth/callback?token=${result.access_token}`);
  }
}
