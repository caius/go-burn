THIS_MAKEFILE_PATH:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_DIR:=$(shell cd $(dir $(THIS_MAKEFILE_PATH)); pwd)

GIT_COMMIT = $(shell git rev-parse --short HEAD)
GIT_STATUS = $(shell test -n "`git status --porcelain`" && echo "+CHANGES")

COMPONENTS = burn

BUILD_OPTIONS = -ldflags "-X main.GitCommit $(GIT_COMMIT)$(GIT_STATUS) -X main.BuiltBy $(shell whoami) -w"

#
# Build Targets, for development
#
run: | install
	bin/burn

install: | submodules
	GOPATH=$(THIS_DIR) go install $(BUILD_OPTIONS) burn

# Yes, I typo this often
isntall: | install

test: | submodules
	GOPATH=$(THIS_DIR) go test -i $(COMPONENTS)
	GOPATH=$(THIS_DIR) go test -v $(COMPONENTS) #| script/colorise_gotest_output.pl

#
# Format our packages
#
fmt:
	GOPATH=$(THIS_DIR) go fmt $(COMPONENTS)

#
# Doc, godoc is amazing
#
doc:
	# Amazinging, the godoc server starts before the browser does normally!
	GOPATH=$(THIS_DIR) godoc -http=:6060
	open "http://localhost:6060/pkg/gobot/"

#
# Downloads and prepares submodules
#
submodules:
	git submodule update --init --recursive

#
# Cleans out build products
#
clean:
	find {bin,pkg} -mindepth 1 -not -name '.gitkeep' -delete

.PHONY: clean submodules fmt run install test
