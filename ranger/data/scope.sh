#!/bin/bash

# This script is called whenever you preview a file.
# Its output is used as the preview.  ANSI color codes are supported.

# Meaning of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | display stdout as preview
# 1    | no preview | display no preview at all


mimetype=$(file --mime-type -Lb "$1")
extension=$(echo "$1" | grep '\.' | grep -o '[^.]\+$')

case "$extension" in
	# Archive extensions:
	tar|gz|tgz|bz|tbz|bz2|tbz2|Z|tZ|lzo|tzo|lz|tlz|xz|txz|7z|t7z|\
	zip|jar|war|rar|lha|lzh|alz|ace|a|arj|arc|rpm|cab|lzma|rz|cpio)
		atool -l "$1" || exit 1
		exit 0;;
	# HTML Pages:
	htm|html|xhtml)
		lynx -dump "$1" || elinks -dump "$1" || exit 1
		exit 0;;
esac

case "$mimetype" in
	# Syntax highlight for text files:
	text/* | */xml)
		highlight --ansi "$1" || cat "$1" || exit 1
		exit 0;;
	# Ascii-previews of images:
	image/*)
		img2txt "$1" || exit 1
		exit 0;;
esac

exit 1
