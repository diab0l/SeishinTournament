TSC = tsc
TSCFLAGS = --experimentalDecorators

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
.PHONY: all clean dist build build-pre dist-pre merge-to-dist

all:	build

#run:	dist

dist: build dist-pre merge-to-dist

clean:
	rm -rf build
	rm -rf dist

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

#$(TsTargets): $(TsInputs)

$(BuildDir)/%.js: $(SrcDir)/%.ts
	echo "Compiling $< to $@.."
	mkdir -p $(dir $@)
	$(TSC) $(TSCFLAGS) --out $@ $<

%.min.js: %.js
	echo "Minifying $< to $@.."
	uglifyjs -o $@ $<

$(BuildDir)/%.min.js: $(SrcDir)/%.js
	echo "Minifying $< to $@.."
	mkdir -p $(dir $@)
	uglifyjs -o $@ $<

merge-to-dist:
	cp -r build/. dist
