# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} )
# DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Easy, clean, reliable Python 2/3 compatibility"
HOMEPAGE="https://python-future.org/
		https://github.com/PythonCharmers/python-future"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
RESTRICT="mirror"

distutils_enable_sphinx docs dev-python/sphinx-bootstrap-theme
