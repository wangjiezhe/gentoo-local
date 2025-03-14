# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
inherit distutils-r1 prefix

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
BDEPEND="
	~sci-ml/caffe2-${PV}[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="
	${PYTHON_DEPS}
	${BDEPEND}
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/opt-einsum[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"

QA_PREBUILT="usr/lib/python*/site-packages/functorch/_C.*.so"

PATCHES=(
	"${FILESDIR}"/${P}-don-t-build-libtorch-again.patch
	"${FILESDIR}"/${P}-Change-library-directory-according-to-CMake-build.patch
	"${FILESDIR}"/${P}-global-dlopen.patch
	"${FILESDIR}"/${PN}-2.5.1-torch_shm_manager.patch
	"${FILESDIR}"/${P}-setup.patch
)

src_prepare() {
	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die

	# Crazy workaround for splitting "caffe2" and "pytorch" in two different packages:
	cp -a "${EPREFIX}/usr/$(get_libdir)/functorch.so" functorch/ || die

	distutils-r1_src_prepare

	hprefixify tools/setup_helpers/env.py
}

python_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	distutils-r1_python_compile develop sdist
}

python_install() {
	USE_SYSTEM_LIBS=ON distutils-r1_python_install

	dosym -r "/usr/include/torch" "$(python_get_sitedir)/torch/include/torch"
	dosym -r "/usr/lib64" "$(python_get_sitedir)/torch/lib"
}
