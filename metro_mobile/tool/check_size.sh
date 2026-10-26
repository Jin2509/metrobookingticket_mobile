#!/usr/bin/env bash
# Mục 4.3: cảnh báo file widget > 150 dòng, file screen > 100 dòng
# trong lib/design_system, lib/app và lib/features/*/presentation.
set -u
status=0
while IFS= read -r f; do
  lines=$(wc -l < "$f" | tr -d ' ')
  limit=150
  [[ "$f" == */screens/* ]] && limit=100
  if (( lines > limit )); then
    echo "⚠  $f: $lines dòng (giới hạn $limit)"
    status=1
  fi
done < <(find lib/design_system lib/app lib/features -name '*.dart' \
  ! -name '*.g.dart' ! -name '*.freezed.dart' 2>/dev/null \
  | grep -E '^lib/(design_system|app)/|/presentation/')
(( status == 0 )) && echo "✓ Không có file vượt ngưỡng"
exit $status
