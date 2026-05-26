# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3 pypy3_11 )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="Optimized PyTree Utilities"
HOMEPAGE="https://github.com/metaopt/optree"
SRC_URI="https://github.com/metaopt/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/typing-extensions[${PYTHON_USEDEP}]"

EPYTEST_XDIST=1
EPYTEST_PLUGINS=( pytest-cov )

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# test_treespec.py is not installed, so it cannot be find in test here.
		tests/test_treespec.py::test_treespec_pickle_missing_registration
	)
	rm -rf optree || die
	epytest
}
