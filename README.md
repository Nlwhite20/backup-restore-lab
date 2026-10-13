# Backup and Restore Lab (restic + rest-server)

> Status: **in progress.** Backup server running (append-only, TLS, two client accounts, firewall-restricted); both clients backed up and verified (`restic check`); restore tests next.

## Purpose

Show backups that run on a schedule, are encrypted, keep a separate copy, cannot be deleted by
a compromised client, and are proven by timed restore tests with written evidence.

## Design

| Role | Host | Notes |
| --- | --- | --- |
| Backup server | `ubuntu-mgmt` (Ubuntu 26.04) | rest-server in append-only mode, TLS, one account per client |
| Client | `soc-endpoint-01` (Ubuntu 26.04) | restic; Suricata and Wazuh agent configuration, lab evidence |
| Client | `wazuh-siem` (Ubuntu 24.04) | restic; Wazuh single-node compose and configuration folder |
| Third copy | Mac (outside the VMs) | Not off-site: same physical machine (stated limitation) |

## Documentation

- [Backup standard](docs/backup-standard.md): scope, 3-2-1, RPO/RTO, retention, encryption
- [Restore test plan](docs/restore-test-plan.md)
- [Build log](docs/build-log.md)
- [Risk register](docs/risk-register.md)

## AI Collaboration and Human Validation

Built with Claude as an assistant. Claude proposed plans, commands and drafts; I ran every
command and approved every change and commit. Rules: [CLAUDE.md](CLAUDE.md).

| What I asked for | What the AI proposed or assumed | What I checked or changed | Result |
| --- | --- | --- | --- |
| Lab 5 topic | A Windows 11 endpoint lab in UTM | Checked Microsoft's licensing page first: only Parallels is authorized on Apple silicon, and each instance needs a Windows 11 Pro licence | Chose this backup lab instead; no unlicensed install |
| Enable the packaged service | Configure and start it | Asked to inspect the shipped password file first (it was not empty) | It contained only comments: no default account |
| Copy the certificate to clients | A shell loop using `$h:evidence` | The copy failed; zsh treats `$h:e` as a modifier | Fixed with `${h}`; no change had been made |

Limitations: single-operator lab, so review is not independent.
