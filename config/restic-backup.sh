#!/bin/bash
# Scheduled client backup. Reads the server/credential settings from /root/restic/env
# (root-only) and the host's paths from /root/restic/backup.conf. Login details are masked
# in output. Exit status is restic's own (see R-09: also check output, not only exit codes).
set -uo pipefail
set -a; . /root/restic/env; . /root/restic/backup.conf; set +a
echo "backup start $(date -u +%FT%TZ) host=$(hostname)"
# BACKUP_PATHS and EXCLUDE_ARGS are intentionally word-split
restic backup --tag lab5 --tag scheduled $EXCLUDE_ARGS $BACKUP_PATHS 2>&1 | sed -E 's#//[^@/]*@#//***@#g'
RC=${PIPESTATUS[0]}
echo "backup end $(date -u +%FT%TZ) exit=$RC"
exit $RC
