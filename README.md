# Flutter Auth - Keycloak & Spring Boot

Este projeto foi criado para praticar autenticação e autorização no Flutter, utilizando um backend em Spring Boot com integração ao Keycloak.

## Tecnologias Utilizadas

### Frontend (Flutter)
- **Linguagem**: Dart
- **Gerenciador de Estado**: Provider
- **Autenticação JWT**: dart_jsonwebtoken
- **Requisições HTTP**: http
- **Armazenamento Local**: shared_preferences

### Backend (Spring Boot)
- **Framework**: Spring Boot
- **Autenticação**: Keycloak
- **Segurança**: Spring Security

## Dependências Flutter

Adicione as seguintes dependências ao seu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.3.0
  provider: ^6.1.4
  dart_jsonwebtoken: ^3.2.0
  shared_preferences: ^2.5.3
```

## Como Rodar o Projeto

### Backend (Spring Boot + Keycloak)
1. Certifique-se de que o Keycloak esteja rodando (via Docker ou standalone).
2. Configure um cliente no Keycloak para permitir autenticação via Flutter.
3. Inicie o backend Spring Boot.

### Frontend (Flutter)
1. Clone este repositório.
2. Instale as dependências:
   ```sh
   flutter pub get
   ```
3. Execute o app:
   ```sh
   flutter run
   ```

## Funcionalidades
- Login e logout utilizando Keycloak.
- Armazenamento do token JWT com SharedPreferences.
- Consumo de API segura do backend Spring Boot.

## Melhorias Futuras
- Renovar automaticamente o token JWT.
- Implementar roles e permissões dinâmicas baseadas no Keycloak.
- Criar testes unitários para as funções de autenticação.

## Contribuição
Sugestões e melhorias são bem-vindas! Abra uma issue ou envie um pull request.