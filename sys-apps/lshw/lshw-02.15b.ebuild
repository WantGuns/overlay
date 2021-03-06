# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lshw/lshw-02.15b.ebuild,v 1.11 2011/03/25 09:59:52 xarthisius Exp $

EAPI=3
inherit flag-o-matic eutils toolchain-funcs

MAJ_PV=${PV:0:${#PV}-1}
MIN_PVE=${PV:0-1}
MIN_PV=${MIN_PVE/b/B}

MY_P="$PN-$MIN_PV.$MAJ_PV"
DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLiSter"
SRC_URI="http://ezix.org/software/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-linux"
IUSE="gtk sqlite static"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	gtk? ( dev-util/pkgconfig )
	sqlite? ( dev-util/pkgconfig )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	tc-export CC CXX AR
	use static && append-ldflags -static

	local sqlite=0
	use sqlite && sqlite=1

	emake PREFIX=$EPREFIX SQLITE=$sqlite || die "emake failed"
	if use gtk ; then
		emake gui || die "emake gui failed"
	fi
}

src_install() {
	emake DESTDIR="${ED}" install || die "install failed"
	dodoc README docs/*
	if use gtk ; then
		emake DESTDIR="${ED}" install-gui || die "install gui failed"
		make_desktop_entry /usr/sbin/gtk-lshw "Hardware Lister" "/usr/share/lshw/artwork/logo.svg"
	fi
}
