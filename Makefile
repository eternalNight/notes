V ?= @

SRC  := $(shell find . -name "*.rst")
MAN  := ${addprefix build/,${SRC:.rst=.man}}
HTML := ${addprefix build/,${SRC:.rst=.html}}
TEX  := ${addprefix build/,${SRC:.rst=.tex}}

.DEFAULT_GOAL := html
.PHONY: man html tex

man: ${MAN}

html: ${HTML}

tex: ${TEX}

${MAN}:build/%.man:%.rst | builddir
	@echo + MAN $<
	${V}rst2man ${ARGS} $< $@

${HTML}:build/%.html:%.rst | builddir
	@echo + HTML $<
	${V}rst2html ${ARGS} $< $@

${TEX}:build/%.tex:%.rst | builddir
	@echo + TEX $<
	${V}rst2latex ${ARGS} $< $@

builddir:
	@mkdir -p build

clean:
	${V}rm -rf build
