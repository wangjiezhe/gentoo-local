# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check xpu/Cargo.toml
WANDB_XPU_PV="0.7.1"
# Check parquet-rust-wrapper/Cargo.toml
ARROR_RS_WRAPPER_PV="0.1.1"

WANDB_XPU="wandb-xpu-${WANDB_XPU_PV}"
ARROR_RS_WRAPPER="arrow-rs-wrapper-${ARROR_RS_WRAPPER_PV}"

# dev-python/sentry-sdk does not support python3.10
PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=hatchling
RUST_MIN_VER="1.88.0"
inherit cargo distutils-r1 go-module

DESCRIPTION="A tool for visualizing and tracking your machine learning experiments"
HOMEPAGE="https://github.com/wandb/wandb https://wandb.ai/"
SRC_URI="
	https://github.com/wandb/wandb/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${WANDB_XPU}-crates.tar.xz
			-> ${P}-${WANDB_XPU}-crates.tar.xz
		https://github.com/wangjiezhe/gentoo-go-deps/releases/download/${P}/${ARROR_RS_WRAPPER}-crates.tar.xz
			-> ${P}-${ARROR_RS_WRAPPER}-crates.tar.xz
	"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

#	sys-devel/binutils[gold]
BDEPEND="
	>=dev-lang/go-1.26.4:=
	dev-util/patchelf
"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sentry-sdk[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-0.18.5-hatch.patch"
)

DOC=( package_readme.md )

QA_PREBUILT="/usr/lib/python*/site-packages/wandb/bin/wandb-core"

src_unpack() {
	S="${WORKDIR}/${P}/core" go-module_src_unpack
	cargo_gen_config
}

src_prepare() {
	export CGO_LDFLAGS=$(echo "$CGO_LDFLAGS" | sed 's/-Wl,-z,pack-relative-relocs//g')
	distutils-r1_src_prepare
	sed -i "s/^go 1.26.5$/go 1.26.4/" core/go.mod || die
}
