# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="C parser and ctypes automation for python"
HOMEPAGE="https://github.com/MatthieuDartiailh/pyclibrary"
SRC_URI="https://github.com/MatthieuDartiailh/pyclibrary/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
