#!/bin/bash
# R3 (point-in-time restore) and R4 (append-only refusal), using a throwaway canary folder
# so that no real backup is at risk if append-only were not enforced.
# Usage: sudo bash canary-test.sh
set -uo pipefail
set -a; . /root/restic/env; set +a
mask() { sed -E 's#//[^@/]*@#//***@#g'; }
C=/root/lab5-canary; F=$C/canary.txt
install -d -m 700 $C
echo "canary version 1 $(date -u +%FT%TZ)" > $F; H1=$(sha256sum $F | cut -c1-64)
A=$(restic backup --tag canary $C --json 2>/dev/null | grep '"message_type":"summary"' | sed -E 's/.*"snapshot_id":"([0-9a-f]{8}).*/\1/')
echo "snapshot A (version 1): $A"
sleep 1
echo "canary version 2 $(date -u +%FT%TZ)" > $F; H2=$(sha256sum $F | cut -c1-64)
B=$(restic backup --tag canary $C --json 2>/dev/null | grep '"message_type":"summary"' | sed -E 's/.*"snapshot_id":"([0-9a-f]{8}).*/\1/')
echo "snapshot B (version 2): $B"
echo "===== R3 point-in-time: restore snapshot A"
T=/root/restore-test/R3-$(date -u +%Y%m%dT%H%M%SZ); install -d -m 700 /root/restore-test $T
restic restore "$A" --target $T 2>&1 | mask | tail -1
R=$(sha256sum $T$F | cut -c1-64)
if [ "$R" = "$H1" ] && [ "$R" != "$H2" ]; then echo "RESULT R3: PASS (restored version 1, not current version 2)"; else echo "RESULT R3: FAIL"; fi
echo "===== R4 append-only: try to forget snapshot A from this client"
restic forget "$A" > /tmp/r4-forget.out 2>&1; RC=$?; mask < /tmp/r4-forget.out | tail -4; rm -f /tmp/r4-forget.out
echo "forget exit=$RC (non-zero expected)"
echo "--- canary snapshots still listed:"
restic snapshots --tag canary 2>&1 | mask | grep -E "^[0-9a-f]{8}" | awk '{print $1, $2, $3}'
if restic snapshots --tag canary --json 2>/dev/null | grep -q "\"short_id\":\"$A\""; then echo "RESULT R4: PASS (snapshot A still present)"; else echo "RESULT R4: FAIL (snapshot A is gone)"; fi
