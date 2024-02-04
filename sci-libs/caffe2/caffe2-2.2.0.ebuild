# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-single-r1 cmake cuda flag-o-matic prefix

MYPN=pytorch
MYP=${MYPN}-${PV}

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda distributed fbgemm ffmpeg gloo magma mpi nnpack +numpy opencl opencv openmp qnnpack tensorpipe xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ffmpeg? ( opencv )
	mpi? ( distributed )
	tensorpipe? ( distributed )
	distributed? ( tensorpipe )
	gloo? ( distributed )
	magma? ( cuda )
" # ?? ( cuda rocm )

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
	sci-libs/lapack
	>=sci-libs/onnx-1.12.0
	<sci-libs/onnx-1.15.0
	sci-libs/foxi
	cuda? (
		=dev-libs/cudnn-8*
		>=dev-libs/cudnn-frontend-0.9.2:0/8
		dev-util/nvidia-cuda-toolkit:=[profiler]
		<=dev-libs/nccl-2.19.1
		dev-libs/cusparselt
	)
	fbgemm? ( >=dev-libs/FBGEMM-2023.11.02 )
	ffmpeg? ( media-video/ffmpeg:= )
	gloo? ( sci-libs/gloo[cuda?] )
	magma? ( sci-libs/magma[cuda?] )
	mpi? ( virtual/mpi )
	nnpack? ( sci-libs/NNPACK )
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		') )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv:= )
	qnnpack? ( sci-libs/QNNPACK dev-cpp/gemmlowp )
	tensorpipe? ( sci-libs/tensorpipe[cuda?] )
	xnnpack? ( >=sci-libs/XNNPACK-2022.12.22 )
"
# Failed with cutlass-3.4.0:
# /usr/include/cutlass/bfloat16.h(94): error: name followed by "::" must be a class or namespace name
#        static_assert(cutlass::platform::is_integral<T>::value && sizeof(T) == 4, "Requires 32-bit integer");
DEPEND="
	${RDEPEND}
	dev-cpp/benchmark
	dev-cpp/eigen
	cuda? (
		>=dev-libs/cutlass-3.1.0
		<dev-libs/cutlass-3.4.0
	)
	dev-libs/psimd
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/flatbuffers
	sci-libs/kineto
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	')
"

S="${WORKDIR}"/${MYP}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-1.13.0-install-dirs.patch
	"${FILESDIR}"/${PN}-1.12.0-glog-0.6.0.patch
	"${FILESDIR}"/${PN}-1.13.1-tensorpipe.patch
	"${FILESDIR}"/${PN}-2.0.1-functorch.patch
	"${FILESDIR}"/${PN}-2.1.1-fbgemm.patch
	"${FILESDIR}"/${PN}-2.1.1-ffmpeg6.patch
	"${FILESDIR}"/${PN}-2.1.1-protobuf.patch
	"${FILESDIR}"/${PN}-2.1.1-lite-proto.patch
	"${FILESDIR}"/${PN}-2.1.1-opencl.patch
	"${FILESDIR}"/${P}-cuSPARSELt.patch
)

src_prepare() {
	filter-lto #bug 862672
	sed -i \
		-e "/third_party\/gloo/d" \
		cmake/Dependencies.cmake \
		|| die
	# Fix cmake prefix path
	sed -i "s|cmake_prefix_path = _osp.*|cmake_prefix_path = '/usr/share/cmake'|g" torch/utils/__init__.py
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
		-DUSE_CUDNN=$(usex cuda)
		# -DUSE_TENSORRT=$(usex cuda)
		-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5 7.0}"
		-DBUILD_NVFUSER=$(usex cuda)
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
		-DUSE_MKLDNN=OFF
		-DUSE_NCCL=$(usex cuda)
		-DUSE_SYSTEM_NCCL=$(usex cuda)
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_QNNPACK=$(usex qnnpack)
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex tensorpipe)
		-DUSE_PYTORCH_QNNPACK=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_ROCM=OFF # TODO
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DPYBIND11_PYTHON_VERSION="${EPYTHON#python}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DUSE_ITT=OFF
		-DBLAS=Eigen # avoid the use of MKL, if found on the system
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_ONNX=ON
		-DONNX_PROTO_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libonnx_proto.so
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_SLEEF=ON

		-Wno-dev
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	if use cuda; then
		addpredict "/dev/nvidiactl" # bug 867706
		addpredict "/dev/char"

		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}"/CMakeCache.txt

	rm -rf python || die
	mkdir -p python/torch || die
	mv "${D}/$(python_get_sitedir)"/caffe2 python/ || die
	cp torch/version.py python/torch/ || die
	python_domodule python/caffe2
	python_domodule python/torch
}
