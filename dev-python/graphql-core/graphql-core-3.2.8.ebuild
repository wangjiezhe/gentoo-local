# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=poetry
# PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Python port of GraphQL.js, the JavaScript reference implementation for GraphQL"
HOMEPAGE="
	https://pypi.org/project/graphql-core/
	https://github.com/graphql-python/graphql-core
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	<dev-python/setuptools-83[${PYTHON_USEDEP}]
	>=dev-python/setuptools-59[${PYTHON_USEDEP}]
"

EPYTEST_IGNORE=( tests/benchmarks )
EPYTEST_PLUGINS=( anyio pytest-{asyncio,describe,timeout} )

distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

python_test() {
	# avoid pytest-benchmark
	epytest -o addopts= tests
}
