# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} python3_13t )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Optimized PyTree Utilities"
HOMEPAGE="https://github.com/metaopt/optree"
SRC_URI="https://github.com/metaopt/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/typing-extensions[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# test_treespec.py is not installed, so it cannot be find in test here.
		tests/test_treespec.py::test_treespec_pickle_missing_registration
	)
	rm -rf optree || die
	epytest
}
