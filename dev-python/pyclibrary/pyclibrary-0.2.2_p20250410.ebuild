# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GIT_COMMIT=4e1e243a0bdfefa188d93ebdf3b60c6861244855

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="C parser and ctypes automation for python"
HOMEPAGE="https://github.com/MatthieuDartiailh/pyclibrary"
SRC_URI="https://github.com/MatthieuDartiailh/pyclibrary/archive/${GIT_COMMIT}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	export SETUPTOOLS_SCM_PRETEND_VERSION=0.2.2
}

distutils_enable_tests pytest
