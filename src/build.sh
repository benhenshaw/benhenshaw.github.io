#!/bin/bash

# Build script for simple markdown based website.
# Write a head.html and foot.html, which will wrap each page generated from your
# markdown files. This process is done in two passes to properly generate a site
# index (although this might not be completely necessary -- I am too lazy to
# figure out a smarter method, or if there even is one).

rm ../*.html
echo > listing.md
files=`ls -t *.md`

for md_file in $files
do
    # Strip '.md' from the file name.
    file_base=`basename $md_file .md`

    # Get the date that the file was last modified.
    date=`stat -t "%Y-%m-%d" -f "%Sm" $md_file`

    # Get the first h1 heading on the page.
    doc_title=`grep -m 1 "^# .*" $md_file | sed s/"# "//g`

    if [[ -n "$doc_title" ]]
    then
        # Write this page to the site map.
        echo "+ [$doc_title]($file_base.html) -- $date" >> listing.md
    fi

    # Fix any empty titles.
    if [[ -z "$doc_title" ]]
    then
        doc_title="Ben's Website"
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
