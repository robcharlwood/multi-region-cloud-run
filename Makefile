PYTHON_OK := $(shell which python)
POETRY_OK := $(shell which poetry)
GO_OK := $(shell which go)
GO_VERSION := $(shell go version | cut -d' ' -f3 | tr -d go)
GO_REQUIRED := $(shell cat .go-version)
DOCKER_OK := $(shell which docker)
PYTHON_VERSION := $(shell python -V | cut -d' ' -f2)
PYTHON_REQUIRED := $(shell cat .python-version)

check_docker:
	@echo '*********** Checking for docker installation ***********'
    ifeq ('$(DOCKER_OK)','')
	    $(error 'docker' not found!)
    else
	    @echo Found docker
    endif
.PHONY: check_docker

check_poetry:
	@echo '*********** Checking for poetry installation ***********'
    ifeq ('$(POETRY_OK)','')
	    $(error 'poetry' not found!)
    else
	    @echo Found poetry
    endif
.PHONY: check_poetry

check_go:
	@echo '*********** Checking for go installation ***********'
    ifeq ('$(GO_OK)','')
	    $(error 'go' not found!)
    else
	    @echo Found go
    endif
	@echo '*********** Checking go version ***********'
    ifneq ('$(GO_REQUIRED)','$(GO_VERSION)')
	    $(error incorrect version of go found: '${GO_VERSION}'. Expected '${GO_REQUIRED}'!)
    else
	    @echo Found go ${GO_REQUIRED}
    endif
.PHONY: check_go

check_python:
	@echo '*********** Checking for Python installation ***********'
    ifeq ('$(PYTHON_OK)','')
	    $(error python interpreter: 'python' not found!)
    else
	    @echo Found Python
    endif
	@echo '*********** Checking for Python version ***********'
    ifneq ('$(PYTHON_REQUIRED)','$(PYTHON_VERSION)')
	    $(error incorrect version of python found: '${PYTHON_VERSION}'. Expected '${PYTHON_REQUIRED}'!)
    else
	    @echo Found Python ${PYTHON_REQUIRED}
    endif
.PHONY: check_python

setup: check_python check_poetry check_docker check_go
	@echo '**************** Creating virtualenv for python dev tools e.g pre-commit *******************'
	export POETRY_VIRTUALENVS_IN_PROJECT=true && poetry install --no-root
	poetry run pip install --upgrade pip
	@echo '******************************** Installation Complete *************************************'
.PHONY: setup

setup_precommit: check_poetry
	@echo '****** Setting up pre-commit hooks ******'
	poetry run pre-commit install
.PHONY: setup_precommit

install: setup setup_precommit
.PHONY: install

build: version := "0.0.1"
build:
	docker build --tag ${registry}/${project}/${image_name}:latest --tag ${registry}/${project}/${image_name}:${version} .
	cat ./.keys/terraform.json | docker login -u _json_key --password-stdin https://${registry}
	docker push ${registry}/${project}/${image_name}:latest
	docker push ${registry}/${project}/${image_name}:${version}
	docker logout https://${registry}
.PHONY: build
