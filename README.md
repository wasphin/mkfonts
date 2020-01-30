# mkfonts

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
