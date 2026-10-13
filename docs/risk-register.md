# Risk Register

Status as of 2026-10-13.

| ID | Risk | Likelihood | Impact | Status | Treatment |
| --- | --- | --- | --- | --- | --- |
| R-01 | Repository password lost, making every backup unrecoverable | Low | High | Open | Store each password in the owner's password manager as well as on the client; verify by a restore that uses the stored copy |
| R-02 | Third copy is on the same Mac, so a Mac loss destroys all copies | Certain | High | Accepted for lab | Stated limitation; a real off-site copy is out of scope |
| R-03 | Append-only protects against a compromised client, not a compromised backup server | Medium | High | Open | Limit access to `ubuntu-mgmt`; document; Mac copy as a second location |
| R-04 | SIEM alert history (Docker volumes) is not backed up | Certain | Medium | Accepted for lab | Config-only scope stated in the backup standard |
| R-05 | Ubuntu restic versions (0.16.4, 0.18.1) are older than upstream 0.19.x and differ between clients | Certain | Low | Open (compatibility confirmed) | First backups and checks succeeded on both versions (2026-10-13); re-check after upgrades |
| R-06 | `soc-endpoint-01` has 3.0 GB free; restic cache and logs could fill it | Low | Medium | Open | Backup set measured at about 2.4 MB; watch free space at each review |
| R-07 | Self-signed TLS certificate on the backup server could be trusted incorrectly | Low | Medium | Open | Pin the server certificate on each client with `--cacert` |
| R-08 | VM clock drift affects schedules and evidence timestamps | Medium | Medium | Open | Clock check before timed tests (lesson from earlier labs) |
| R-09 | restic exits 0 when the server refuses a delete (observed with 0.18.1 in R4), so automation that trusts exit codes would miss it | Certain | Low | Open | Check command output, not only exit codes, in scripts and monitoring |
| R-10 | Missed-backup alerts are logged on the backup server but nobody is notified | Certain | Medium | Open | Forward `restic-freshness` errors to Wazuh, Discord or Uptime Kuma in a later step |
