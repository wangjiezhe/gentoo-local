# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit cuda cmake distutils-r1 multiprocessing

DESCRIPTION="A c++ wrapper for the cudnn backend API"
HOMEPAGE="https://github.com/NVIDIA/cudnn-frontend"
SRC_URI="https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="python samples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/cudnn-9:=
"
DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
"
BDEPEND="
	test? (
		>=dev-cpp/catch-3
		>=dev-libs/cudnn-9.15.0
	)
	python? (
		dev-python/pybind11
		sci-libs/dlpack
		test? (
			dev-python/looseversion
			sci-ml/pytorch
			sci-ml/caffe2[cuda]
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.11.0-fix.patch"
	"${FILESDIR}"/${PN}-1.12.1-cmake.patch
	"${FILESDIR}"/${P}-python.patch
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	cmake_src_prepare

	sed -e 's#"cudnn_frontend/thirdparty/nlohmann/json.hpp"#<nlohmann/json.hpp>#' \
		-i include/cudnn_frontend_utils.h || die

	rm -r include/cudnn_frontend/thirdparty || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/opt/cuda/targets/x86_64-linux/lib"
		-DCMAKE_INSTALL_BINDIR="${EPREFIX}/opt/cuda/targets/x86_64-linux/bin"
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/opt/cuda/targets/x86_64-linux/include"
		-DCUDNN_FRONTEND_BUILD_PYTHON_BINDINGS="OFF"
		-DCUDNN_FRONTEND_BUILD_SAMPLES="$(usex test "$(usex samples)")"
		-DCUDNN_FRONTEND_BUILD_TESTS="$(usex test)"
		-DCUDNN_FRONTEND_SKIP_JSON_LIB="OFF"
	)

	if use samples || use test; then
		# allow slotted install
		: "${CUDNN_PATH:=${ESYSROOT}/opt/cuda}"
		export CUDNN_PATH
	fi

	cmake_src_configure

	use python && distutils-r1_src_configure
}

src_compile() {
	export CMAKE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)

	cmake_src_compile

	use python && distutils-r1_src_compile
}
distutils_enable_tests pytest

src_test() {
	cuda_add_sandbox -w

	"${BUILD_DIR}/bin/tests" || die

	if use samples; then
		"${BUILD_DIR}/bin/samples" || die
		"${BUILD_DIR}/bin/legacy_samples" || die
	fi

	cmake_src_test

	if use python; then
		cd "${S}" || die
		distutils-r1_src_test
	fi
}

python_test() {
	local EPYTEST_IGNORE=(
		# ValueError: no option named 'perf'
		test/python/test_mhas_v2.py
		# Need nvidia-cutlass-dsl i.e. CuteDSL
		test/python/fe_api
	)
	local EPYTEST_DESELECT=(
		# Failed with param: ((1, 128, 1024), torch.bfloat16)
		# AssertionError: Tensor-likes are not close!
		# Mismatched elements: 0.2%
		test/python/test_matmul_bias_relu.py::test_matmul_bias[param_extract4]
		# AssertionError: Legacy CUDA profiling requires use_cpu=True
		test/python/test_silu_and_mul.py::test_silu_and_mul_and_quantization
		# AssertionError: Tensor-likes are not close!
		test/python/test_kernel_cache.py::test_serialize_both_graph_and_kernel_cache
	)

	distutils-r1_python_test
}

src_install() {
	cmake_src_install

	if use test; then
		rm -R "${ED}/opt/cuda/targets/x86_64-linux/bin/tests" || die
	fi

	use python && distutils-r1_src_install
}
