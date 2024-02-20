# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python wrapper for SentencePiece"
HOMEPAGE="
	https://github.com/google/sentencepiece/
	https://pypi.org/project/sentencepiece/
"
SRC_URI="
	https://github.com/google/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${P}/python

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="~dev-libs/sentencepiece-${PV}[static-libs]"

DOCS=()

python_prepare_all() {
	sed -i "s@\.\./build/root@/usr@" setup.py

	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest

python_test() {
	rm -rf src || die
	epytest
}
