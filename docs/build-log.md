# Build Log

All times UTC.

| Date / time | Change or check | Purpose | Verification | Result |
| --- | --- | --- | --- | --- |
| 2026-10-13 13:05 | Clock check: `wazuh-siem`, `soc-endpoint-01` vs Mac | Timed evidence | Both within the bracketing Mac readings | Complete |
| 2026-10-13 13:13 | Read-only preflight on all three VMs | Plan the build | Clocks in sync. Free disk: `ubuntu-mgmt` 10 GB, `soc-endpoint-01` 3.1 GB (68% used), `wazuh-siem` 66 GB. Package candidates (apt lists dated 2026-10-06): restic 0.18.1 on 26.04, 0.16.4 on 24.04; rest-server 0.14.0 on 26.04 | Complete |
| 2026-10-13 | Lab 5 topic changed from a Windows endpoint to backup and restore | Licensing | Microsoft authorizes only Parallels for Windows 11 on Apple silicon; a Windows 11 Pro licence is needed per instance | Decision by lab owner |
| 2026-10-13 13:22 | Read-only baseline of `ubuntu-mgmt` (approved sudo read) | Before changes | UFW active, default deny incoming, SSH only; listening: SSH only | Complete |
| 2026-10-13 13:24 | 2a: installed `restic-rest-server 0.14.0-1`, `restic 0.18.1-3ubuntu1`, `apache2-utils 2.4.66-2ubuntu2.5` (approved sudo) | Backup server software | Service shipped disabled and not started; no-login service account created; nothing new listening | Complete |
| 2026-10-13 13:3x | Inspected the shipped password file (approved sudo read, no hashes printed) | Check for default accounts | 11 comment/blank lines, 0 accounts | Complete: no default credentials |
| 2026-10-13 13:35 | 2b: `/srv/restic` (service account, 700); TLS key (640) and self-signed certificate (EC P-256, 825 days, valid to 2029-01-15) | Storage and transport security | SHA-256 fingerprint `1D:CE:0D:06:12:A3:21:42:1B:9A:41:70:B5:DF:17:1F:A7:6E:C6:1C:3F:FE:15:AC:34:68:FD:14:DC:13:54:C7` | Complete |
| 2026-10-13 13:3x | 2c: two bcrypt accounts (`soc-endpoint-01`, `wazuh-siem`), passwords entered at hidden prompts from the owner's password manager | Per-client authentication | 2 accounts, `$2y$`; file 640 | Complete |
| 2026-10-13 13:3x | 2d: original options file backed up (`.orig-20261013`); new options installed ([config](../config/restic-rest-server.default)); service enabled and started | Append-only, private repos, TLS | Service log: htpasswd loaded, append-only enabled, private repositories enabled, TLS enabled, listening on 8000 | Complete |
| 2026-10-13 13:3x | 2e: UFW allows 8000/tcp from the two clients only | Restrict access | `ufw status` shows exactly two labelled rules; request from the Mac timed out | Complete |
| 2026-10-13 13:40 | 2f attempt 1 | Client tests | Certificate copy failed (command error); no change made | Rerun |
| 2026-10-13 13:41 | 2f: certificate copied to both clients; unauthenticated request with the pinned certificate | Prove TLS and authentication | Both clients: fingerprint matches; `http=401`; `tls_verify=0` | Complete |
| 2026-10-13 13:43 | 3a: installed restic on clients (approved sudo); measured backup sets | Client software | `soc-endpoint-01` restic 0.18.1, about 2.4 MB to back up, 3.0 GB free; `wazuh-siem` restic 0.16.4, 152 KB | Complete |
| 2026-10-13 13:45 | 3b: `/root/restic` (700) with pinned certificate, `repo.pass` (600) and `env` (600) on both clients; passwords entered at hidden prompts | Credentials | Permissions and line counts checked (a first line-count attempt failed because the file is root-only, which confirmed its protection) | Complete |
| 2026-10-13 13:47 | 3c: `restic init` on both clients | Encrypted repositories | `soc-endpoint-01` repository `1e9ff339bf`; `wazuh-siem` repository `d66fd1045e`; login masked in output | Complete |
| 2026-10-13 13:48 | 4: SHA-256 manifests, first backups, `restic check` | First backup and integrity | `soc-endpoint-01`: 68 files (manifest 68), snapshot `261d2a15`, exit 0. `wazuh-siem`: 26 files (manifest 26), snapshot `56f7f33f`, exit 0. Both: "no errors were found". restic 0.16.4 and 0.18.1 both worked against the same server | Complete |
| — | Restore tests R1-R4 | Step 5 | — | Pending approval |
