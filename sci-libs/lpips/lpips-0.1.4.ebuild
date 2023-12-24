# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="Perceptual Similarity Metric and Dataset"
HOMEPAGE="https://github.com/richzhang/PerceptualSimilarity"
SRC_URI="https://github.com/richzhang/PerceptualSimilarity/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/PerceptualSimilarity-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"		# Need network access

RDEPEND="
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	')
"
