# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Rebuild Sphinx documentation on changes, with hot reloading in the browser"
HOMEPAGE="
	https://github.com/sphinx-doc/sphinx-autobuild
	https://pypi.org/project/sphinx-autobuild/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/colorama
	dev-python/sphinx
	dev-python/starlette
	dev-python/uvicorn
	dev-python/watchfiles
	dev-python/websockets
"

EPYTEST_IGNORE=( tests/test_application.py )
EPYTEST_PLUGINS=( httpx )
distutils_enable_tests pytest
