# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )
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
	$(python_gen_cond_dep 'dev-python/orjson[${PYTHON_USEDEP}]' python3_12)
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	')
"

PATCHES=( "${FILESDIR}"/${PN}-0.12.2-setup.patch )

EPYTEST_PLUGINS=( h5py pyyaml pytest-rerunfailures )
EPYTEST_DESELECT=(
	# FileNotFoundError
	test/tensorclass/test_tensorclass.py::test_tensorclass_stub_methods
	test/tensorclass/test_tensorclass.py::test_tensorclass_instance_methods
	# RuntimeError: !is_cpu() || index_ <= 0 INTERNAL ASSERT FAILED
	test/tensordict/test_methods.py::TestTensorDicts::test_cast_to
)
distutils_enable_tests pytest

python_test() {
	cuda_add_sandbox -w
	rm -rf tensordict || die
	epytest
}
