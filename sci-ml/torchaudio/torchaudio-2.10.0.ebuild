# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 cuda

DESCRIPTION="Data manipulation and transformation for audio signal processing"
HOMEPAGE="https://github.com/pytorch/audio"
SRC_URI="https://github.com/pytorch/audio/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/audio-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda openmp"
RESTRICT="test"		# has fatal python error and too many other failures

RDEPEND="
	>=sci-ml/pytorch-${PV}[${PYTHON_SINGLE_USEDEP}]
	dev-util/ccache
	cuda? ( >=sci-ml/caffe2-${PV}[cuda?] )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-Fix-building-on-GCC-14.2-4163.patch )

src_prepare() {
	export USE_CUDA=$(usex cuda)
	export BUILD_CUDA_CTC_DECODER=$(usex cuda)
	export USE_OPENMP=$(usex openmp)

	distutils-r1_src_prepare
	use cuda && cuda_src_prepare && cuda_add_sandbox -w
}
