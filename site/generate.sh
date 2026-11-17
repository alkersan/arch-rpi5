#!/usr/bin/env bash
set -euo pipefail

images=$(
    aws s3 ls "s3://${S3_BUCKET}/images/" |
      awk '$4 ~ /^arch-rpi5-[0-9]{4}-[0-9]{2}-[0-9]{2}\.img\.xz$/ {print $4}' |
      sort -r
)

downloads=$(
    while IFS= read -r image; do
        [[ -z "$image" ]] && continue
        sha="${image%.img.xz}.SHA256SUMS"
        printf '      <li><a href="images/%s">%s</a> (<a href="images/%s" download>sha256</a>)</li>\n' "$image" "$image" "$sha"
    done <<< "$images"
)

awk -v downloads="$downloads" '/<!-- DOWNLOADS -->/ { print downloads; next } { print }' site/index.html | aws s3 cp - "s3://${S3_BUCKET}/index.html"
