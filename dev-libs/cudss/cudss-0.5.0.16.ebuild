# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CUDA_MA="12"

DESCRIPTION="A high-performance CUDA Library for Direct Sparse Solvers"
HOMEPAGE="https://developer.nvidia.com/cudss"
SRC_URI="https://developer.download.nvidia.com/compute/cudss/redist/libcudss/linux-x86_64/libcudss-linux-x86_64-${PV}_cuda${CUDA_MA}-archive.tar.xz"
S="${WORKDIR}/libcudss-linux-x86_64-${PV}_cuda${CUDA_MA}-archive"

LICENSE="NVIDIA-cuDSS"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
RESTRICT="mirror"

RDEPEND="=dev-util/nvidia-cuda-toolkit-12*"

QA_PREBUILT="/opt/cuda/targets/x86_64-linux/lib/*"

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include lib
}
