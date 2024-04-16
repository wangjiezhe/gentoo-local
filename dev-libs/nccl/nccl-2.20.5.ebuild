# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cuda

DESCRIPTION="Optimized primitives for collective multi-GPU communication"
HOMEPAGE="https://developer.nvidia.com/nccl/"
SRC_URI="https://github.com/NVIDIA/nccl/archive/refs/tags/v${PV}-1.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}/${P}-1"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/nvidia-cuda-toolkit"
RDEPEND="${DEPEND}"

DOCS=( README.md LICENSE.txt )

QA_PREBUILT="/opt/cuda/targets/x86_64-linux/lib/*"

src_prepare() {
	eapply_user
	cuda_src_prepare
}

src_configure() {
	export CUDA_HOME="${EPREFIX}/opt/cuda"
	export PREFIX="${EPREFIX}/opt/cuda/targets/x86_64-linux"	# used for nccl.pc
	export CXXFLAGS+=" -ffat-lto-objects"
	export CXX="$(cuda_gccdir | tr -d \")/g++"
	# Select custom NVCC_GENCODE or use detected ones.
	# See https://developer.nvidia.com/cuda-gpus
	# Example:
	# export NVCC_GENCODE="-gencode=arch=compute_89,code=sm_89"
	# or
	# echo "NVCC_GENCODE=\"-gencode=arch=compute_89,code=sm_89\"" >> /etc/portage/env/nccl
	# echo "dev-libs/nccl nccl" >> /etc/portage/package.env/pytorch
}

src_compile() {
	emake src.build
}

src_install() {
	emake PREFIX="${ED}/opt/cuda/targets/x86_64-linux" src.install

	dodir "/usr/$(get_libdir)"
	mv "${ED}/opt/cuda/targets/x86_64-linux/lib/pkgconfig" \
		"${ED}/usr/$(get_libdir)/pkgconfig" || die

	einstalldocs
}
