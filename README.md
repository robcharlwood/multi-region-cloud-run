# Multi Region Cloud Run
[![Build Status](https://travis-ci.org/robcharlwood/multi-region-cloud-run.svg?branch=master)](https://travis-ci.org/robcharlwood/multi-region-cloud-run/)

This repository contains the partner codebase for Rob Charlwood's Medium tutorial - "Multi Region Load Balancing with GO and Google Cloud Run - Part 1".

### Checkout and setup
To work with this codebase, you will require the below to be setup and configured on your machine.

* ``golang`` at version ``1.14.4`` or newer (if you want to make changes to the API code)
* ``docker``- For compiling and building the container image
* ``make`` - If you wish to use the repo's included ``Makefile``

If you wish to use the pre-commit hooks included in this repository, you'll also need:
* ``python`` at version ``3.8.2`` - I suggest installing via ``pyenv`` for isolation.
* Python's ``poetry`` library installed against ``3.8.2``

To set this codebase up on your machine, you can run the following commands:

```bash
git clone git@github.com:robcharlwood/multi-region-cloud-run.git
cd multi-region-cloud-run
```

If you'd like the pre-commit hooks installed, then you also need to run:

```bash
make install
```

The ``Makefile`` checks that you have all the required things at the required versions and ``make install`` will setup a local ``.venv`` environment and install ``pre-commit`` into it.
It will then setup the pre-commit hooks so that the below commands are run locally before a commit can be pushed:

* ``go fmt``
* ``go vet``
* ``go test``
* ``go build``
* ``go mod tidy``

### Building the docker image

The ``Makefile`` also provides a ``make build`` command that will build an image from the ``Dockerfile`` and push it up to Google Container Registry.
Please note that in order for the ``make build`` command to work, you'll need to ensure you have set the relevant environment variables first.
I suggest adding a ``.env`` file into the project root and then exporting your vars in there. You can then source the ``.env`` file before running the ``make`` command.

e.g

``.env``
```shell
export registry=eu.gcr.io
export project=my_project
export image_name=my_image
```

Then you could run the build command like so:

```bash
source .env && make build
```

Note that the ``make build`` command also accepts a command line argument for ``version``. This allows you to build the image at a specific version number. e.g.

```bash
source .env && make build version=1.0.0
```

The ``make build`` command also assumes that you have followed the tutorial and stored your ``terraform`` service account JSON key in a ``.keys`` directory
in the root of the project and named it ``terraform.json``. If this is not the case, you'll need to tweak the build command accordingly.

## Running the API locally
To run the sample application locally, ensure that you have golang 1.14.4 installed and then run:

```bash
go run main.go
```

This will boot up a server at the following address: http://localhost:8080

### Tests
The sample API's test suite can be run using the below command:

``` bash
go test
```

### Continuous Integration

This project uses [Travis CI](http://travis-ci.org/) for continuous integration. This platform runs the project tests automatically when a PR is raised or merged.

## Versioning

This project uses [git](https://git-scm.com/) for versioning. For the available versions,
see the [tags on this repository](https://github.com/robcharlwood/multi-region-cloud-run/tags).

## Authors

* Rob Charlwood - Bitniftee Limited

## Changes

Please see the [CHANGELOG.md](https://github.com/robcharlwood/multi-region-cloud-run/blob/master/CHANGELOG.md) file additions, changes, deletions and fixes between each version

## License

This project is licensed under the CC0-1.0 License - please see the [LICENSE.md](https://github.com/robcharlwood/multi-region-cloud-run/blob/master/LICENSE) file for details
