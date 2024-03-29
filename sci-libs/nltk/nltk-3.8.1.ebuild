# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Natural Language Toolkit"
HOMEPAGE="https://github.com/nltk/nltk"
SRC_URI="https://github.com/nltk/nltk/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="data"

PATCHES=( "${FILESDIR}/${P}-test.patch" )

RDEPEND="
	data? ( sci-libs/nltk-data )
	$(python_gen_cond_dep '
		dev-python/joblib[${PYTHON_USEDEP}]
		>=dev-python/regex-2021.8.3[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		dev-lang/python[tk]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	rm -f nltk/test/unit/test_downloader.py || die		# Need network access
	epytest --doctest-modules
}
