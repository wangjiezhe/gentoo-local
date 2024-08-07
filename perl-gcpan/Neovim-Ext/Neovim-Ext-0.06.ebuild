# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.17.0

EAPI=8

DIST_AUTHOR="JACQUESG"
DIST_VERSION="0.06"


inherit perl-module

DESCRIPTION="Perl bindings for neovim"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-perl/IO-Async
	perl-gcpan/Eval-Safe
	dev-perl/Class-Accessor
	>=dev-perl/File-Slurper-0.14.0
	>=dev-perl/Test-Pod-Coverage-1.100.0
	>=dev-perl/Test-Pod-1.520.0
	>=dev-perl/File-Which-1.270.0
	perl-gcpan/MsgPack-Raw
	>=dev-perl/Archive-Zip-1.680.0
	>=dev-perl/Proc-Background-1.320.0
	dev-lang/perl"
RDEPEND="dev-perl/App-cpanminus"
