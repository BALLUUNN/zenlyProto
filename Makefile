.PHONY: help generate lint breaking clean install-tools

help: ## Показать справку
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install-tools: ## Установить необходимые инструменты
	@echo "Устанавливаем buf..."
	@go install github.com/bufbuild/buf/cmd/buf@latest
	@echo "Устанавливаем protoc плагины..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	@echo "✅ Все инструменты установлены"

generate: ## Сгенерировать код из proto файлов
	@echo "Генерируем код..."
	@buf generate
	@echo "✅ Код успешно сгенерирован в папку gen/"

lint: ## Проверить proto файлы на ошибки
	@echo "Запускаем линтер..."
	@buf lint
	@echo "✅ Линтер пройден"

breaking: ## Проверить breaking changes
	@echo "Проверяем breaking changes..."
	@buf breaking --against '.git#branch=main'
	@echo "✅ Breaking changes не обнаружены"

clean: ## Удалить сгенерированный код
	@echo "Удаляем gen/..."
	@rm -rf gen/
	@echo "✅ Очистка завершена"

format: ## Форматировать proto файлы
	@echo "Форматируем proto файлы..."
	@buf format -w
	@echo "✅ Форматирование завершено"
