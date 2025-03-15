# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

# CommitId="b3ea6da153ab61b3b8687544c0708a4234a8fb58"

DESCRIPTION="A lightweight library for PyTorch training tools and utilities"
HOMEPAGE="https://github.com/facebookresearch/iopath"
# SRC_URI="https://github.com/facebookresearch/iopath/archive/${CommitId}.tar.gz -> ${P}.gh.tar.gz"
# S="${WORKDIR}/${PN}-${CommitId}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# RESTRICT="test"

RDEPEND="
		dev-python/portalocker[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_any_dep 'sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]')
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		## Need network
		tests/test_download.py::TestDownload::test_download
		tests/test_file_io.py::TestHTTPIO::test_bad_args
	)
	epytest tests/test_*.py
}
