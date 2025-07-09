MAKEFLAGS += --no-print-directory

# Default target
.PHONY: help
help:
	@echo "-------------------------------------------------------------------------------------"
	@echo " RxInfer.jl development makefile                                                     "
	@echo "-------------------------------------------------------------------------------------"
	@echo ""
	@echo " Usage:"
	@echo "    make <target>"
	@echo ""
	@echo " Available targets:"
	@echo "    help                                   - shows this help message"
	@echo "    test                                   - runs tests"
	@echo "    test-jet                               - runs static analysis checks with JET.jl"
	@echo "    test-aqua                              - runs static analysis checks with Aqua.jl"
	@echo "    test-all                               - runs all available tests"
	@echo "    format                                 - formats all Julia files in the repository"
	@echo "    format-check                           - checks if all Julia files in the repository are formatted"
	@echo "    docs-clean                             - cleans up the documentation build directory"
	@echo "    docs-build                             - builds the documentation"
	@echo "    docs-serve                             - serves the documentation locally"
	@echo "    docs-deploy                            - deploys the documentation to GitHub Pages"
	@echo "    activate-env                           - activates the Julia environment for the project"
	@echo "    activate-env-docs                      - activates the Julia environment for the documentation"
	@echo "    activate-env-benchmarks                - activates the Julia environment for the benchmarks"
	@echo "    activate-env-test                      - activates the Julia environment for the tests"
	@echo ""
	@echo "-------------------------------------------------------------------------------------"

# Run tests
.PHONY: test
test:
	@julia --color=yes --project=test/ -e 'using Pkg; Pkg.test("RxInfer"; coverage=true, test_args=ARGS)'

# Run static analysis checks with JET.jl
.PHONY: test-jet
test-jet:
	@julia --color=yes --project=test/ -e 'using Pkg; Pkg.test("JET"; coverage=false, test_args=["RxInfer"])'

# Run static analysis checks with Aqua.jl
.PHONY: test-aqua
test-aqua:
	@julia --color=yes --project=test/ -e 'using Pkg; Pkg.test("Aqua"; coverage=false, test_args=["RxInfer"])'

# Run all available tests
.PHONY: test-all
test-all: test test-jet test-aqua

# Format all Julia files in the repository
.PHONY: format
format:
	@julia --color=yes --project=scripts/ -e 'using Pkg; include("scripts/format.jl"); format(".")'

# Check if all Julia files in the repository are formatted
.PHONY: format-check
format-check:
	@julia --color=yes --project=scripts/ -e 'using Pkg; include("scripts/format.jl"); format("."; check=true)'

# Clean up the documentation build directory
.PHONY: docs-clean
docs-clean:
	@rm -rf docs/build

# Build the documentation
.PHONY: docs-build
docs-build: docs-clean
	@julia --color=yes --project=docs/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate(); include("docs/make.jl")'

# Serve the documentation locally
.PHONY: docs-serve
docs-serve:
	@julia --color=yes --project=docs/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate(); include("docs/make.jl"); serve(port=8080)'

# Deploy the documentation to GitHub Pages
.PHONY: docs-deploy
docs-deploy:
	@julia --color=yes --project=docs/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate(); include("docs/make.jl"); deploydocs(repo="github.com/ReactiveBayes/RxInfer.jl.git", devbranch="main")'

# Activate the Julia environment for the project
.PHONY: activate-env
activate-env:
	@julia --color=yes --project=. -e 'using Pkg; Pkg.instantiate()'

# Activate the Julia environment for the documentation
.PHONY: activate-env-docs
activate-env-docs:
	@julia --color=yes --project=docs/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'

# Activate the Julia environment for the benchmarks
.PHONY: activate-env-benchmarks
activate-env-benchmarks:
	@julia --color=yes --project=benchmarks/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'

# Activate the Julia environment for the tests
.PHONY: activate-env-test
activate-env-test:
	@julia --color=yes --project=test/ -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'
