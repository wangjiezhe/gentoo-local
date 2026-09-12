# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 23 )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{12..14} python3_14t )

inherit distutils-r1 llvm-r2

DESCRIPTION="A language and compiler for custom Deep Learning operations"
HOMEPAGE="
	https://github.com/triton-lang/triton
	https://triton-lang.org/
"
SRC_URI="https://github.com/triton-lang/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"

DEPEND="
	dev-util/nvidia-cuda-toolkit
	$(llvm_gen_dep '
		llvm-core/llvm:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
		llvm-core/mlir:${LLVM_SLOT}
	' )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/cmake
	dev-build/ninja
	dev-python/nanobind[${PYTHON_USEDEP}]
	dev-python/lit[${PYTHON_USEDEP}]
	$(llvm_gen_dep 'llvm-core/mlir:${LLVM_SLOT}' )
"

QA_PRESTRIPPED=".*/site-packages/triton/FileCheck"

PATCHES=(
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-mlir-10739.patch
	"${FILESDIR}"/${P}-mlir-11163.patch
	"${FILESDIR}"/${P}-fix-llvm-link.patch
)

src_prepare() {
	sed -i \
		-e "/LLVM_LIBRARY_DIR/s:/lib:/$(get_libdir):" \
		CMakeLists.txt || die
	sed -i \
		-e "s:^include_dirs = \[\(.\+\)\]$:include_dirs = [\1, ${ESYSROOT}/opt/cuda/include]:" \
		third_party/nvidia/backend/driver.py || die

	distutils-r1_src_prepare
}

python_compile() {
	local -x BUILD_TESTING=OFF
	local -x TRITON_BUILD_WITH_CCACHE=OFF

	local -x TRITON_OFFLINE_BUILD=ON
	local -x LLVM_SYSPATH="$(get_llvm_prefix)"
	local -x JSON_SYSPATH="${ESYSROOT}/usr"
	local -x TRITON_PTXAS_PATH="${ESYSROOT}/opt/cuda/bin"
	local -x TRITON_PTXAS_BLACKWELL_PATH="${ESYSROOT}/opt/cuda/bin"
	local -x TRITON_CUOBJDUMP_PATH="${ESYSROOT}/opt/cuda/bin"
	local -x TRITON_NVDISASM_PATH="${ESYSROOT}/opt/cuda/bin"
	local -x TRITON_CUDACRT_PATH="${ESYSROOT}/opt/cuda/include/crt"
	local -x TRITON_CUDART_PATH="${ESYSROOT}/opt/cuda/include"
	local -x TRITON_CUPTI_INCLUDE_PATH="${ESYSROOT}/opt/cuda/extras/CUPTI/include"
	local -x TRITON_CUPTI_LIB_PATH="${ESYSROOT}/opt/cuda/extras/CUPTI/lib64"
	local -x TRITON_CUPTI_LIB_BLACKWELL_PATH="${ESYSROOT}/opt/cuda/extras/CUPTI/lib64"

	distutils-r1_python_compile
}
