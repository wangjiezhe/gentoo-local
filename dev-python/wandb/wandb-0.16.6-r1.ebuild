# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# dev-python/sentry-sdk does not support python3.10
PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A tool for visualizing and tracking your machine learning experiments"
HOMEPAGE="https://github.com/wandb/wandb https://wandb.ai/"
SRC_URI="https://github.com/wandb/wandb/archive/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_USEDEP}]
		dev-python/docker-pycreds[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/appdirs[${PYTHON_USEDEP}]
	')
"
