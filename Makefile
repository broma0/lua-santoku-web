NAME = santoku-web
VERSION = 0.0.2-1
GIT_URL = git+ssh:git@github.com:broma0/lua-santoku-web.git
HOMEPAGE = https://github.com/broma0/lua-santoku-web
LICENSE = MIT

LIBFLAG = -shared

BUILD = build
CONFIG = config

ARCHIVE_NAME = $(NAME)-$(VERSION)
ARCHIVE = $(ARCHIVE_NAME).tar.gz
ROCKSPEC = $(NAME)-$(VERSION).rockspec
ROCKSPEC_T = config/template.rockspec

UPLOADED_FILES = src config Makefile

shared: $(BUILD)/santoku/web/window.so

$(BUILD)/santoku/web/window.so: src/santoku/web/window.cpp $(ROCKSPEC_OUT)
	mkdir -p "$(dir $@)"
	$(CC) $(CFLAGS) $(LDFLAGS) "$^" $(LIBFLAG) -o "$@"

install: shared
	test -n "$(INST_LIBDIR)"
	mkdir -p $(INST_LIBDIR)/santoku/web/
	cp $(BUILD)/santoku/web/window.so $(INST_LIBDIR)/santoku/web/

upload: $(BUILD)/$(ROCKSPEC)
	@if test -z "$(API_KEY)"; then echo "Missing API_KEY variable"; exit 1; fi
	@if ! git diff --quiet; then echo "Commit your changes first"; exit 1; fi
	git tag "$(VERSION)"
	git push --tags 
	cd "$(BUILD)" && rm -rf "$(ARCHIVE_NAME)" "$(ARCHIVE)"
	mkdir -p "$(BUILD)/$(ARCHIVE_NAME)"
	cp -r $(UPLOADED_FILES) "$(BUILD)/$(ARCHIVE_NAME)"
	cd "$(BUILD)" && tar czvf "$(ARCHIVE)" "$(ARCHIVE_NAME)"
	cd "$(BUILD)" && luarocks upload --api-key "$(API_KEY)" "$(ROCKSPEC)"

$(BUILD)/$(ROCKSPEC): $(ROCKSPEC_T)
	NAME="$(NAME)" VERSION="$(VERSION)" \
	HOMEPAGE="$(HOMEPAGE)" LICENSE="$(LICENSE)" \
	ARCHIVE="$(ARCHIVE)" GIT_URL="$(GIT_URL)" \
		toku template -l os \
			-f "$(ROCKSPEC_T)" \
			-o "$(BUILD)/$(ROCKSPEC)"


clean:
	rm -rf $(BUILD)

.PHONY: clean install upload shared
