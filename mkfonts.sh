#!/usr/bin/env bash
# generate CJK fonts for LaTeX
# usage example:
#   mkfonts.sh simsun.ttc simsun song

set -e

die()
{
    printf >&2 '%s\n' "$*"
    exit 1
}

g_usage="Usage example: mkfonts.sh simsun.ttc simsun song"

g_fullpath=$(readlink -e "$0")
g_basename=$(basename $g_fullpath)
g_dirname=$(dirname $g_fullpath)

which fontforge > /dev/null 2>&1 || die "fontforge not found"

g_texmf=${TEXMF:-$(kpsewhich -expand-var '$TEXMFHOME')}

[ $# == 3 ] || die $g_usage

g_font_file=$1
g_subfont_name=$2
g_font_name=$3

echo "Generating subfonts..."
fontforge -script subfonts.pe $g_font_file $g_subfont_name unicode.sfd \
          > /dev/null 2>&1

DATE=$(date)

echo "Creating map file used by dvips..."
MAPFILE="t1-${g_subfont_name}.map"
cat > $MAPFILE <<EOF
% This is map file for dvips/dvipdfm[x] and LaTeX CJK package.
% Created by Edward G.J. Lee <edt1023@info.sayya.org>
% $DATE
EOF

for i in *.tfm; do
    ii=${i%.tfm}
    cat >> $MAPFILE << EOF
$ii $ii < ${ii}.pfb
EOF
done

echo "Creating map file used by pdflatex/pdftex..."
ENCMAP="ttf-${g_subfont_name}.map"
cat > $ENCMAP <<EOF
% This is map file for PDFLaTeX and LaTeX CJK package to embed TTF.
% Created by Edward G.J. Lee <edt1023@info.sayya.org>
% $DATE
EOF

FNAME=$(basename $g_font_file)
for i in *.enc; do
    ii=${i%.enc}
    cat >> $ENCMAP <<EOF
$ii <$i <$FNAME
EOF
done

echo "Creating cid-map file..."
cat >> cid-x.map <<EOF
$g_subfont_name@Unicode@ unicode :0:$FNAME
EOF

echo "Creating fd file..."
cat > c70${g_font_name}.fd <<EOF
\ProvidesFile{c70${g_font_name}.fd}[\filedate\space\fileversion]
\DeclareFontFamily{C70}{$g_font_name}{\hyphenchar \font\m@ne}
\DeclareFontShape{C70}{$g_font_name}{m}{n}{<-> CJK * $g_subfont_name}{}
\DeclareFontShape{C70}{$g_font_name}{bx}{n}{<-> CJKb * $g_subfont_name}{\CJKbold}
\endinput
EOF

AFM=${g_texmf}/fonts/afm/$g_subfont_name
ENC=${g_texmf}/fonts/enc/$g_subfont_name
MAP=${g_texmf}/fonts/map
PFB=${g_texmf}/fonts/type1/$g_subfont_name
TFM=${g_texmf}/fonts/tfm/$g_subfont_name
TT=${g_texmf}/fonts/truetype/$g_subfont_name
FD=${g_texmf}/tex/latex/CJK/UTF8

for i in $AFM $ENC $MAP $PFB $TFM $TT $FD; do
    [[ -d $i ]] || mkdir -p $i
done

mv *.afm $AFM
mv *.enc $ENC
mkdir -p $MAP/{dvipdfm,dvips,pdftex}
mv $MAPFILE $MAP/dvips/
# https://www.monperrus.net/martin/using-truetype-fonts-with-texlive-pdftex-pdflatex
# find map file by:
# echo "\\bye" | pdftex story
# for pdflatex provided in texlive 2018, the map content should be appended to
# $TEXMF/fonts/map/pdftex/pdftex.map
cat $ENCMAP >> $MAP/pdftex/pdftex.map && rm $ENCMAP
cat cid-x.map >> $MAP/dvipdfm/cid-x.map && rm cid-x.map
mv *.pfb $PFB
mv *.tfm $TFM
mv c70${g_font_name}.fd  $FD
ln -f $g_font_file $TT

echo "Congradulations! You have generated font $g_font_name for LaTeX!"

cat <<EOF
run:
  updmap-user --enable Map t1-${g_subfont_name}.map
or manually add line:
  Map $MAPFILE
to:
  $TEXMFCONFIG/web2c/updmap.cfg

Do not forget to run:
  mktexlsr $TEXMF

NOTE: TEXMFCONFIG/TEXMF is the dire
EOF
