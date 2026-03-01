APP=change_me
VERSION=0.1.0
REVISION=-0
GO_LDFLAGS="-s -w"

.PHONY: all
all:
	@echo 'DEFAULT:      '
	@echo '   make build   - build application'
	@echo '   make tools   - install tools to local ./bin'
	@echo '   make tidy    - go mod tidy'
	@echo '   make lint    - run lint'

.PHONY: build
build:
	@mkdir -p bin
	@go build -trimpath -ldflags=$(GO_LDFLAGS) -o bin/$(APP) main.go

.PHONY: release
release: build
	@mkdir -p dist/$(APP).app/Contents/MacOS
	@mkdir -p dist/$(APP).app/Contents/Resources
	@cp bin/$(APP) dist/$(APP).app/Contents/MacOS
	@envsubst < Info.plist.template > dist/$(APP).app/Contents/Info.plist
	@hdiutil create -volname "$(APP)" -srcfolder dist -ov -format UDZO $(APP).dmg

.PHONY: tools
tools: tidy
	@GOBIN=$(PWD)/bin go install tool
	@echo OK

.PHONY: tidy
tidy:
	@go mod tidy

.PHONY: lint
lint:
	@bin/golangci-lint run
