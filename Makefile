.PHONY: help generate lint breaking clean install-tools

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install-tools: 
	@echo "Устанавливаем buf..."
	@go install github.com/bufbuild/buf/cmd/buf@latest
	@echo "Устанавливаем protoc плагины..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	@echo "Все инструменты установлены"

generate: 
	@echo "Обновляем зависимости buf.lock..."
	@buf dep update
	@echo "Генерируем код..."
	@buf generate
	@echo "Собираем документацию..."
	@mkdir -p docs
	@cp gen/openapiv2/api.swagger.json docs/api.swagger.json 2>/dev/null || true
	@sed -i 's|../gen/openapiv2/api.swagger.json|api.swagger.json|g' docs/index.html 2>/dev/null || true
	@echo "Код и документация успешно сгенерированы!"

lint: 
	@echo "Запускаем линтер..."
	@buf lint
	@echo "Линтер пройден"

breaking: 
	@echo "Проверяем breaking changes..."
	@buf breaking --against '.git#branch=main'
	@echo "Breaking changes не обнаружены"

clean:
	@echo "Удаляем gen/..."
	@rm -rf gen/
	@echo "Очистка завершена"

format: 
	@echo "Форматируем proto файлы..."
	@buf format -w
	@echo "Форматирование завершено"
