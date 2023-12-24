# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python port of Moses tokenizer, truecaser and normalizer"
HOMEPAGE="https://github.com/hplt-project/sacremoses"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"