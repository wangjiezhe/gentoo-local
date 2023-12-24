# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Reversible tokenization in Python"
HOMEPAGE="https://github.com/jekbradbury/revtok"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

python_prepare_all() {
	sed -i "s/tests/test/" setup.py

	distutils-r1_python_prepare_all
}
