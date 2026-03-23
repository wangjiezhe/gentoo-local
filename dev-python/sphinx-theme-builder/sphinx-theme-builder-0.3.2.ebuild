# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A tool for authoring Sphinx themes with a simple (opinionated) workflow"
HOMEPAGE="
	https://github.com/pradyunsg/sphinx-theme-builder
	https://pypi.org/project/sphinx-theme-builder/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyproject-metadata
	dev-python/packaging
	dev-python/rich
	dev-python/nodeenv
	dev-python/setuptools
	dev-python/diagnostic
	dev-python/build
	dev-python/click
	dev-python/sphinx-autobuild
"
