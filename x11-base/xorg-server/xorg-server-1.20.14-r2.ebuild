# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3 toolchain-funcs
EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"

DESCRIPTION="X.Org X servers"
SLOT="0/${PV}"
if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
fi

IUSE_SERVERS="kdrive xephyr xnest xorg xvfb"
IUSE="${IUSE_SERVERS} debug +elogind minimal selinux suid systemd test +udev unwind xcsecurity"
RESTRICT="!test? ( test )"

CDEPEND="
	media-libs/libglvnd[X]
	dev-libs/openssl:0=
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libdrm-2.4.89
	>=x11-libs/libpciaccess-0.12.901
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-misc/xbitmaps-1.0.1
	>=x11-misc/xkeyboard-config-2.4.1-r3
	kdrive? (
		>=x11-libs/libXext-1.0.5
		x11-libs/libXv
	)
	xephyr? (
		x11-libs/libxcb[xkb]
		x11-libs/xcb-util
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
	!minimal? (
		>=x11-libs/libX11-1.1.5
		>=x11-libs/libXext-1.0.5
		>=media-libs/mesa-18[X(+),egl(+),gbm(+)]
		>=media-libs/libepoxy-1.5.4[X,egl(+)]
	)
	udev? ( virtual/libudev:= )
	unwind? ( sys-libs/libunwind:= )
	>=x11-apps/xinit-1.3.3-r1
	selinux? (
		sys-process/audit
		sys-libs/libselinux:=
	)
	systemd? (
		sys-apps/dbus
		sys-apps/systemd
	)
	elogind? (
		sys-apps/dbus
		sys-auth/elogind[pam]
		sys-auth/pambase[elogind]
	)
	!!x11-drivers/nvidia-drivers[-libglvnd(+)]
"
DEPEND="${CDEPEND}
	>=x11-base/xorg-proto-2018.4
	>=x11-libs/xtrans-1.3.5
"
RDEPEND="${CDEPEND}
	!systemd? ( gui-libs/display-manager-init )
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="
	sys-devel/flex
"
PDEPEND="
	xorg? ( >=x11-base/xorg-drivers-$(ver_cut 1-2) )"

REQUIRED_USE="!minimal? (
		|| ( ${IUSE_SERVERS} )
	)
	elogind? ( udev )
	?? ( elogind systemd )
	xephyr? ( kdrive )"

UPSTREAMED_PATCHES=(
)

PATCHES=(
	"${UPSTREAMED_PATCHES[@]}"
	"${FILESDIR}"/${P}-hw-Rename-boolean-config-value-field-from-bool-to-bo.patch
	"${FILESDIR}"/${PN}-1.12-unloadsubmodule.patch
	# needed for new eselect-opengl, bug #541232
	"${FILESDIR}"/${PN}-1.18-support-multiple-Files-sections.patch
)

src_configure() {
	# localstatedir is used for the log location; we need to override the default
	#	from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	# NOTE: fop is used for doc generating; and I have no idea if Gentoo
	#	package it somewhere
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable kdrive)
		$(use_enable test unit-tests)
		$(use_enable unwind libunwind)
		$(use_enable !minimal record)
		$(use_enable !minimal xfree86-utils)
		$(use_enable !minimal dri)
		$(use_enable !minimal dri2)
		$(use_enable !minimal dri3)
		$(use_enable !minimal glamor)
		$(use_enable !minimal glx)
		$(use_enable xcsecurity)
		$(use_enable xephyr)
		$(use_enable selinux xselinux)
		$(use_enable xnest)
		$(use_enable xorg)
		$(use_enable xvfb)
		$(use_enable udev config-udev)
		$(use_with systemd systemd-daemon)
		--enable-ipv6
		--disable-xwayland
		--enable-libdrm
		--sysconfdir="${EPREFIX}"/etc/X11
		--localstatedir="${EPREFIX}"/var
		--with-fontrootdir="${EPREFIX}"/usr/share/fonts
		--with-xkb-output="${EPREFIX}"/var/lib/xkb
		--disable-config-hal
		--disable-linux-acpi
		--without-dtrace
		--without-doxygen
		--without-fop
		--without-xmlto
		--with-os-vendor=Gentoo
		--with-sha1=libcrypto
		CPP="$(tc-getPROG CPP cpp)"
	)

	if use systemd || use elogind; then
		XORG_CONFIGURE_OPTIONS+=(
			--enable-systemd-logind
			--disable-install-setuid
			$(use_enable suid suid-wrapper)
		)
	else
		XORG_CONFIGURE_OPTIONS+=(
			--disable-systemd-logind
			--disable-suid-wrapper
			$(use_enable suid install-setuid)
		)
	fi

	xorg-3_src_configure
}

server_based_install() {
	if ! use xorg; then
		rm -f "${ED}"/usr/share/man/man1/Xserver.1x \
			"${ED}"/usr/$(get_libdir)/xserver/SecurityPolicy \
			"${ED}"/usr/$(get_libdir)/pkgconfig/xorg-server.pc \
			"${ED}"/usr/share/man/man1/Xserver.1x || die
	fi
}

src_install() {
	xorg-3_src_install

	server_based_install

	if ! use minimal && use xorg; then
		# Install xorg.conf.example into docs
		dodoc "${S}"/hw/xfree86/xorg.conf.example

		rm \
			"${ED}"/usr/bin/cvt \
			"${ED}"/usr/share/man/man1/cvt.1 || die
	fi

	# install the @x11-module-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/xorg-sets.conf xorg.conf

	find "${ED}"/var -type d -empty -delete || die
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if [[ -z ${REPLACED_BY_VERSION} && -e ${EROOT}/usr/$(get_libdir)/xorg/modules ]]; then
		rm -rf "${EROOT}"/usr/$(get_libdir)/xorg/modules
	fi
}
