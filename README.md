# 🌐 Zenly Protobuf Contracts

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Format & Lint](https://img.shields.io/badge/Buf-Lint_&_Format-brightgreen.svg)](https://buf.build/)

> Централизованный репозиторий gRPC контрактов для микросервисной архитектуры проекта **Zenly Clone**.

Этот репозиторий содержит `Protobuf` схемы (`.proto`) и автоматически генерируемый код клиентов, серверов и Swagger-спецификаций. Настроен для модульной системы, поэтому каждый микросервис версионируется изолированно.

---

## 📂 Структура репозитория

```text
zenlyProto/
├── proto/                  # Исходные .proto файлы (Источник истины)
│   └── auth/               # Название сервиса
│       └── v1/             # Версия API
│           └── auth.proto
├── gen/                    # Авто-сгенерированный код
│   ├── go/                 # Код для Golang (gRPC и grpc-gateway)
│   ├── cpp/                # Код для C++
│   └── openapiv2/          # Swagger/OpenAPI спецификации (.json)
├── .github/workflows/      # Пайплайны CI/CD (lint, generate, tag, release)
├── buf.yaml                # Главный конфигурационный файл Buf
├── buf.gen.yaml            # Правила кодогенерации
├── Makefile                # Команды для локальной разработки
└── LICENSE                 # Лицензия проекта (MIT)
```

---

## 🚀 Автоматизация (CI/CD)

### 1. Генерация (Pull Request / Main)
При любом пуше в `main` или создании PR, который затрагивает `proto/**/*.proto`:
1. Запускается `buf lint` — проверка стиля `.proto` файлов.
2. Проверяется обратная совместимость (на фазе PR) через `buf breaking`.
3. Генерируется код для Go, C++ и Swagger JSON документация.
4. Результат автоматически коммитится в ветку.

### 2. Версионирование сервисов (Auto-Tagging)
Мы применяем SemVer, но для **каждого микросервиса отдельно**.  
Если вы меняете `proto/auth/v1/auth.proto`, бот создаст тег формата `auth/vX.Y.Z`. 

Тип инкремента версии определяется по коммит-сообщению:
- `исправление auth.proto` -> Patch (`auth/v1.0.1`) — по умолчанию.
- `feat: новый метод` -> Minor (`auth/v1.1.0`)
- `BREAKING CHANGE: ...` -> Major (`auth/v2.0.0`)

### 3. Релизы
При добавлении нового тега (например, `auth/v1.0.1`), GitHub Actions собирает Release-архив (например, `proto-contracts-auth-v1.0.1.tar.gz`), упрощающий подключение без использования `go get` для других языков.

---

## 💻 Локальная разработка

### Требования
- Go 1.22+
- `make`

### Быстрый старт
Установите необходимые утилиты (`buf` и плагины):
```bash
make install-tools
```

Сгенерируйте код после внесения изменений в `.proto`:
```bash
make generate
```

Проверьте корректность стилей и структуры пакетов:
```bash
make lint       # Поиск ошибок
make format     # Автоформатирование кода
```

---

## 📦 Использование в проектах

### Golang
В ваших микросервисах на Go просто скачайте нужную версию контрактов, указав микросервисный тег:

```bash
# Получение контрактов для auth сервиса версии 1.0.1
go get github.com/BALLUUNN/zenlyProto@auth/v1.0.1
```

Подключение в коде:

```go
package main

import (
    authv1 "github.com/BALLUUNN/zenlyProto/gen/go/auth/v1"
)

func main() {
    // Используйте сгенерированные интерфейсы и структуры
    // authv1.NewAuthServiceClient(conn)
}
```

### C++ и другие языки
Для использования в проектах не на Go (например, C++):
1. Перейдите на вкладку [Releases](../../releases).
2. Скачайте нужный архив (например, `proto-contracts-auth-vX.Y.Z.tar.gz`).
3. Подключите `.h` и `.cc` из папки `gen/cpp/` к вашему дереву сборки.
3. Распакуйте содержимое папки `gen/cpp/` в директорию вашего проекта.
4. Подключите файлы в `CMakeLists.txt`:
```cmake
include_directories(${CMAKE_SOURCE_DIR}/gen/cpp)
```


