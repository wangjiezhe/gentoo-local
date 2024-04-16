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
IUSE="cuda distributed fbgemm ffmpeg gloo magma mkl mpi nnpack +numpy onednn openblas opencl opencv openmp qnnpack rocm xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ffmpeg? ( opencv )
	mpi? ( distributed )
	gloo? ( distributed )
	?? ( cuda rocm )
	rocm? ( || ( ${ROCM_REQUIRED_USE} ) )
"

#		sci-libs/tensorrt
# Failed with onnx-1.15.0:
# /usr/lib64/libonnx.so: undefined reference to
# `onnx::AttributeProto_AttributeType_Name[abi:cxx11](onnx::AttributeProto_AttributeType)'
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
	>=sci-libs/onnx-1.12.0
	<sci-libs/onnx-1.15.0
	sci-libs/foxi
	cuda? (
		=dev-libs/cudnn-8*
		>=dev-libs/cudnn-frontend-0.9.2:0/8
		<dev-util/nvidia-cuda-toolkit-12.4.0:=[profiler]
		!=dev-libs/nccl-2.19.4*
		dev-libs/cusparselt
	)
	fbgemm? ( >=dev-libs/FBGEMM-2023.12.01 )
	ffmpeg? ( media-video/ffmpeg:= )
	gloo? ( sci-libs/gloo[cuda?] )
	magma? ( sci-libs/magma[cuda?] )
	mpi? ( virtual/mpi )
	nnpack? ( sci-libs/NNPACK )
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		') )
	onednn? ( dev-libs/oneDNN )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv:= )
	qnnpack? (
		sci-libs/QNNPACK
		dev-cpp/gemmlowp
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
	xnnpack? ( >=sci-libs/XNNPACK-2022.12.22 )
	mkl? ( sci-libs/mkl )
	openblas? ( sci-libs/openblas )
"
# Failed with cutlass-3.4.0:
# /usr/include/cutlass/bfloat16.h(94): error: name followed by "::" must be a class or namespace name
#        static_assert(cutlass::platform::is_integral<T>::value && sizeof(T) == 4, "Requires 32-bit integer");
# After apply patches:
# pytorch-2.2.0/aten/src/ATen/native/transformers/cuda/flash_attn/flash_bwd_kernel.h:
# error: no instance of constructor "Tensor" matches the argument list
# error: cannot deduce class template arguments
# Failed with cutlass-3.4.1:
# fatal error: cutlass/gemm/device/gemm_sparse_row_broadcast.h: No such file or directory
DEPEND="
	${RDEPEND}
	cuda? (
		>=dev-libs/cutlass-3.1.0
		<dev-libs/cutlass-3.4.0
	)
	onednn? ( sci-libs/ideep )
	dev-libs/psimd
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/flatbuffers
	>=sci-libs/kineto-0.4.0_p20231031
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	')
"

BDEPEND="
	dev-util/patchelf
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-gentoo.patch
	"${FILESDIR}"/${PN}-1.13.0-install-dirs.patch
	"${FILESDIR}"/${PN}-1.12.0-glog-0.6.0.patch
	"${FILESDIR}"/${PN}-1.13.1-tensorpipe.patch
	"${FILESDIR}"/${PN}-2.0.1-functorch.patch
	"${FILESDIR}"/${PN}-2.1.1-fbgemm.patch
	"${FILESDIR}"/${PN}-2.1.1-ffmpeg6.patch
	"${FILESDIR}"/${PN}-2.1.1-protobuf.patch
	"${FILESDIR}"/${PN}-2.1.1-lite-proto.patch
	"${FILESDIR}"/${PN}-2.1.1-opencl.patch
	"${FILESDIR}"/${PN}-2.2.0-cuSPARSELt.patch
	"${FILESDIR}"/${PN}-2.1.2-fix-rpath.patch
	"${FILESDIR}"/${PN}-2.1.2-fix-openmp-link.patch
	"${FILESDIR}"/${PN}-2.1.2-rocm-fix-std-cpp17.patch
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
		-DBUILD_CAFFE2=ON
		-DBUILD_BINARY=ON
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DUSE_LITE_PROTO=ON
		-DBUILD_SHARED_LIBS=ON

		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_MPI=$(usex mpi)
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_KINETO=OFF # TODO
		-DUSE_LEVELDB=OFF
		-DUSE_MAGMA=$(usex magma)
		-DMAGMA_V2=$(usex magma)
		-DUSE_MKLDNN=$(usex onednn)
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_QNNPACK=$(usex qnnpack)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex distributed)
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=$(usex rocm)
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DPYBIND11_PYTHON_VERSION="${EPYTHON#python}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DUSE_ITT=OFF
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_ONNX=ON
		-DONNX_PROTO_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libonnx_proto.so
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_METAL=OFF

		-Wno-dev
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	if use mkl; then
		mycmakeargs+=(-DBLAS=MKL)
	elif use openblas; then
		mycmakeargs+=(-DBLAS=OpenBLAS)
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
			-DUSE_SYSTEM_NCCL=ON
		)
	elif use rocm; then
		export PYTORCH_ROCM_ARCH="$(get_amdgpu_flags)"

		mycmakeargs+=(
			-DUSE_NCCL=ON
			-DUSE_SYSTEM_NCCL=ON
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
	mv "${D}/$(python_get_sitedir)"/caffe2 python/ || die
	cp torch/version.py python/torch/ || die
	python_domodule python/caffe2
	python_domodule python/torch
}
