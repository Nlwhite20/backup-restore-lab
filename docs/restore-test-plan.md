# Restore Test Plan

All restores go to a separate test path; live files are never overwritten.

| Test | Method | Pass criteria |
| --- | --- | --- |
| R1 Single file | Restore one named file from the latest snapshot | SHA-256 of restored file equals the source at backup time |
| R2 Config folder | Restore a full config folder, timed | All file hashes match the backup-time manifest; time within RTO |
| R3 Point in time | Restore from an older snapshot after a known change | Restored content matches the older version, not the current one |
| R4 Append-only | Attempt `restic forget` of a snapshot from a client | Server refuses; snapshot still listed |
| R5 Missed backup | Stop one scheduled run | Missed-backup alert fires within the threshold |

Evidence: commands, timestamps (clocks checked against the Mac), hash manifests and results,
recorded in the build log and a results document.
