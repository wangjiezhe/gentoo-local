# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A simple utility to separate the implementation of your Python package and its public API surface"
HOMEPAGE="https://github.com/fchollet/namex https://pypi.org/project/namex/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
