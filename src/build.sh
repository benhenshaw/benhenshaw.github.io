#!/bin/bash

# Build script for simple markdown based website.
# Write a head.html and foot.html, which will wrap each page generated from your
# markdown files. This process is done in two passes to properly generate a site
# index (although this might not be completely necessary -- I am too lazy to
# figure out a smarter method, or to figure out if there even is one).
# -- Benedict Henshaw, 2018

rm ../*.html

# Create an empty file for the listing page.
echo > listing.md

# Get all of the Markdown files in the current folder.
files=`ls -t *.md`

for md_file in $files
do
    # Strip '.md' from the file name.
    file_base=`basename $md_file .md`

    # Get the date that the file was last modified.
    date=`stat -t "%Y-%m-%d" -f "%Sm" $md_file`

    # Get the first h1 heading on the page.
    doc_title=`grep -m 1 "^# .*" $md_file | sed s/"# "//g`

    # Write this page to the site map, ignoring any that don't have a title.
    if [[ -n "$doc_title" ]]
    then
        echo "+ [$doc_title]($file_base.html) -- $date" >> listing.md
    fi
done

for md_file in $files
do
    # Strip '.md' from the file name.
    file_base=`basename $md_file .md`

    # Get the date that the file was last modified.
    date=`stat -t "%Y-%m-%d" -f "%Sm" $md_file`

    # Get the first h1 heading on the page.
    doc_title=`grep -m 1 "^# .*" $md_file | sed s/"# "//g`

    # Fix any empty titles.
    if [[ -z "$doc_title" ]]
    then
        doc_title="Ben's Website"
    fi

    # Generate html body.
    pandoc $md_file > tmp.html

    # Insert variables.
    cat head.html tmp.html foot.html | \
    sed "s/{{DATE}}/$date/g" |         \
    sed "s/{{FILE}}/$file_base/g" |    \
    sed "s/{{TITLE}}/$doc_title/g"     \
        > ../$file_base.html

    rm tmp.html
done
