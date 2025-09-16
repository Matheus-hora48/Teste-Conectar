# Backend API - Sistema Conéctar

API NestJS para gerenciamento de usuários e clientes da Conéctar.

## 🚀 Tecnologias

- **Framework**: NestJS + TypeScript
- **Banco de Dados**: SQLite + TypeORM
- **Autenticação**: JWT + Passport
- **Documentação**: Swagger
- **Validação**: class-validator
- **Criptografia**: bcrypt

## 📋 Pré-requisitos

- Node.js 18+
- npm ou yarn

## 🛠️ Instalação

```bash
# Instalar dependências
npm install

# Iniciar servidor de desenvolvimento
npm run start:dev

# Iniciar servidor de produção
npm run build
npm run start:prod
```

## 🌐 Endpoints

### Autenticação

- `POST /auth/register` - Registro de usuário
- `POST /auth/login` - Login de usuário
- `GET /auth/google` - Iniciar login com Google
- `GET /auth/google/callback` - Callback Google OAuth
- `GET /auth/microsoft` - Iniciar login com Microsoft
- `GET /auth/microsoft/callback` - Callback Microsoft OAuth

### Usuários

- `GET /users` - Listar usuários (admin only)
- `GET /users/:id` - Buscar usuário por ID
- `POST /users` - Criar usuário (admin only)
- `PATCH /users/:id` - Atualizar usuário
- `DELETE /users/:id` - Deletar usuário (admin only)
- `GET /users/profile/me` - Perfil do usuário logado
- `PATCH /users/:id/password` - Atualizar senha
- `GET /users/inactive/list` - Usuários inativos (admin only)

### Clientes

- `GET /clients` - Listar clientes (com filtros)
- `GET /clients/:id` - Buscar cliente por ID
- `POST /clients` - Criar cliente
- `PATCH /clients/:id` - Atualizar cliente
- `DELETE /clients/:id` - Deletar cliente (admin only)
- `PATCH /clients/:clientId/assign/:userId` - Atribuir usuário (admin only)

## 📚 Documentação

Acesse a documentação Swagger em: http://localhost:3000/api

## 🔐 Usuários de Teste

### Administrador

- Email: `admin@conectar.com`
- Senha: `admin123`

### Usuário Regular

- Email: `user@conectar.com`
- Senha: `user123`

## 🧪 Testes

```bash
# Testes unitários
npm run test

# Testes e2e
npm run test:e2e

# Cobertura de testes
npm run test:cov
```

## 🏗️ Arquitetura

```
src/
├── auth/           # Módulo de autenticação
│   ├── dto/        # Data Transfer Objects
│   ├── guards/     # Guards de autenticação
│   ├── strategies/ # Estratégias do Passport
│   └── decorators/ # Decorators customizados
├── users/          # Módulo de usuários
│   ├── entities/   # Entidades TypeORM
│   ├── dto/        # DTOs
│   └── ...
├── clients/        # Módulo de clientes
├── common/         # Utilitários compartilhados
└── database/       # Configuração do banco
```

## 🌍 Variáveis de Ambiente

```env
NODE_ENV=development
JWT_SECRET=sua_chave_secreta_jwt
PORT=3000

# OAuth Google
GOOGLE_CLIENT_ID=seu_google_client_id
GOOGLE_CLIENT_SECRET=seu_google_client_secret
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# OAuth Microsoft
MICROSOFT_CLIENT_ID=seu_microsoft_client_id
MICROSOFT_CLIENT_SECRET=seu_microsoft_client_secret
MICROSOFT_CALLBACK_URL=http://localhost:3000/auth/microsoft/callback

# Frontend URL
FRONTEND_URL=http://localhost:8080
```

### Configuração OAuth

#### Google OAuth 2.0

1. Acesse [Google Cloud Console](https://console.developers.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Ative a Google+ API
4. Vá em "Credenciais" > "Criar credenciais" > "ID do cliente OAuth 2.0"
5. Configure:
   - **Origens JavaScript autorizadas**: `http://localhost:3000`
   - **URIs de redirecionamento**: `http://localhost:3000/auth/google/callback`
6. Copie o Client ID e Client Secret para o arquivo `.env`

#### Microsoft OAuth 2.0

1. Acesse [Azure Portal](https://portal.azure.com/)
2. Vá em "Azure Active Directory" > "Registros de aplicativo"
3. Clique em "Novo registro"
4. Preencha o nome e configure:
   - **URI de redirecionamento**: `http://localhost:3000/auth/microsoft/callback`
5. Após criar, vá em "Certificados e segredos" para gerar um secret
6. Copie o "ID do aplicativo (cliente)" e o secret gerado para o arquivo `.env`

## 📊 Banco de Dados

O banco SQLite é criado automaticamente com dados iniciais (seed) na primeira execução.

### Schema Principal

**Users**

- id, name, email, password, role, lastLoginAt, createdAt, updatedAt

**Clients**

- id, storeFrontName, cnpj, companyName, address fields, status, contact info, assignedUserId, timestamps

## 🔒 Segurança

- Senhas criptografadas com bcrypt
- JWT tokens com expiração
- Validação de entrada em todas as rotas
- Guards de autorização por role
- CORS configurado

## 📈 Performance

- Lazy loading de módulos
- Queries otimizadas com TypeORM
- Validação de entrada eficiente
- Cache de configurações

## 🚀 Deploy

### Heroku

```bash
# Adicionar buildpack do Node.js
heroku buildpacks:add heroku/nodejs

# Configurar variáveis de ambiente
heroku config:set JWT_SECRET=sua_chave_secreta

# Deploy
git push heroku main
```

## Project setup

```bash
$ npm install
```

## Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```