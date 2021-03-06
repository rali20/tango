mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

export GOBIN=$(current_dir)/bin

GOCC := gorunpkg github.com/goccmack/gocc
GOFLAGS :=

.PHONY: all clean test runcode

all: vendor bin/tango

debug: GOFLAGS += -tags debug
debug: all

test-debug: GOFLAGS += -tags debug
test-debug: test

vendor:
	dep ensure -v

bin/tango: src/main/tango/tango.go src/lexer/lexer.go src/parser/parser.go src/ast/*.go src/codegen/*.go
	@echo -e "\e[1;32mCompiling Tango \e[0m"
	go install $(GOFLAGS) $(current_dir)/src/main/tango/tango.go

src/lexer/lexer.go: src/tango-main-ir.ebnf
	@echo -e "\e[1;33mGenerating Lexer \e[0m"
	cd $(current_dir)/src && $(GOCC) tango-main-ir.ebnf

src/parser/parser.go: src/tango-main-ir.ebnf
	@echo -e "\e[1;33mGenerating Parser \e[0m"
	cd $(current_dir)/src && $(GOCC) tango-main-ir.ebnf

test:
	go test $(GOFLAGS) src/lexer

asgn2: clean
	mkdir -p asgn2
	mkdir -p asgn2/src
	mkdir -p asgn2/test
	cp README.md asgn2/
	cp Gopkg.lock asgn2/
	cp Gopkg.toml asgn2/
	cp Makefile asgn2/
	cp EffortSheet.pdf asgn2/
	cp -r src asgn2/
	cp -r test asgn2/
	zip -r asgn2 asgn2
	rm -rf asgn2

asgn3: clean
	mkdir -p asgn3
	mkdir -p asgn3/src
	mkdir -p asgn3/test
	cp README.md asgn3/
	cp Gopkg.lock asgn3/
	cp Gopkg.toml asgn3/
	cp Makefile asgn3/
	cp EffortSheet.pdf asgn3/
	cp -r src asgn3/
	cp -r test asgn3/
	zip -r asgn3 asgn3
	rm -rf asgn3

asgn4: clean
	mkdir -p asgn4
	mkdir -p asgn4/src
	mkdir -p asgn4/test
	cp README.md asgn4/
	cp Gopkg.lock asgn4/
	cp Gopkg.toml asgn4/
	cp Makefile asgn4/
	cp EffortSheet.pdf asgn4/
	cp -r src asgn4/
	cp -r test asgn4/
	zip -r asgn4 asgn4
	rm -rf asgn4

final: clean
	mkdir -p final
	mkdir -p final/src
	mkdir -p final/test
	cp README.md final/
	cp Gopkg.lock final/
	cp Gopkg.toml final/
	cp Makefile final/
	cp EffortSheet.pdf final/
	cp -r src final/
	cp -r test final/
	zip -r final final
	rm -rf final


clean:
	@echo -e "\e[1;31mCleaning Files \e[0m"
	@echo -e "\e[1;31m  Clearing pkg and bin \e[0m"
	@rm -rf $(current_dir)/pkg $(current_dir)/bin/**
	@echo -e "\e[1;31m  Clearing generated files \e[0m"
	@rm -rf a.out
	@rm -rf peda-session-*
	@rm -rf *.S
	@rm -rf $(current_dir)/src/util/litconv.go
	@rm -rf $(current_dir)/src/util/rune.go
	@rm -rf $(current_dir)/src/token/token.go
	@rm -rf $(current_dir)/src/lexer/lexer.go
	@rm -rf $(current_dir)/src/lexer/acttab.go
	@rm -rf $(current_dir)/src/parser
	@rm -rf $(current_dir)/src/lexer/transitiontable.go

# Prepare for submitting. Warning don't run this lightly.
nuke: clean
	@echo -e "\e[1;31m  Clearing downloaded libraries \e[0m"
	@rm -rf $(current_dir)/vendor
	@echo -e "\e[1;31m  Clearing git stuff \e[0m"
	@rm -rf $(current_dir)/.git
	@rm -rf $(current_dir)/.gitignore
	@rm -rf $(current_dir)/README.md
	@rm -rf $(current_dir)/tango.ebnf
