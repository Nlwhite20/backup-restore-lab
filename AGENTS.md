# Backup and Restore Lab Safety Rules

This repository supports an authorized personal home-lab project only.

## Authorized Scope

- Only lab VMs I own: backup server `ubuntu-mgmt`; clients `soc-endpoint-01` and `wazuh-siem`.
- Backup data stays inside the lab and on my Mac. No cloud storage in this lab.
- Restore tests always restore to a separate path. Never overwrite live files during a test.

## Required Approval

Ask before:
- Running `sudo`, installing software, or changing firewall, service or VM settings
- Creating, pruning or deleting any backup snapshot or repository
- Any restore that writes outside a dedicated test path
- Deleting files, logs or evidence
- Committing, pushing, or sending data outside the local lab

## Secrets

- Repository passwords and rest-server credentials are generated on the VMs, stored in root-only
  files (mode 600) and in my password manager, and are never printed, pasted into chat or committed.
- Backups contain secrets (agent keys, Wazuh configuration); they exist only in encrypted form.
- Never pass passwords on a command line; use password files or hidden prompts.

## Evidence

- Raw logs stay on the VMs under `~/evidence/lab5/`, outside Git.
- No real IP addresses, usernames or credentials in published docs.
- Check VM clocks against the Mac before timed tests.
- Every change gets a row in `docs/build-log.md` the same day.
