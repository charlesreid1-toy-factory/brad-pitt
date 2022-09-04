.PHONY: clean clean-build clean-pyc clean-test lint lint/flake8 lint/black docs serve-docs deploy-docs test test-all install

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

############ Clean

clean: clean-build clean-pyc clean-test ## remove all build, test, and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs *.egg*

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr .pytest_cache

############ Lint

lint/flake8: ## check style with flake8
	flake8 bradpitt tests

lint/black: ## check style with black
	black --check bradpitt tests

lint: lint/flake8 lint/black ## check style

############ Docs

docs: ## generate mkdocs HTML documentation
	rm -fr site/*
	mkdocs build --clean

serve-docs: docs ## serve the docs
	mkdocs serve --clean

deploy-docs: docs ## serve the docs
	mkdocs gh-deploy --clean

############ Test

test: ## run tests quickly with the default Python
	pytest

test-all: ## run tests on every Python version with tox
	tox

############ Build

install: clean ## install the package to the active Python's site-packages
	python setup.py install

############ Release

#release: dist ## package and upload a release
#	@echo "twine upload dist/*"
#
#dist: clean ## builds source and wheel package
#	python setup.py sdist
#	python setup.py bdist_wheel
#	ls -l dist

