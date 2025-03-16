# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 cmake flag-o-matic

DESCRIPTION="Open Neural Network Exchange (ONNX)"
HOMEPAGE="https://github.com/onnx/onnx"
SRC_URI="https://github.com/onnx/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="disableStaticReg +python test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	)
	>=dev-libs/protobuf-4.22.0:=
"
DEPEND="${RDEPEND}
	dev-cpp/abseil-cpp"

BDEPEND="
	python? ( ${DISTUTILS_DEPS} )
	test? (
		dev-cpp/gtest
		python? (
			dev-python/google-re2[${PYTHON_USEDEP}]
			dev-python/nbval[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.15.0-hidden.patch"
)

src_prepare() {
	cmake_src_prepare
	# https://github.com/onnx/onnx/issues/5740
	# https://github.com/protocolbuffers/protobuf/issues/14500
	append-ldflags -Wl,--copy-dt-needed-entries
	use python && distutils-r1_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DONNX_USE_PROTOBUF_SHARED_LIBS=ON
		-DONNX_USE_LITE_PROTO=ON
		-DONNX_BUILD_SHARED_LIBS=ON
		-DONNX_DISABLE_STATIC_REGISTRATION=$(usex disableStaticReg ON OFF)
		-DONNX_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile
	use python && CMAKE_ARGS="${mycmakeargs[@]}" distutils-r1_src_compile
}

src_install() {
	cmake_src_install
	use python && distutils-r1_src_install
}

distutils_enable_tests pytest

src_test() {
	cmake_src_test
	use python && distutils-r1_src_test
}

python_test() {
	rm -rf onnx || die
	epytest --pyargs onnx
}
