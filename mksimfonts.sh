#!/usr/bin/env bash
# generate CJK fonts for LaTeX

set -ex

g_fullname=$(readlink -e "$0")
g_basename=$(basename $g_fullname)
g_dirname=$(dirname   $g_fullname)

# 字体查找目录
g_fontsdir="$g_dirname/fonts"

MKFONTS="$g_dirname/mkfonts.sh"

# temporary texmf dir
export TEXMF="$g_dirname/texmf"

declare -A g_fontsinfo=(
    # 仿宋
    ["fang"]="simfang"
    # 黑体
    ["hei"]="simhei"
    # 楷体
    ["kai"]="simkai"
    # 隶书
    ["li"]="simli"
    # 宋体
    ["song"]="simsun"
    #["songb"]="simsunb"
    # 幼圆
    ["you"]="simyou"
    # 魏碑
    #["wbei"]="fzhwb"
)

for n in ${!g_fontsinfo[@]}; do
    fn=${g_fontsinfo[$n]}
    # use only the first font that matches the name
    ff=$(find $g_fontsdir -name "${fn}.*" | head -1)

    $MKFONTS $ff $fn $n
done
