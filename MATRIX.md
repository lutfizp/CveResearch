# CVE Matrix

| Date | Platform | Category | CVE | Trigger | Public PoC | Status | Folder | Notes |
|---|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | Android | rce | CVE-YYYY-XXXXX | browser_application/file_handler | yes/no | pass/fail/replaced | `android/rce/CVE-YYYY-XXXXX/` | |
| 2026-11-09 | Linux | info_leak | CVE-2025-29927 | browser_page | yes | pass | `linux/info_leak/CVE-2025-29927/` | Next.js middleware bypass (`x-middleware-subrequest`) -> protected PII; 14.2.24 vuln / 14.2.25 control blocked; verified via Docker (`run.sh`) + browser screenshot |
