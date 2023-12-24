# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

CommitId="c8ffa420a3923e8fd87c1e75170de2cf59d2644b"

DESCRIPTION="FID calculation with proper image resizing and quantization steps"
HOMEPAGE="https://github.com/GaParmar/clean-fid"
SRC_URI="https://github.com/GaParmar/${PN}/archive/${CommitId}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${CommitId}"

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
