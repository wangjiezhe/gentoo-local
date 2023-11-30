# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 cuda

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vision-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
	>=sci-libs/pytorch-2.0.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/caffe2-2.0.1[cuda?]
	media-video/ffmpeg
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
		dev-python/mock[${PYTHON_USEDEP}]
		')
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/7378-fix-ffmpeg-6-macro-error.patch
)

src_prepare() {
	distutils-r1_src_prepare

	export MAKEOPTS=-j1
}

python_configure_all() {
	if use cuda; then
		export FORCE_CUDA=1
		export NVCC_FLAGS="$(cuda_gccdir -f | tr -d \")"
	fi
}
