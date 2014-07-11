VERSION = $(shell head -1 VERSION)
NAME = feed-notify
FPM_PREFIX = /usr/local/bin
FPM_URL = https://github.com/lukaszkorecki/feed-notify
FPM_AUTHOR = lukasz@coffeesounds.com

.PHONY: build test fmt dependencies release tag package run

build: test
	@mkdir -p bin/
	go build -o bin/$(NAME) -ldflags "-X main.Version $(VERSION)"

fmt:
	go fmt ./...

run:
	./bin/$(NAME)

test:
	go test ./...

release: tag package publish

tag:
	git commit -m "Release: v$(VERSION)"
	git tag v$(VERSION)

package:
	mkdir -p pkg/
	mkdir -p tmp/
	cp bin/$(NAME) tmp/
	fpm -C tmp/ -t deb -s dir -n $(NAME) -v $(VERSION) --prefix $(FPM_PREFIX) --provides $(NAME) --url $(FPM_URL)  --vendor $(FPM_AUTHOR) --force .
	mv $(NAME)_$(VERSION)_amd64.deb pkg/
	rm -r tmp/
