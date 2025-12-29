# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="IPython magic function to print date/time stamps and various system information"
HOMEPAGE="https://github.com/rasbt/watermark"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gpu"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	gpu? ( dev-python/py3nvml[${PYTHON_USEDEP}] )
"
