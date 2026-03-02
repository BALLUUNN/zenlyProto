# Proto Contracts - Zenly Clone

Централизованный репозиторий gRPC контрактов для микросервисной архитектуры.

## 🚀 Автоматизация

Репозиторий использует **GitHub Actions** для полной автоматизации:

### 1. Автоматическая генерация кода
**Workflow**: [`.github/workflows/generate-code.yml`](.github/workflows/generate-code.yml)

При изменении `.proto` файлов:
- ✅ Автоматически запускается линтер (`buf lint`)
- ✅ Проверяются breaking changes (в PR)
- ✅ Генерируется код для Go, C++, OpenAPI
- ✅ Код автоматически коммитится обратно в репозиторий

### 2. Автоматическое тегирование
**Workflow**: [`.github/workflows/auto-tag.yml`](.github/workflows/auto-tag.yml)

При push в `main`:
- Анализирует commit message
- Автоматически создает тег по Semantic Versioning

**Правила версионирования:**
```bash
# Patch (v1.0.0 -> v1.0.1) - по умолчанию
git commit -m "fix: исправил баг в auth"

# Minor (v1.0.0 -> v1.1.0)
git commit -m "feat: добавил метод GetProfile"

# Major (v1.0.0 -> v2.0.0)
git commit -m "feat: новая логика auth
BREAKING CHANGE: удалил поле password"
```

### 3. Создание релизов
**Workflow**: [`.github/workflows/release.yml`](.github/workflows/release.yml)

При создании тега (`v*.*.*`):
- ✅ Генерирует код
- ✅ Создает архив с контрактами
- ✅ Публикует GitHub Release с changelog
- ✅ Прикрепляет артефакты

## 📁 Структура проекта

```
proto-contracts/
├── proto/                  # Исходные .proto файлы
│   └── auth/
│       └── v1/
│           └── auth.proto
│
├── gen/                    # Сгенерированный код (автоматически)
│   ├── go/
│   ├── cpp/
│   └── openapiv2/
│
├── .github/workflows/      # CI/CD автоматизация
│   ├── generate-code.yml
│   ├── auto-tag.yml
│   └── release.yml
│
├── buf.yaml               # Конфигурация buf
├── buf.gen.yaml           # Настройки генерации
└── Makefile               # Команды для локальной разработки
```

## 🛠 Локальная разработка

### Установка инструментов
```bash
make install-tools
```

### Генерация кода
```bash
make generate
```

### Линтинг
```bash
make lint
```

### Проверка breaking changes
```bash
make breaking
```

## 📦 Использование в проектах

### Go
```bash
# Скачиваем конкретную версию
go get github.com/YOUR_USERNAME/YOUR_REPO@v1.0.0
```

```go
import (
    authv1 "github.com/YOUR_USERNAME/YOUR_REPO/gen/go/auth/v1"
)

// Используем
client := authv1.NewAuthServiceClient(conn)
```

### C++
1. Скачайте release архив
2. Распакуйте `gen/cpp/` в ваш проект
3. Добавьте в CMakeLists.txt:
```cmake
include_directories(${CMAKE_SOURCE_DIR}/gen/cpp)
```

## 🔄 Workflow разработки

### 1. Создание нового API
```bash
# 1. Создайте proto файл
vim proto/auth/v1/auth.proto

# 2. Сгенерируйте локально для проверки
make generate

# 3. Закоммитьте изменения
git add proto/
git commit -m "feat: добавил метод Register"
git push origin main

# 4. GitHub Actions автоматически:
#    - Сгенерирует код
#    - Создаст новый тег (v1.1.0)
#    - Опубликует релиз
```

### 2. Breaking Change
```bash
git commit -m "feat: переделал авторизацию

BREAKING CHANGE: удалил поле email, теперь только phone"
git push

# Actions создаст тег v2.0.0
```

## 📋 Требования к окружению

- **Go**: 1.22+
- **Buf**: latest (устанавливается автоматически)
- **Git**: для версионирования

## 🔧 Настройка репозитория

**Важно!** После создания репозитория на GitHub:

1. Отредактируйте [`buf.gen.yaml`](buf.gen.yaml):
   ```yaml
   managed:
     override:
       - file_option: go_package_prefix
         value: github.com/YOUR_USERNAME/YOUR_REPO/gen/go
   ```

2. Отредактируйте [`.github/workflows/release.yml`](.github/workflows/release.yml):
   - Замените `YOUR_USERNAME/YOUR_REPO` на ваши данные

3. Включите GitHub Actions:
   - Settings → Actions → General → Allow all actions

4. Дайте права на запись:
   - Settings → Actions → General → Workflow permissions → Read and write permissions

## 📖 Документация

- [Buf Documentation](https://buf.build/docs)
- [gRPC Gateway](https://grpc-ecosystem.github.io/grpc-gateway/)
- [Protocol Buffers](https://protobuf.dev)

## 📄 Лицензия

MIT
