# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 flag-o-matic

DESCRIPTION="A c++ wrapper for the cudnn backend API"
HOMEPAGE="https://github.com/NVIDIA/cudnn-frontend"
SRC_URI="https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/8"
KEYWORDS="~amd64"
IUSE="python"

RDEPEND=">=dev-libs/cudnn-9"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		dev-python/pybind11
		dev-libs/dlpack
		test? (
			dev-python/looseversion
			sci-ml/pytorch
			sci-ml/caffe2[cuda]
		)
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.1-cmake.patch
	"${FILESDIR}"/${PN}-1.8.0-python.patch
	"${FILESDIR}"/${PN}-1.9.0-test.patch
)

src_prepare() {
	eapply_user
	use python && distutils-r1_src_prepare
	append-flags -Wno-array-bounds
	append-flags -Wno-stringop-overread
}

src_configure() {
	use python && distutils-r1_src_configure
}

src_compile() {
	use python && distutils-r1_src_compile
}

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include

	use python && distutils-r1_src_install
}

distutils_enable_tests pytest

src_test() {
	if has usersandbox ${FEATURES}; then
		ewarn "Test suite fails under FEATURES=usersandbox. Skipping."
		return 0
	fi

	use python && distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# Failed with param: ((1, 128, 1024), torch.bfloat16)
		# AssertionError: Tensor-likes are not close!
		# Mismatched elements: 0.2%
		test/python/test_matmul_bias_relu.py::test_matmul_bias_relu[param_extract4]
		# AssertionError: Legacy CUDA profiling requires use_cpu=True
		test/python/test_silu_and_mul.py::test_silu_and_mul_and_quantization
	)

	epytest
}
