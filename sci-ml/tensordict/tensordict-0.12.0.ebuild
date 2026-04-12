# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13..14}t )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit cuda distutils-r1

DESCRIPTION="A pytorch dedicated tensor container"
HOMEPAGE="
	https://github.com/pytorch/tensordict
	https://pypi.org/project/tensordict/
"
SRC_URI="https://github.com/pytorch/tensordict/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/cloudpickle[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		>=dev-python/pyvers-0.2.0[${PYTHON_USEDEP}]
	')
	$(python_gen_cond_dep 'dev-python/orjson[${PYTHON_USEDEP}]' python3_{11..12})
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	')
"

EPYTEST_PLUGINS=( h5py pyyaml pytest-rerunfailures )
EPYTEST_DESELECT=(
	# need triton
	test/test_compile.py::TestTD::test_to
	test/test_compile.py::TestTC::test_tc_to
	"test/test_compile.py::TestCudaGraphs::test_cudagraphs_random[True]"
	"test/test_compile.py::TestCudaGraphs::test_backprop[True]"
	"test/test_compile.py::TestCudaGraphs::test_tdmodule[True]"
	"test/test_compile.py::TestCudaGraphs::test_td_input_non_tdmodule[True]"
	"test/test_compile.py::TestCudaGraphs::test_td_input_non_tdmodule_nontensor[True]"
	"test/test_compile.py::TestCudaGraphs::test_state_dict[True]"
	# FileNotFoundError
	test/test_tensorclass.py::test_tensorclass_stub_methods
	test/test_tensorclass.py::test_tensorclass_instance_methods
	# RuntimeError: !is_cpu() || index_ <= 0 INTERNAL ASSERT FAILED
	test/test_tensordict.py::TestTensorDicts::test_cast_to
	# AssertionError: assert 'a string!' == 'a metadata!'
	"test/test_tensordict.py::TestTensorDicts::test_save_load_memmap[td_with_non_tensor_and_metadata-device31]"
	"test/test_tensordict.py::TestTensorDicts::test_save_load_memmap[td_with_non_tensor_and_metadata-device32]"
)
distutils_enable_tests pytest

python_test() {
	cuda_add_sandbox -w
	rm -rf tensordict || die
	epytest
}
