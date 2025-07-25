# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake readme.gentoo-r1

DESCRIPTION="Simple fan control program for thinkpads"
HOMEPAGE="https://github.com/vmatare/thinkfan"
SRC_URI="https://github.com/vmatare/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="atasmart nvidia +yaml"

DEPEND="atasmart? ( dev-libs/libatasmart )
	sys-apps/lm-sensors
	yaml? ( dev-cpp/yaml-cpp )"
RDEPEND="${DEPEND}
	nvidia? ( x11-drivers/nvidia-drivers )"

DOC_CONTENTS="
	Please read the documentation and copy an appropriate
	file to /etc/thinkfan.conf.
"

src_configure() {
	local mycmakeargs+=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DUSE_NVML="$(usex nvidia)"
		-DUSE_ATASMART="$(usex atasmart)"
		-DUSE_LM_SENSORS=ON		# compilation failed with OFF
		-DUSE_YAML="$(usex yaml)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	readme.gentoo_create_doc
}
