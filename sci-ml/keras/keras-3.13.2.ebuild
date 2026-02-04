# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="https://keras.io/ https://github.com/keras-team/keras"
# Use pypi source to support traditional `tf.keras` module
# SRC_URI="https://github.com/keras-team/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/namex[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/optree[${PYTHON_USEDEP}]
	dev-python/ml-dtypes[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"
