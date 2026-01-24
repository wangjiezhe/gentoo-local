# Copyright 2020-2026 Gentoo Authors
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

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
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

EPYTEST_PLUGINS=( pytest-mock lmdb )
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-0.24.0-ffnvcodec.patch
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

python_test() {
	rm -rf torchvision || die

	local EPYTEST_IGNORE=(
		test/test_videoapi.py
		test/test_internet.py
	)
	local EPYTEST_DESELECT=(
		test/test_backbone_utils.py::TestFxFeatureExtraction::test_forward_backward
		test/test_backbone_utils.py::TestFxFeatureExtraction::test_jit_forward_backward
		test/test_models.py::test_classification_model
		test/test_extended_models.py::TestHandleLegacyInterface::test_pretrained_pos
		test/test_extended_models.py::TestHandleLegacyInterface::test_equivalent_behavior_weights
		test/test_image.py::test_encode_jpeg_cuda_device_param
		test/test_image.py::test_decode_avif[decode_avif]
		test/test_image.py::test_decode_gif[False-earth]
		test/test_image.py::test_decode_bad_encoded_data
		test/test_image.py::test_decode_gif[True-earth]
		test/test_image.py::test_decode_heic[decode_heic]
		test/test_image.py::test_decode_webp
		test/test_models.py::test_quantized_classification_model
		test/test_ops.py::test_roi_opcheck
		test/test_ops.py::TestDeformConv::test_aot_dispatch_dynamic__test_backward
		test/test_ops.py::TestDeformConv::test_aot_dispatch_dynamic__test_forward
		test/test_transforms_v2.py::TestResize::test_kernel_bounding_boxes[cuda-dtype0-False-size4-BoundingBoxFormat.XYWHR]
		test/test_transforms_v2.py::TestResize::test_kernel_bounding_boxes[cuda-dtype0-False-size5-BoundingBoxFormat.XYWHR]
		test/test_transforms_v2.py::TestResize::test_bounding_boxes_correctness[resize-False-size4-BoundingBoxFormat.XYWHR]
		test/test_transforms_v2.py::TestResize::test_bounding_boxes_correctness[resize-False-size5-BoundingBoxFormat.XYWHR]
		test/test_transforms_v2.py::TestResize::test_bounding_boxes_correctness[Resize-False-size4-BoundingBoxFormat.XYWHR]
		test/test_transforms_v2.py::TestResize::test_bounding_boxes_correctness[Resize-False-size5-BoundingBoxFormat.XYWHR]
		test/test_transforms_v2.py::TestCrop::test_transform_bounding_boxes_correctness[4-cuda-dtype0-BoundingBoxFormat.XYWHR-output_size0]
	)

	epytest
}
