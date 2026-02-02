# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

CommitId="a61422fb9bafcf94af51440ddad4bb11b091f7aa"

DESCRIPTION="High-fidelity performance metrics for generative models in PyTorch"
HOMEPAGE="https://github.com/toshas/torch-fidelity"
SRC_URI="https://github.com/toshas/torch-fidelity/archive/${CommitId}.tar.gz
	-> ${P}.gh.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# Need network access

PATCHES=( "${FILESDIR}/${P}-install.patch" )

RDEPEND="
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	')
"
