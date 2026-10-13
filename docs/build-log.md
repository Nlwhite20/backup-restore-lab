# Build Log

All times UTC.

| Date / time | Change or check | Purpose | Verification | Result |
| --- | --- | --- | --- | --- |
| 2026-10-13 13:05 | Clock check: `wazuh-siem`, `soc-endpoint-01` vs Mac | Timed evidence | Both within the bracketing Mac readings | Complete |
| 2026-10-13 13:13 | Read-only preflight on all three VMs | Plan the build | Clocks in sync. Free disk: `ubuntu-mgmt` 10 GB, `soc-endpoint-01` 3.1 GB (68% used), `wazuh-siem` 66 GB. Package candidates (apt lists dated 2026-10-06): restic 0.18.1 on 26.04, 0.16.4 on 24.04; rest-server 0.14.0 on 26.04 | Complete |
| 2026-10-13 | Lab 5 topic changed from a Windows endpoint to backup and restore | Licensing | Microsoft authorizes only Parallels for Windows 11 on Apple silicon; a Windows 11 Pro licence is needed per instance | Decision by lab owner |
| — | Install rest-server on `ubuntu-mgmt` | Backup server | — | Pending approval |
