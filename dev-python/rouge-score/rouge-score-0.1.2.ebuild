# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Pure python implementation of ROUGE-1.5.5"
HOMEPAGE="https://pypi.org/project/rouge-score"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# due to lack of `testdata` directory

RDEPEND="
	dev-python/absl-py[${PYTHON_USEDEP}]
	sci-ml/nltk[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
