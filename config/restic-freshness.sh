#!/bin/bash
# Missed-backup check on the backup server. Reads only file timestamps in each repository's
# snapshots folder (no repository passwords needed). Logs an error if the newest snapshot is
# older than the threshold. Usage: restic-freshness.sh [threshold_seconds] (default 26 h).
set -uo pipefail
LIMIT=${1:-93600}
NOW=$(date +%s); STALE=0
for R in /srv/restic/*/; do
  N=$(basename "$R")
  NEWEST=$(find "$R/snapshots" -type f -printf '%T@\n' 2>/dev/null | sort -n | tail -1 | cut -d. -f1)
  if [ -z "$NEWEST" ]; then
    logger -p user.err -t restic-freshness "STALE repo=$N no snapshots found"; STALE=1; continue
  fi
  AGE=$((NOW - NEWEST))
  if [ "$AGE" -gt "$LIMIT" ]; then
    logger -p user.err -t restic-freshness "STALE repo=$N newest_snapshot_age_s=$AGE limit_s=$LIMIT"; STALE=1
  else
    logger -p user.info -t restic-freshness "OK repo=$N newest_snapshot_age_s=$AGE limit_s=$LIMIT"
  fi
done
exit $STALE
