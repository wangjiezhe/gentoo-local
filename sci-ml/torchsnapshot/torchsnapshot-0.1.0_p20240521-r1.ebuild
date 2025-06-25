# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

CommitId="e8a1fc097b4138493f05e5cac986730d116d0063"

DESCRIPTION="A performant, memory-efficient checkpointing library for PyTorch applications"
HOMEPAGE="https://github.com/pytorch/torchsnapshot"
SRC_URI="https://github.com/pytorch/torchsnapshot/archive/${CommitId}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${CommitId}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/nest-asyncio[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyre-extensions[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=( "${FILESDIR}/179-Fix-for-getting-socket-name-for-IPv4-addresses.patch" )

distutils_enable_tests pytest

python_test() {
	export CUDA_LAUNCH_BLOCKING=1
	export TORCH_USE_CUDA_DSA=1
	## FIXME
	local EPYTEST_DESELECT=(
		## RuntimeError: CUDA error: invalid device ordinal
		## Compile with `TORCH_USE_CUDA_DSA` to enable device-side assertions.
		tests/test_pg_wrapper.py::TestPGWrapper::test_scatter_obj_list_nccl
		tests/test_uvm_tensor.py::test_uvm_tensor
		tests/gpu_tests
	)
	epytest
}
