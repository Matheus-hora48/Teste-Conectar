import {
  Injectable,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    // Log para debug
    const request = context.switchToHttp().getRequest() as any;
    const authHeader = request.headers?.authorization as string;

    return super.canActivate(context);
  }

  handleRequest(err: any, user: any, info: any): any {
    if (err || !user) {
      let message = 'Token inválido ou expirado';

      if (info) {
        if (info?.name === 'TokenExpiredError') {
          message = 'Token expirado';
        } else if (info?.name === 'JsonWebTokenError') {
          message = 'Token malformado';
        } else if (info?.name === 'NotBeforeError') {
          message = 'Token não ativo ainda';
        } else if (info?.message) {
          message = `Erro no token: ${info.message}`;
        }
      }

      throw new UnauthorizedException(message);
    }

    return user;
  }
}
