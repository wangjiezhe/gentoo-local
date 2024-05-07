# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="RE2 Python bindings"
HOMEPAGE="https://github.com/google/re2 https://pypi.org/project/google-re2/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
# RESTRICT="test"

DEPEND="
	dev-cpp/abseil-cpp:=
	dev-libs/re2:=
	dev-python/pybind11[${PYTHON_USEDEP}]
"

# BDEPEND="
# 	test? (
# 		dev-python/absl-py[${PYTHON_USEDEP}]
# 	)
# "

# distutils_enable_tests pytest
