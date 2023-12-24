# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

CommitId="3dcb32c877dbbcbdd5023806a69c000e19fd0285"

DESCRIPTION="High-fidelity performance metrics for generative models in PyTorch"
HOMEPAGE="https://github.com/toshas/torch-fidelity"
SRC_URI="https://github.com/toshas/torch-fidelity/archive/${CommitId}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# Need network access

PATCHES=( "${FILESDIR}/${P}-install.patch" )

S="${WORKDIR}"/${PN}-${CommitId}

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	')
"
