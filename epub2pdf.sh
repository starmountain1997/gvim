#!/bin/bash
# EPUB → PDF, 80×127mm, 方正报宋简体
# Usage: ./epub2pdf.sh <input.epub> [output.pdf]

set -e

IN="${1:?Usage: $0 <input.epub> [output.pdf]}"
OUT="${2:-${IN%.epub}.pdf}"

CSS=$(mktemp /tmp/epub2pdf.XXXXXX.css)
trap "rm -f $CSS" EXIT

cat > "$CSS" << 'EOF'
@page {
  size: 80mm 127mm;
  margin: 3mm 3mm 2.5mm 3mm;
}
@page:left {
  margin-right: 5mm;  /* binding side */
  @bottom-left { content: counter(page); font-size: 6pt; font-family: "方正报宋简体", "FZBaoSong-Z04S", serif; padding: 0 0 1.5mm 0; margin-left: -1mm; }
}
@page:right {
  margin-left: 5mm;  /* binding side */
  @bottom-right { content: counter(page); font-size: 6pt; font-family: "方正报宋简体", "FZBaoSong-Z04S", serif; padding: 0 0 1.5mm 0; margin-right: -1mm; }
}
body { font-family: "方正报宋简体", "FZBaoSong-Z04S", serif; font-size: 8pt; line-height: 1.4; }
img, svg, image { max-width: 100%; height: auto; display: block; margin: 1mm auto; }
h1.chapter-one { page-break-before: always; }
EOF

pandoc "$IN" -o "$OUT" --pdf-engine=weasyprint --css="$CSS" -M title="" 2>&1 | grep -v "^ERROR: No anchor" || true

echo "→ $OUT ($(du -h "$OUT" | cut -f1))"
