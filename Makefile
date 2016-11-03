TSC = "./node_modules/.bin/tsc"
TSCFLAGS = --experimentalDecorators -m amd

UGLIFY = "./node_modules/.bin/uglifyjs"

HTTPSERVER = "./node_modules/.bin/http-server"

SrcDir = src
BuildDir = build
DistDir = dist

VerbatimFilesCmd := find src/ -not -iname '*.ts' -not -iname '*.min.map' -not -iname '*.min.js' | sed 's/ /\\ /'
TsFilesCmd := find src/ -iname '*.ts' | sed 's/ /\\ /'
JsFilesCmd := find src/ -iname '*.js' -not -iname '*.min.js' | sed 's/ /\\ /'

SrcToDist := sed 's/^src\//dist\//
SrcToBuild := sed 's/^src\//build\//'

TsToJs := sed 's/.ts$$/.js/'
JsToMinJs := sed 's/.js$$/.min.js/'

VerbatimFiles := $(shell $(VerbatimFilesCmd))
TsTargets := $(shell $(TsFilesCmd) | $(SrcToBuild) | $(TsToJs))
JsFiles := $(shell $(JsFilesCmd))
MinifyInputs := $(JsFiles) $(TsTargets)
MinifyTargets := $(patsubst $(SrcDir)/%,$(BuildDir)/%,$(MinifyInputs:%.js=%.min.js))

.SILENT:
.PHONY: all clean dist build build-pre dist-pre merge-to-dist copy-libs

all:	npm-deps dist

npm-deps:
	if [ \( ! -e ""$(TSC) \) -o \( ! -e ""$(UGLIFY) \) ]; then \
		echo Running npm install..; \
		npm install; \
	fi

run:	dist
	$(HTTPSERVER) dist/

dist: build dist-pre merge-to-dist

clean:
	rm -rf build
	rm -rf dist

squeaky-clean: clean
	rm -rf node_modules

debug:
	#echo $(MinifyInputs)
	#echo
	echo $(patsubst $(SrcDir)/%,$(BuildDir)/%,$(MinifyTargets))

build: build-pre $(TsTargets) $(MinifyTargets)

build-pre:
	if [ ! -d $(BuildDir) ]; then \
	  echo Creating build directory; \
	  mkdir -p $(BuildDir); \
	fi

dist-pre: $(VerbatimFiles)
	if [ ! -d $(DistDir) ]; then \
	  echo Creating dist directory; \
	  mkdir -p $(DistDir); \
	fi
	echo Copying verbatim files
	$(VerbatimFilesCmd) | sed 's/^src\///' | xargs -I file bash -c "if [ -d \"src/file\" ]; then mkdir -p \"dist/file\"; else cp \"src/file\" \"dist/file\"; fi"

merge-to-dist:
	cp -r build/. dist

$(BuildDir)/%.js: $(SrcDir)/%.ts
	echo "Compiling $< to $@.."
	mkdir -p $(dir $@)
	$(TSC) $(TSCFLAGS) --outDir $(dir $@) $<

%.min.js: %.js
	echo "Minifying $< to $@.."
	$(UGLIFY) -o $@ $<

$(BuildDir)/%.min.js: $(SrcDir)/%.js
	echo "Minifying $< to $@.."
	mkdir -p $(dir $@)
	$(UGLIFY) -o $@ $<
