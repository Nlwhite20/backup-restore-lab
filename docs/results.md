# Results (2026-10-13)

All times UTC; VM clocks were checked against the Mac before testing. Evidence details are in
the [build log](build-log.md).

## Restore tests

| Test | What was tested | Result | Evidence |
| --- | --- | --- | --- |
| R1 | Single file restore | **FAIL (test-script defect)** | Script's prefix match expected an extra `.orig` file; the restored file itself matched |
| R1b | Single file restore, fixed script | **PASS** | 1 file, hash matches manifest, 0.74 s |
| R2 | Folder restore (`/var/ossec/etc`), timed | **PASS** | 31 of 31 files match the backup-time manifest; 0.73 s against a 30 min RTO |
| R3 | Point-in-time restore (canary) | **PASS** | Older snapshot restored version 1, not current version 2 |
| R4 | Delete a snapshot from a client (append-only) | **PASS** | Server returned 403; snapshot still present. restic still exited 0 (R-09) |
| R5 | Missed-backup detection | **PASS (detection only)** | 60 s test threshold flagged both repositories as stale; 26 h check reported OK. No notification (R-10) |

## Backup standard: met or not

| Requirement | Status |
| --- | --- |
| Encrypted repositories | Met (restic) |
| Append-only, TLS, one account per client, firewall to clients only | Met; verified (403 on delete, 401 without password, Mac blocked) |
| Daily schedule with catch-up after downtime | Configured (systemd timers, `Persistent=true`); first scheduled runs due 2026-10-14 |
| RPO 24 h | Configured by the daily schedule; not yet demonstrated over a full day |
| RTO 30 min (config folder) | Met in test R2 (0.73 s) |
| Missed-backup detection at 26 h | Detection met; notification not met (R-10) |
| 3-2-1 | Three copies, verified; **not off-site** (R-02) |
| Retention 7 daily / 4 weekly | **Not yet applied** (server-side pruning is a follow-up) |
| Integrity checks | `restic check` after first backups: no errors. Weekly/monthly schedule not yet automated |

## Not covered

Full-VM or bare-metal restore; SIEM alert history (Docker volumes); a real off-site or cloud
copy; restores using the password-manager copy of the repository password (R-01 test).
