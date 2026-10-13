#!/bin/bash
# Restore test: restores <include-path> from the latest snapshot into a NEW root-only test
# folder (never over live files), times it, and compares SHA-256 hashes with the manifest
# taken at backup time. Prints paths only, never file contents or hashes.
# Usage: sudo bash restore-test.sh <manifest-file> <include-path> <label>
set -euo pipefail
M="$1"; INC="$2"; L="$3"
set -a; . /root/restic/env; set +a
TS=$(date -u +%Y%m%dT%H%M%SZ)
T="/root/restore-test/$L-$TS"
install -d -m 700 /root/restore-test
install -d -m 700 "$T"
echo "test: $L  include: $INC  target: $T"
echo "start: $(date -u +%T.%3N)"
S=$(date +%s.%N)
restic restore latest --target "$T" --include "$INC" 2>&1 | sed -E 's#//[^@/]*@#//***@#g' | tail -2
E=$(date +%s.%N)
echo "end:   $(date -u +%T.%3N)  elapsed_s: $(awk "BEGIN{printf \"%.2f\", $E-$S}")"
# exact file, or files inside the folder; not paths that merely share a prefix
awk -v p="$INC" '{f=substr($0,67)} f==p || index(f, p"/")==1' "$M" | sort -k2 > "$T.expected"
(cd "$T" && find . -type f -print0 | xargs -0 -r sha256sum | sed -E 's#  \./#  /#' | sort -k2) > "$T.restored"
echo "expected files: $(wc -l < "$T.expected")  restored files: $(wc -l < "$T.restored")"
if [ -s "$T.expected" ] && diff -q "$T.expected" "$T.restored" >/dev/null; then
  echo "RESULT: PASS (every restored file hash matches the backup-time manifest)"
else
  echo "RESULT: FAIL (differences by path below)"
  diff "$T.expected" "$T.restored" | awk '/^[<>]/{print $1, $3}' | head -20
fi
