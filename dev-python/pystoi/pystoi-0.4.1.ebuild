# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python implementation of the Short Term Objective Intelligibility measure"
HOMEPAGE="https://github.com/mpariente/pystoi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# Need MATLAB; `matlab_wrapper` are only compatible with Python2.7

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
"
