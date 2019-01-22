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

# Prep index for listing to be appended
cat index.md > index_tmp.md
echo "\n---\n" >> index_tmp.md

# Get all of the Markdown files in the current folder.
# files=`ls -v *.md`

# The order that these files are read dictates what order they appear in
# the site map, so for now I am just listing them manually in the order
# that they were written, newest first.
files=\
"index_tmp.md portfolio.md ma_journal.md "\
"landing_party.md soft_render_sdl2.md static_site.md"

for md_file in $files
do
    # Strip '.md' from the file name.
    file_base=`basename $md_file .md`

    # Get the post publish date from the comment at the start of the file.
    created=`cat $md_file | grep -m 1 -o "<!--.*-->" | grep -o "\d\d\d\d-\d\d-\d\d"`

    # Get the first h1 heading on the page.
    doc_title=`grep -m 1 "^# .*" $md_file | sed s/"# "//g`

    # Write this page to the site map, ignoring any that don't have a title.
    if [[ -n "$doc_title" ]]
    then
        echo "$created --- [$doc_title]($file_base.html)\n" >> index_tmp.md
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
    sed "s/{{CREATED}}/$created/g" |   \
    sed "s/{{FILE}}/$file_base/g" |    \
    sed "s/{{TITLE}}/$doc_title/g"     \
        > ../$file_base.html

    rm tmp.html
done

# rm index_tmp.md
mv ../index_tmp.html ../index.html
