# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 multiprocessing prefix pypi

DESCRIPTION="Protobuf code generator for gRPC"
HOMEPAGE="https://grpc.io"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	~dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
	>=dev-python/protobuf-5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	${BDEPEND}
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

python_configure_all() {
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}
