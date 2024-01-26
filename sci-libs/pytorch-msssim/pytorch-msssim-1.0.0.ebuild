# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 pypi

DESCRIPTION="Fast and differentiable MS-SSIM and SSIM for pytorch"
HOMEPAGE="https://github.com/VainF/pytorch-msssim"
# SRC_URI="https://github.com/VainF/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
"
