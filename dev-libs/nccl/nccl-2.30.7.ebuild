# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic cmake cuda

DESCRIPTION="Optimized primitives for collective multi-GPU communication"
HOMEPAGE="https://developer.nvidia.com/nccl/"
SRC_URI="https://github.com/NVIDIA/nccl/archive/refs/tags/v${PV}-1.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}/${P}-1"
LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/nvidia-cuda-toolkit"
RDEPEND="${DEPEND}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-2.30.4-include.patch
	"${FILESDIR}"/${PN}-2.30.4-cmake-pkgconfig.patch
)

src_prepare() {
	cmake_src_prepare
	cuda_src_prepare
	append-cxxflags $(test-flags-CXX -ffat-lto-objects)
}
