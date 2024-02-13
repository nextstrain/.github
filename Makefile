SHELL := /bin/bash -euo pipefail
.SILENT:

workflows := .github/workflows/*.yaml.in

inputs  := $(sort $(wildcard $(workflows)) $(shell git ls-files --cached -- '$(workflows)'))
outputs := $(inputs:.in=)

## Regenerate all the things.
all: $(outputs)

## Regenerate all the things and error if anything changed.
check: $(outputs)
	git diff --exit-code --text HEAD -- $(outputs)

## Regenerate an exploded workflow YAML.
.github/workflows/%.yaml: .github/workflows/%.yaml.in PHONY
	./devel/regenerate-workflow $<

## Print this help message.
help:
	@perl -ne 'print if /^## / ... s/^(?<!##)(.+?):.*/make \1\n/ and not /^#( |$$)/' Makefile

.PHONY: PHONY all check help
PHONY:
