# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
ROCM_VERSION=5.7
inherit python-single-r1 cmake cuda flag-o-matic prefix rocm

MYPN=pytorch
MYP=${MYPN}-${PV}

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz"

S="${WORKDIR}"/${MYP}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="blis cuda distributed fbgemm flash gloo magma mkl mpi nnpack +numpy onednn openblas opencl openmp qnnpack rocm xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	mpi? ( distributed )
	gloo? ( distributed )
	?? ( cuda rocm )
	rocm? (
		|| ( ${ROCM_REQUIRED_USE} )
		!flash
	)
	?? ( blis mkl openblas )
"

#		sci-libs/tensorrt
RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/gflags:=
	>=dev-cpp/glog-0.5.0
	dev-libs/cpuinfo
	dev-libs/libfmt
	dev-libs/protobuf:=
	dev-libs/pthreadpool
	dev-libs/sleef
	virtual/lapack
	sci-libs/onnx
	sci-libs/foxi
	cuda? (
		=dev-libs/cudnn-8*
		>=dev-libs/cudnn-frontend-1.0.3:0/8
		<dev-util/nvidia-cuda-toolkit-12.4.0:=[profiler]
		dev-libs/nccl
		!=dev-libs/nccl-2.19.4*
		dev-libs/cusparselt
	)
	fbgemm? ( >=dev-libs/FBGEMM-2023.12.01 )
	gloo? ( sci-libs/gloo[cuda?] )
	magma? ( sci-libs/magma[cuda?] )
	mpi? ( virtual/mpi )
	nnpack? ( sci-libs/NNPACK )
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		') )
	onednn? ( dev-libs/oneDNN )
	opencl? ( virtual/opencl )
	qnnpack? (
		dev-cpp/gemmlowp
		dev-libs/clog
	)
	rocm? (
		>=dev-util/hip-5.7
		>=dev-libs/rccl-5.7[${ROCM_USEDEP}]
		>=sci-libs/rocThrust-5.7[${ROCM_USEDEP}]
		>=sci-libs/rocPRIM-5.7[${ROCM_USEDEP}]
		>=sci-libs/hipBLAS-5.7[${ROCM_USEDEP}]
		>=sci-libs/hipFFT-5.7[${ROCM_USEDEP}]
		>=sci-libs/hipSPARSE-5.7[${ROCM_USEDEP}]
		>=sci-libs/hipRAND-5.7[${ROCM_USEDEP}]
		>=sci-libs/hipCUB-5.7[${ROCM_USEDEP}]
		>=sci-libs/hipSOLVER-5.7[${ROCM_USEDEP}]
		>=sci-libs/miopen-5.7[${ROCM_USEDEP}]
		>=dev-util/roctracer-5.7[${ROCM_USEDEP}]
	)
	distributed? ( sci-libs/tensorpipe[cuda?] )
	xnnpack? ( >=sci-libs/XNNPACK-2024.02.29 )
	mkl? ( sci-libs/mkl )
	openblas? ( sci-libs/openblas )
	blis? ( || ( sci-libs/blis sci-libs/aocl-blas ) )
"
# Failed with cutlass-3.5.0:
# error: namespace "cute::detail" has no member "is_prefetch"
# See https://github.com/NVIDIA/cutlass/issues/1484
# and https://github.com/NVIDIA/cutlass/issues/1508
DEPEND="
	${RDEPEND}
	cuda? (
		>=dev-libs/cutlass-3.4.1
		<dev-libs/cutlass-3.5.0
	)
	onednn? ( sci-libs/ideep )
	dev-cpp/cpp-httplib
	dev-cpp/opentelemetry-cpp
	dev-libs/psimd
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/flatbuffers
	>=sci-libs/kineto-0.4.0_p20240525
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"

BDEPEND="
	dev-util/patchelf
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-install-dirs.patch
	"${FILESDIR}"/${PN}-1.12.0-glog-0.6.0.patch
	"${FILESDIR}"/${PN}-1.13.1-tensorpipe.patch
	"${FILESDIR}"/${PN}-2.3.0-cudnn_include_fix.patch
	"${FILESDIR}"/${PN}-2.0.1-functorch.patch
	"${FILESDIR}"/${PN}-2.1.2-fix-rpath.patch
	"${FILESDIR}"/${P}-fix-openmp-link.patch
	"${FILESDIR}"/${P}-rocm-fix-std-cpp17.patch
	"${FILESDIR}"/${PN}-2.2.2-musl.patch
	"${FILESDIR}"/${P}-missing-binaries.patch
	"${FILESDIR}"/${P}-qnnpack.patch
	"${FILESDIR}"/${P}-blis.patch
)

src_prepare() {
	filter-lto #bug 862672
	sed -i \
		-e "/third_party\/gloo/d" \
		cmake/Dependencies.cmake \
		|| die
	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd

	sed -i "s|@LIBDIR@|$(get_libdir)|g" \
		aten/src/ATen/native/quantized/cpu/qnnpack/CMakeLists.txt \
		cmake/Modules/FindBLIS.cmake \
		|| die

	# prefixify the hardcoded paths, after all patches are applied
	hprefixify \
		aten/CMakeLists.txt \
		caffe2/CMakeLists.txt \
		cmake/Metal.cmake \
		cmake/Modules/*.cmake \
		cmake/Modules_CUDA_fix/FindCUDNN.cmake \
		cmake/Modules_CUDA_fix/upstream/FindCUDA/make2cmake.cmake \
		cmake/Modules_CUDA_fix/upstream/FindPackageHandleStandardArgs.cmake \
		cmake/public/LoadHIP.cmake \
		cmake/public/cuda.cmake \
		cmake/Dependencies.cmake \
		torch/CMakeLists.txt \
		CMakeLists.txt

	if use rocm; then
		sed -e "s:/opt/rocm:/usr:" \
			-e "s:lib/cmake:$(get_libdir)/cmake:g" \
			-e "s/HIP 1.0/HIP 1.0 REQUIRED/" \
			-i cmake/public/LoadHIP.cmake || die

		ebegin "HIPifying cuda sources"
		${EPYTHON} tools/amd_build/build_amd.py || die
		eend $?
	fi
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
		ewarn "WARNING: caffe2 is being built with its default CUDA compute capabilities: 3.5 and 7.0."
		ewarn "These may not be optimal for your GPU."
		ewarn ""
		ewarn "To configure caffe2 with the CUDA compute capability that is optimal for your GPU,"
		ewarn "set TORCH_CUDA_ARCH_LIST in your make.conf, and re-emerge caffe2."
		ewarn "For example, to use CUDA capability 7.5 & 3.5, add: TORCH_CUDA_ARCH_LIST=7.5 3.5"
		ewarn "For a Maxwell model GPU, an example value would be: TORCH_CUDA_ARCH_LIST=Maxwell"
		ewarn ""
		ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
		ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
	fi

	local mycmakeargs=(
		-DBUILD_BINARY=OFF
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DUSE_LITE_PROTO=ON
		-DBUILD_SHARED_LIBS=ON
		-DUSE_SYSTEM_LIBS=ON

		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_MPI=$(usex mpi)
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FLASH_ATTENTION=$(usex flash)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_KINETO=OFF # TODO
		-DUSE_MAGMA=$(usex magma)
		-DMAGMA_V2=$(usex magma)
		-DUSE_MKLDNN=$(usex onednn)
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex distributed)
		-DUSE_PYTORCH_QNNPACK=$(usex qnnpack)
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=$(usex rocm)
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_ITT=OFF
		-DONNX_PROTO_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libonnx_proto.so

		-Wno-dev
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	if use mkl; then
		mycmakeargs+=(-DBLAS=MKL)
	elif use openblas; then
		mycmakeargs+=(-DBLAS=OpenBLAS)
	elif use blis; then
		mycmakeargs+=(-DBLAS=BLIS)
	else
		mycmakeargs+=(-DBLAS=Generic -DBLAS_LIBRARIES=)
	fi

	if use cuda; then
		addpredict "/dev/nvidiactl" # bug 867706
		addpredict "/dev/char"
		addpredict "/proc/self/task" # bug 926116

		mycmakeargs+=(
			-DUSE_CUDNN=ON
			# -DUSE_TENSORRT=$(usex cuda)
			-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5 7.0}"
			-DBUILD_NVFUSER=ON
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
			-DUSE_NCCL=ON
		)
	elif use rocm; then
		export PYTORCH_ROCM_ARCH="$(get_amdgpu_flags)"

		mycmakeargs+=(
			-DUSE_NCCL=ON
		)
	fi

	if use onednn; then
		mycmakeargs+=(
			-DUSE_MKLDNN=ON
			-DMKLDNN_FOUND=ON
			-DMKLDNN_LIBRARIES=dnnl
			-DMKLDNN_INCLUDE_DIR="${ESYSROOT}/usr/include/oneapi/dnnl"
		)
	fi

	cmake_src_configure

	# do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_install() {
	cmake_src_install

	patchelf --remove-rpath "${ED}/usr/lib64/libtorch_cpu.so"

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}"/CMakeCache.txt

	rm -rf python || die
	mkdir -p python/torch || die
	cp torch/version.py python/torch/ || die
	python_domodule python/torch
}
