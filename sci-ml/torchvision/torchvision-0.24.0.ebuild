# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 cuda

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/vision-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda +ffmpeg +jpeg +png +webp"
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
	cuda? ( media-libs/nv-codec-headers )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	webp? ( media-libs/libwebp )
	ffmpeg? ( media-video/ffmpeg )
	dev-qt/qtcore:5
	sci-ml/caffe2[cuda?]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
# BDEPEND="
# 	test? (
# 		$(python_gen_cond_dep '
# 		dev-python/mock[${PYTHON_USEDEP}]
# 		')
# 	)"

# distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-ffnvcodec.patch
)

src_prepare() {
	# multilib fixes
	sed "s/ffmpeg_root, \"lib\"/ffmpeg_root, \"$(get_libdir)\"/" \
		-i setup.py || die

	distutils-r1_src_prepare

	export MAKEOPTS=-j1

	if use cuda; then
		export FORCE_CUDA=1
		export NVCC_FLAGS="$(cuda_gccdir -f | tr -d \")"
		cuda_src_prepare
		cuda_add_sandbox -w
	fi

	export TORCHVISION_USE_PNG=$(usex png 1 0)
	export TORCHVISION_USE_JPEG=$(usex jpeg 1 0)
	export TORCHVISION_USE_WEBP=$(usex webp 1 0)
	export TORCHVISION_USE_FFMPEG=$(usex ffmpeg 1 0)

	export TORCHVISION_USE_NVJPEG=$(usex cuda 1 0)
	export TORCHVISION_USE_VIDEO_CODEC=$(usex cuda 1 0)
	export TORCHVISION_INCLUDE="${EPREFIX}/usr/include/ffnvcodec"
	export TORCHVISION_LIBRARY="${EPREFIX}/usr/lib/wsl/lib"
}

# python_test() {
# 	local EPYTEST_DESELECT=(
# 		# stuck
# 		test/test_videoapi.py::TestVideoApi::test_frame_reading_mem_vs_file
# 	)

# 	rm -rf torchvision || die
# 	epytest test/datasets_utils.py
# }
