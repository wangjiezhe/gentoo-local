# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# dev-python/sentry-sdk does not support python3.10
PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 go-module

DESCRIPTION="A tool for visualizing and tracking your machine learning experiments"
HOMEPAGE="https://github.com/wandb/wandb https://wandb.ai/"
SRC_URI="
	https://github.com/wandb/wandb/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

BDEPEND="dev-util/patchelf"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_USEDEP}]
		dev-python/docker-pycreds[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${P}-ld.patch"
	"${FILESDIR}/${P}-hatch.patch"
)

DOC=( package_readme.md )

src_unpack() {
	S="${WORKDIR}/${P}/core" go-module_src_unpack
}

src_install() {
	distutils-r1_src_install
	patchelf --add-needed libnvidia-ml.so.1 "${D}/$(python_get_sitedir)"/wandb/bin/wandb-core
}
