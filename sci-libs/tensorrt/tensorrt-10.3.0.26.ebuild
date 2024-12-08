# Copyright 2003-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=no
inherit distutils-r1

CUDA_VER="12.5"
BASE_VER="$(ver_cut 1-3)"
EXTEND_VER="${BASE_VER}"

DESCRIPTION="An SDK for high-performance deep learning inference"
HOMEPAGE="https://developer.nvidia.com/tensorrt"
SRC_URI="https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/${BASE_VER}/tars/TensorRT-${PV}.Linux.x86_64-gnu.cuda-${CUDA_VER}.tar.gz"
S="${WORKDIR}/TensorRT-${PV}"

LICENSE="NVIDIA-TensorRT"
SLOT="0/${BASE_VER}"
KEYWORDS="~amd64"
IUSE="data samples"
RESTRICT="bindist mirror test"

RDEPEND="
	=dev-util/nvidia-cuda-toolkit-12*
	dev-libs/cudnn
	$(python_gen_cond_dep '
		>=dev-python/gpep517-15[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	dev-util/patchelf
"

src_install() {
	into /opt/cuda
	dobin targets/x86_64-linux-gnu/bin/*

	insinto /opt/cuda/targets/x86_64-linux/
	doins -r include targets/x86_64-linux-gnu/lib

	dosym "libnvinfer_builder_resource.so.${BASE_VER}" \
		"/opt/cuda/targets/x86_64-linux/lib/libnvinfer_builder_resource.so.${BASE_VER%%.*}"
	dosym "libnvinfer_builder_resource.so.${BASE_VER}" \
		"/opt/cuda/targets/x86_64-linux/lib/libnvinfer_builder_resource.so"
	dosym "libnvinfer_builder_resource.so.${BASE_VER}" \
		"/opt/cuda/targets/x86_64-linux/lib/do_not_link_against_nvinfer_builder_resource"

	dosym "libnvinfer_builder_resource_win.so.${BASE_VER}" \
		"/opt/cuda/targets/x86_64-linux/lib/libnvinfer_builder_resource_win.so.${BASE_VER%%.*}"
	dosym "libnvinfer_builder_resource_win.so.${BASE_VER}" \
		"/opt/cuda/targets/x86_64-linux/lib/libnvinfer_builder_resource_win.so"
	dosym "libnvinfer_builder_resource_win.so.${BASE_VER}" \
		"/opt/cuda/targets/x86_64-linux/lib/do_not_link_against_nvinfer_builder_resource_win"

	patchelf --add-rpath '$ORIGIN' "${ED}/opt/cuda/targets/x86_64-linux/lib/libnvinfer.so"|| die "patchelf failed"

	do_install() {
		local PYTHON_VER="${EPYTHON/python/}"
		local PYTHON_VER="${PYTHON_VER/./}"
		distutils_wheel_install "${ED}" "${S}/python/tensorrt-${EXTEND_VER}-cp${PYTHON_VER}-none-linux_x86_64.whl"
		distutils_wheel_install "${ED}" "${S}/python/tensorrt_dispatch-${EXTEND_VER}-cp${PYTHON_VER}-none-linux_x86_64.whl"
		distutils_wheel_install "${ED}" "${S}/python/tensorrt_lean-${EXTEND_VER}-cp${PYTHON_VER}-none-linux_x86_64.whl"
		python_optimize
	}
	python_foreach_impl do_install

	if use data; then
		insinto "/usr/share/${P}"
		doins -r data
	fi

	if use samples; then
		insinto "/usr/share/${P}"
		doins -r samples
	fi
}
