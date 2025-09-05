# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="C parser and ctypes automation for python"
HOMEPAGE="https://github.com/MatthieuDartiailh/pyclibrary"
SRC_URI="https://github.com/MatthieuDartiailh/pyclibrary/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

distutils_enable_tests pytest
