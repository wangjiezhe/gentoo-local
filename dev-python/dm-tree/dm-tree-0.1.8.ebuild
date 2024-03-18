# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="A library for working with nested data structures"
HOMEPAGE="https://github.com/google-deepmind/tree"
SRC_URI="https://github.com/google-deepmind/tree/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/tree-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-cpp/abseil-cpp"

BDEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
	test? (
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/wrapt[${PYTHON_USEDEP}]
	)
"

PATCHES="${FILESDIR}/${P}-cmake.patch"

distutils_enable_tests pytest

python_test() {
	rm -rf tree || die
	epytest --pyargs tree
}
