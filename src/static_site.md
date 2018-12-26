# Build Your Own Static Site Generator
This website is built using a simple [shell script](src/build.sh), and I will show you how to construct a similar static site generator using some UNIX utilities and a Markdown parser. It will perform the following:

1. Parse Markdown, and generate basic HTML.
2. Format HTML into a web page.
3. Perform macro substitutions.

## Markdown
Each page of this website is initially authored in [Markdown](https://en.wikipedia.org/wiki/Markdown) --- a simple mark-up language. This marked text needs to be converted to HTML, for which there are many utilities. Here are a few that I have used[^1], in ascending order of feature count.

+ **[cmark](https://github.com/commonmark/cmark)** --- The reference implementation of [CommonMark](http://commonmark.org/), a more rigorously standardised version of Markdown. This implementation performs well and is very simple to use. It has only a handful of options, but includes `--smart` for some very useful punctuation conversion.
+ **[Hoedown](https://github.com/hoedown/hoedown)** --- This is the fastest of the bunch. Hoedown has support for several useful extensions, including tables, footnotes, and some additional style mark-up (such as underlining).
+ **[Pandoc](https://pandoc.org/)** --- The most feature-full option. It's a little slower than the others. I use Pandoc as it provides all of the features I want from the others, but also marks up code snippets for syntax highlighting via CSS.

Another useful feature to look out for is automatically converting symbols to HTML special characters (e.g. `&amp;` for &). One could also go with another mark-up language entirely, such as [reStructuredText](http://docutils.sourceforge.net/rst.html) or [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki)'s mark-up language. It's easy to get lost in option paralysis at this point, so just go for Pandoc as it has clear [installation instructions](https://pandoc.org/installing.html) on its website.

## Building a Page
Once you have a way to get your content into basic HTML, it's time to move on to generating a more complete web page. One of the simplest ways to do this by writing a page template which will wrap around your content. If you split this template into two files[^2] --- the first containing everything that comes before the content, and the second for everything after, you can use file concatenation to produce the final page with a utility such as `cat` on UNIX-style systems, or `copy` on Windows[^3].

```sh
cat head.html body.html tail.html > page.html
```

**head.html**
```HTML
<!DOCTYPE html>
<html>
<head>
    <title>My Page</title>
</head>
<body>
```

**body.html**
```HTML
<p>This is the content generated from my Markdown file.</p>
```

**tail.html**
```HTML
</body>
</html>
```

This is a basic example, but one can create more complex pages using this technique. See [the source](https://github.com/benhenshaw/benhenshaw.github.io/tree/master/src) for this website for some hints.

## Inserting Macros
Now that we have a our content in the web page, we might want to make some smaller insertions such as setting the title of the page. This can be done using find-and-replace style substitution --- also known as macros. The `sed` utility makes this relatively straightforward; just be sure to choose a keyword to substitute that isn't going to appear in the actual content and could get replaced erroneously. I've wrapped my macros in curly brackets (`{` and `}`) to make sure that they are very unique.

One very useful thing you might want to do is get the heading of the document. Here's how to extract the first `h1` heading from a Markdown file, and store it in a variable.

```sh
title=`grep -m 1 "^# .*" $md_file_name | sed s/"# "//g`
```

Now that we have the title, we can insert it into the page using `sed`.

```sh
sed "s/{TITLE}/$title/g"
```

This website also displays the date that the page was last edited in its footer. Here is how to get that information and store it in another variable.

```sh
date=`stat -t "%Y-%m-%d" -f "%Sm" $md_file_name`
```

## Conclusion
Please do check out the [build script](src/build.sh) that built this page, as it is commented and should help to explain anything I glossed over here. In my case, building this tiny site generator was simpler that grappling with constructing a custom template in [Jekyll](https://jekyllrb.com/) or [Hugo](https://gohugo.io/), as I only wanted a small handful of features.



[^1]: There are *many* other markdown converters out there. I care about simplicity and performance, so my ideal tool is just a single binary --- not a `.js` library or anything the requires the use of a package manager.

[^2]: One could also write a single template file and insert the content code directly into a copy of that template, but I do not know of a command line utility as ubiquitous as `cat` that performs this action --- the portability is an acceptable trade-off for me.

[^3]: In general, the tools available out-of-the-box on Windows are pretty lacklustre, and you might be better off installing a package like [Cygwin](https://www.cygwin.com/), [GNUWin](http://gnuwin32.sourceforge.net/), or Microsoft's own [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about).
