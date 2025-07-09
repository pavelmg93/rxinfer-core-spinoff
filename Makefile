# This Makefile provides a set of commands to automate common development tasks.

# Variables
JULIA = julia

# Default target
.PHONY: all
all: help

# Targets
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  help                  Show this help message."
	@echo "  install               Install project dependencies."
	@echo "  test                  Run tests."
	@echo "  format                Format code."
	@echo "  docs-preview          Preview documentation locally."
	@echo "  docs-build            Build documentation."
	@echo "  benchmark             Run benchmarks."
	@echo "  clean                 Clean up generated files."

.PHONY: install
install:
	$(JULIA) --project -e 'import Pkg; Pkg.instantiate()'

.PHONY: test
test:
	$(JULIA) --project -e 'import Pkg; Pkg.test()'

.PHONY: format
format:
	$(JULIA) --project -e 'import Pkg; Pkg.add("JuliaFormatter"); import JuliaFormatter; JuliaFormatter.format(".")'

.PHONY: docs-preview
docs-preview:
	$(JULIA) --project=docs/ -e 'using Pkg; Pkg.instantiate(); using LiveServer; serve(dir="docs/build")'

.PHONY: docs-build
docs-build:
	$(JULIA) --project=docs/ -e 'using Pkg; Pkg.instantiate(); include("docs/make.jl")'

.PHONY: benchmark
benchmark:
	$(JULIA) --project=benchmarks/ -e 'import Pkg; Pkg.instantiate(); include("benchmarks/run.jl")'

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf docs/build
	@rm -rf .DS_Store
	@find . -name "*.log" -delete
	@find . -name "*.aux" -delete
	@find . -name "*.bbl" -delete
	@find . -name "*.blg" -delete
	@find . -name "*.out" -delete
	@find . -name "*.toc" -delete
	@find . -name "*~" -delete
	@find . -name "#*#" -delete
	@find . -name ".#*" -delete
	@echo "Done."
