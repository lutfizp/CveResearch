# CVE Matrix

| Date | Platform | Category | CVE | Trigger | Public PoC | Status | Folder | Notes |
|---|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | Android | rce | CVE-YYYY-XXXXX | browser_application/file_handler | yes/no | pass/fail/replaced | `android/rce/CVE-YYYY-XXXXX/` | |
| 2026-11-09 | Linux | info_leak | CVE-2025-29927 | browser_page | yes | pass | `linux/info_leak/CVE-2025-29927/` | Next.js middleware bypass (`x-middleware-subrequest`) -> protected PII; 14.2.24 vuln / 14.2.25 control blocked; verified via Docker (`run.sh`) + browser screenshot |
| 2026-11-11 | Linux | rce | CVE-2026-126187 | browser_page | no | replaced | `linux/rce/CVE-2026-126187/` | Server-side React RSC Flight desync RCE. Replaced after review: the trigger is server-side and outside the updated browser-application / file-handler scope. Kept as reference in PR #10. |
| 2026-11-12 | Windows | rce | CVE-2026-85046 | browser_page | yes | pass | `windows/rce/CVE-2026-85046/` | Chrome V8 inline-sort type confusion -> browser renderer code execution; Chrome for Testing 152.0.7977.75 vuln / .82 fixed; beacon evidence; OS sandbox escape out of scope |
