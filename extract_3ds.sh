#!/usr/bin/env bash
set -ex

3dstool -xvt01267f cci part0.bin part1.bin part2.bin part6.bin part7.bin "$1" --header HeaderNCSD.bin
[ -f part0.bin ] && 
  3dstool \
  -xvtf cxi part0.bin \
  --header HeaderNCCH0.bin \
  --exh DecryptedExHeader.bin --exh-auto-key \
  --exefs DecryptedExeFS.bin --exefs-auto-key --exefs-top-auto-key \
  --romfs DecryptedRomFS.bin --romfs-auto-key \
  --logo LogoLZ.bin --plain PlainRGN.bin && 
  rm -v part0.bin
[ -f part1.bin ] && 3dstool -xvtf cfa part1.bin --header HeaderNCCH1.bin --romfs DecryptedManual.bin --romfs-auto-key && rm -v part1.bin
[ -f part2.bin ] && 3dstool -xvtf cfa part2.bin --header HeaderNCCH2.bin --romfs DecryptedDownloadPlay.bin --romfs-auto-key && rm -v part2.bin
[ -f part6.bin ] && 3dstool -xvtf cfa part6.bin --header HeaderNCCH6.bin --romfs DecryptedN3DSUpdate.bin --romfs-auto-key && rm -v part6.bin
[ -f part7.bin ] && 3dstool -xvtf cfa part7.bin --header HeaderNCCH7.bin --romfs DecryptedO3DSUpdate.bin --romfs-auto-key && rm -v part7.bin

chkset() {
  b=$1; [ -f "$b" ] || return 1
}

chkset DecryptedExeFS.bin && 3dstool -xvtfu exefs "$b" --exefs-dir ExtractedExeFS --header HeaderExeFS.bin
chkset DecryptedRomFS.bin && 3dstool -xvtf romfs "$b" --romfs-dir ExtractedRomFS
chkset DecryptedManual.bin && 3dstool -xvtf romfs "$b" --romfs-dir ExtractedManual
chkset DecryptedDownloadPlay.bin && 3dstool -xvtf romfs "$b" --romfs-dir ExtractedDownloadPlay
chkset DecryptedN3DSUpdate.bin && 3dstool -xvtf romfs "$b" --romfs-dir ExtractedN3DSUpdate
chkset DecryptedO3DSUpdate.bin && 3dstool -xvtf romfs "$b" --romfs-dir ExtractedO3DSUpdate

pushd ExtractedExeFS
[ -f banner.bnr ] && mv -v banner.bnr ../banner.bin
[ -f icon.icn ] && mv -v icon.icn ../icon.bin
[ -f banner.bin ] && cp -vf banner.bin ../banner.bin
popd

if [ -f banner.bin ]; then
  3dstool -xv -t banner -f banner.bin --banner-dir ExtractedBanner/
  rm -v banner.bin
  mv -v ExtractedBanner/banner0.bcmdl banner.cgfx
fi

