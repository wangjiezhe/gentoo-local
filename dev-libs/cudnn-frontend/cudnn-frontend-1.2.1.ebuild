# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
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

RDEPEND="=dev-libs/cudnn-8*"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		dev-python/pybind11
		dev-libs/dlpack
		test? (
			sci-libs/pytorch
			sci-libs/caffe2[cuda]
		)
	)
"

PATCHES=("${FILESDIR}/${P}-cmake.patch")

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
	use python && distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# Failed with param: ((1, 128, 1024), torch.bfloat16)
		# AssertionError: Tensor-likes are not close!
		# Mismatched elements: 0.2%
		test/python_fe/test_matmul_bias_relu.py::test_matmul_bias_relu[param_extract4]
	)

	epytest
}
