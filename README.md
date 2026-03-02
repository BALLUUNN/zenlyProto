# Proto Contracts - Zenly Clone

Централизованный репозиторий gRPC контрактов для микросервисной архитектуры.

## Автоматизация

Репозиторий использует **GitHub Actions** для полной автоматизации:

### 1. Автоматическая генерация кода
**Workflow**: [`.github/workflows/generate-code.yml`](.github/workflows/generate-code.yml)

При изменении `.proto` файлов:
- Автоматически запускается линтер (`buf lint`)
- Проверяются breaking changes (в PR)
- Генерируется код для Go, C++, OpenAPI
- Код автоматически коммитится обратно в репозиторий

### 2. Автоматическое тегирование
**Workflow**: [`.github/workflows/auto-tag.yml`](.github/workflows/auto-tag.yml)

При push в `main`:
- Анализирует commit message
- Автоматически создает тег по Semantic Versioning

**Правила версионирования:**
```bash
git commit -m "something..."

git commit -m "something..."

git commit -m "something..."
```

### 3. Создание релизов
**Workflow**: [`.github/workflows/release.yml`](.github/workflows/release.yml)

При создании тега (`v*.*.*`):
- Генерирует код
- Создает архив с контрактами
- Публикует GitHub Release с changelog
- Прикрепляет артефакты


## Локальная разработка

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

## Использование в проектах

### Go
```bash
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


