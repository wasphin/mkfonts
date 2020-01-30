# mkfonts

UTF-8 only, tested under fedora 30.


## Files

* ``subfonts.pe``: https://cjk.ffii.org/
* ``unicode.sfd``:

## Steps

1. ``mkdir fonts``;
1. copy sim fonts to ``fonts``;
1. run ``mksimfonts.sh`` to generate required files under ``texmf``;
1. copy the generated files to your ``$TEXMF`` directory;
1. update ls-R databases using ``mktexlsr``;
1. enable font map using ``updmap``


## References

* https://zhuanlan.zhihu.com/p/85308217
* https://www.monperrus.net/martin/using-truetype-fonts-with-texlive-pdftex-pdflatex
* http://c.caignaert.free.fr/Install-ttf-Font.pdf
* https://cjk.ffii.org/
