# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Hassle-free computation of shareable, comparable, and reproducible BLEU, chrF, and TER scores"
HOMEPAGE="https://github.com/mjpost/sacrebleu https://pypi.org/project/sacrebleu/"
## setuptools-scm requires pypi tarballs or fully intact git repository
## instead of most other sources (such as GitHub's tarballs, a git checkout without the .git folder).
# SRC_URI="https://github.com/mjpost/sacrebleu/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/portalocker[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		## Need network
		test/test_api.py::test_api_get_source
		test/test_api.py::test_api_get_reference
		test/test_dataset.py::test_maybe_download
		test/test_dataset.py::test_process_to_text
		test/test_dataset.py::test_get_files_and_fieldnames
		test/test_dataset.py::test_source_and_references
		test/test_dataset.py::test_wmt22_references
	)
	epytest
}
