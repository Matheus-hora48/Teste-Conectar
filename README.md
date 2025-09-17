# Sistema de Gerenciamento de Usuários - Conéctar

## Visão Geral

Sistema completo para gerenciamento de usuários da Conéctar, desenvolvido com NestJS (backend) e Flutter (frontend), seguindo as melhores práticas de arquitetura e segurança.

## Arquitetura do Sistema

### Backend (NestJS)

- **Framework**: NestJS com TypeScript
- **Banco de Dados**: SQLite com TypeORM
- **Autenticação**: JWT + bcrypt
- **Documentação**: Swagger
- **Testes**: Jest
- **Arquitetura**: Clean Architecture com separação por módulos

### Frontend (Flutter)

- **Framework**: Flutter
- **Gerenciamento de Estado**: GetX (escolhido pela performance e simplicidade)
- **HTTP Client**: Dio
- **Roteamento**: go_router
- **Armazenamento Seguro**: flutter_secure_storage
- **Testes**: flutter_test + mocktail

## Estrutura do Projeto

```
teste-conectar/
├── backend/                 # API NestJS
│   ├── src/
│   │   ├── auth/           # Módulo de autenticação
│   │   ├── users/          # Módulo de usuários
│   │   ├── clients/        # Módulo de clientes
│   │   ├── common/         # Utilitários compartilhados
│   │   └── database/       # Configuração do banco
│   ├── test/               # Testes automatizados
│   └── docs/               # Documentação da API
└── frontend/               # App Flutter
    ├── lib/
    │   ├── core/           # Configurações e utilitários
    │   ├── features/       # Funcionalidades por módulo
    │   │   ├── auth/       # Autenticação
    │   │   ├── users/      # Gerenciamento de usuários
    │   │   └── clients/    # Gerenciamento de clientes
    │   └── shared/         # Componentes compartilhados
    └── test/               # Testes automatizados
```

## Decisões de Arquitetura

### Backend

1. **NestJS**: Framework robusto com suporte nativo ao TypeScript, decorators e injeção de dependência
2. **TypeORM**: ORM maduro com suporte completo ao TypeScript
3. **JWT**: Padrão da indústria para autenticação stateless
4. **Swagger**: Documentação automática da API
5. **Modular Architecture**: Separação clara de responsabilidades

### Frontend

1. **GetX**: Escolhido por sua performance superior e sintaxe simples
2. **go_router**: Roteamento declarativo e type-safe
3. **Dio**: Cliente HTTP com interceptors e configuração avançada
4. **flutter_secure_storage**: Armazenamento seguro de tokens
5. **Clean Architecture**: Separação em camadas (presentation, domain, data)

## Requisitos de Sistema

### Backend

- Node.js 18+
- npm ou yarn
- SQLite

### Frontend

- Flutter 3.16+
- Dart 3.2+
- Android Studio / Xcode (para emuladores)

## Configuração e Execução

### 1. Backend

```bash
cd backend
npm install
npm run start:dev
```

### 2. Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## Usuários de Teste

### Administrador

- Email: admin@conectar.com
- Senha: admin123

### Usuário Regular

- Email: user@conectar.com
- Senha: user123

## Documentação da API

Após iniciar o backend, acesse:

- Swagger UI: https://teste-conectar.onrender.com/api
- JSON Schema: https://teste-conectar.onrender.com/api-json

## Documentação da API  

Link do front
 - https://front-test-conecta.vercel.app

## Testes

### Backend

```bash
cd backend
npm run test
npm run test:e2e
npm run test:cov
```

### Frontend

```bash
cd frontend
flutter test
```

## Deploy

### Backend

- Render
- Variáveis de ambiente necessárias no .env.example

### Frontend

- Web: Vercel