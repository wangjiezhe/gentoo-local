# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CUDA_MA="12"

DESCRIPTION="A High-Performance CUDA Library for Sparse Matrix-Matrix Multiplication"
HOMEPAGE="https://docs.nvidia.com/cuda/cusparselt/index.html"
SRC_URI="https://developer.download.nvidia.com/compute/cusparselt/redist/libcusparse_lt/linux-x86_64/libcusparse_lt-linux-x86_64-${PV}_cuda${CUDA_MA}-archive.tar.xz"
S="${WORKDIR}/libcusparse_lt-linux-x86_64-${PV}_cuda${CUDA_MA}-archive"

LICENSE="NVIDIA-cuSPARSELt"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
RESTRICT="bindist mirror"

RDEPEND="=dev-util/nvidia-cuda-toolkit-12*"

QA_PREBUILT="/opt/cuda/targets/x86_64-linux/lib/*"

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include lib
}
