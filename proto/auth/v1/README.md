# Auth Service v1

Этот каталог содержит контракт версии v1 для сервиса аутентификации.

## Назначение

Auth Service отвечает за:

- регистрацию пользователей и подтверждение телефона;
- вход в систему с 2FA по SMS;
- верификацию email;
- смену номера телефона;
- обновление токенов и выход;
- восстановление и сброс пароля.

## Файлы

- [auth.proto](auth.proto) — основной контракт сервиса (gRPC + HTTP аннотации).

## Генерация

Генерируемые артефакты находятся в:

- [gen/go/auth/v1](../../../gen/go/auth/v1)
- [gen/cpp/auth/v1](../../../gen/cpp/auth/v1)
- [gen/openapiv2/auth/v1](../../../gen/openapiv2/auth/v1)

## Документация

- HTML: [docs/index.html](../../../docs/index.html)
- OpenAPI: [docs/api.swagger.json](../../../docs/api.swagger.json)
- OpenAPI (auth): [gen/openapiv2/auth/v1/auth.swagger.json](../../../gen/openapiv2/auth/v1/auth.swagger.json)