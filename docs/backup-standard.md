# Backup Standard (lab)

Draft 2026-10-13. Targets below are lab targets, set before any testing.

## Scope

| Client | Paths backed up | Not backed up (stated) |
| --- | --- | --- |
| `soc-endpoint-01` | `/etc/suricata`, `/var/ossec/etc`, the lab evidence folder | Suricata logs (`/var/log/suricata`), rules downloaded by `suricata-update` (can be re-downloaded) |
| `wazuh-siem` | The Wazuh single-node compose and configuration folder (compose file, certificates, config) | Docker volumes, including indexer data (alert history). Rebuilding the SIEM from config is in scope; recovering its stored alerts is not |

## Rules

| Rule | Standard |
| --- | --- |
| 3-2-1 | 3 copies (live, backup server, Mac), 2 storage locations, 1 copy outside the VMs. **Limitation:** all on one Mac, so not off-site |
| Encryption | All repositories encrypted by restic; passwords in root-only files and the owner's password manager |
| Immutability | rest-server append-only mode: clients can add backups but not delete or modify them |
| Transport | TLS to the backup server; one account per client |
| Schedule | Daily per client (systemd timer) |
| Retention | Keep 7 daily and 4 weekly snapshots; applied on the server side only |
| Integrity | `restic check` after the first backup and weekly; `--read-data` subset monthly |
| Restore testing | Before declaring the standard met, and monthly after (see restore test plan) |

## Targets

| Measure | Target |
| --- | --- |
| RPO (maximum data loss) | 24 hours |
| RTO (single config folder, to a test path) | 30 minutes from start of restore to verified files |
| Missed backup detection | Alert if a client has not completed a backup in 26 hours |
