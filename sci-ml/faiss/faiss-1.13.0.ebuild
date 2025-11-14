# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 cmake cuda

DESCRIPTION="A library for efficient similarity search and clustering of dense vectors"
HOMEPAGE="https://github.com/facebookresearch/faiss"
SRC_URI="https://github.com/facebookresearch/faiss/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
CPU_FLAGS="cpu_flags_x86_avx512f cpu_flags_x86_avx2"
IUSE="python cuda test ${CPU_FLAGS}"
RESTRICT="!test? ( test )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
		')
		dev-lang/swig
		dev-util/patchelf
	)
	test? (
		dev-cpp/gtest
		dev-cpp/benchmark
	)
"
BDEPEND="python? ( ${DISTUTILS_DEPS} )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/${PN}-1.12.0-test.patch"
)

src_prepare() {
	cmake_src_prepare
	use cuda && cuda_src_prepare
	use python && python_copy_sources
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DFAISS_ENABLE_GPU=$(usex cuda ON OFF)
		-DFAISS_ENABLE_PYTHON=$(usex python ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)
		-DFAISS_OPT_LEVEL=$(usex cpu_flags_x86_avx512f avx512 $(usex cpu_flags_x86_avx2 avx2 generic))
	)
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_configure
	else
		cmake_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_compile
	else
		cmake_src_compile
	fi
}

src_install() {
	do_install() {
		cmake_src_install
		cd faiss/python || die
		patchelf --set-rpath '$ORIGIN' *.so || die
		python_moduleinto faiss
		python_domodule .
		rm -rf "${D}/$(python_get_sitedir)"/faiss/CMakeFiles || die
		rm -rf "${D}/$(python_get_sitedir)"/faiss/cmake_install.cmake || die
		chmod +x "${D}/$(python_get_sitedir)"/faiss/*.so || die
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_install
	else
		cmake_src_install
	fi
}

src_test() {
	cuda_add_sandbox -w
	do_test() {
		cmake_src_test
		# cd "${S}"/tests
		# epytest *.py
		# use cuda && epytest "${S}"/faiss/gpu/test/*.py
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_test
	else
		cmake_src_test
	fi
}
