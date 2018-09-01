#!/bin/bash
CFGDIR=$TOPDIR"/tools/cfg"
source $TOPDIR/bin/"activate"

rm -rf $BUILDDIR/*
mkdir -p $BUILDDIR/output
source $UTILDIR/parameters.sh

echo $BUILDDIR/raw_recipe.sh

$UTILDIR/recipe_aide.py -r "$@" -o $BUILDDIR/raw_recipe.sh
if [ $? -ne 0 ]; then
    echo "failed processing recipe"
fi

# run recipe
source $BUILDDIR/raw_recipe.sh

if [ "$RECIPE_EXPAND_TEMPLATE" == "yes" ]; then
    cp -R $RECIPE_TEMPLATE/* $BUILDDIR/
    for MUSTACHE_FILE in `find $BUILDDIR -type f | grep ".mustache$"`
    do
        $UTILDIR/filler.py -t $MUSTACHE_FILE -p $PARAM_FILE
        rm $MUSTACHE_FILE
    done
fi

# run the recipe command
$RECIPE_CMD

mkdir -p $BUILDDIRLATEST
cp -R $BUILDDIR/* $BUILDDIRLATEST/
deactivate