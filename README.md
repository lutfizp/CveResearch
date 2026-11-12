# CVE Research Assignment — Security Research Intern

## 1. Assignment summary

Collect CVEs from **2025–2026** that satisfy all of the following:

1. They have a **reproducible PoC** in a lab.
2. They can be exploited into one of:
   - **RCE** (remote code execution),
   - **reverse shell**, or
   - **information leak containing PII**.
3. They can be triggered through one of these **client-side** paths, and the trigger itself must reach one of the outcomes in item 2:
   - **Browser application**: the CVE is in the browser itself (Chrome/Chromium, Firefox, Safari/WebKit, Edge, etc.) on Linux, Windows, Android, macOS, or iOS. The PoC is an HTML/JS/WASM page opened in the pinned vulnerable browser; the page triggers the browser bug and produces the outcome. Technical name: **client-side browser exploit** / **browser engine exploit** (e.g., JavaScript engine, DOM, WebGL, WebAssembly, renderer, sandbox escape).
   - **File handler abuse**: the CVE is in an application that opens files. The PoC is a malicious file (PDF, DOCX/XLSX, archive, media, image, etc.) opened by the pinned vulnerable application with minimal interaction; the file triggers the application and produces the outcome. Technical name: **file handler abuse** / **client-side file parser exploit**.

   A server-side web application CVE that is merely reached through a browser or HTTP request (auth bypass, XSS, SSRF, middleware bypass, server-side RCE) does **not** fit these paths.
4. They are **exploit-ready**: not theory, not crash-only, and not a placeholder.

Final goal: one command to verify the target is vulnerable, one command to execute the exploit, auditable evidence, and a write-up that another engineer can reproduce.

---

## 2. Lab and rules

- All work is **lab-local**: Docker/VM/kind/LocalStack. No public targets, no third parties, no real networks.
- Pin the vulnerable version (container image/commit/tag). Do not use “latest” without proof that it is vulnerable.
- Use **synthetic PII** only. Do not use real personal data.
- No persistence, worming, lateral movement, or exfiltration of real data.
- Do not publish exploits or PoCs to the internet. This is an internal lab assignment.
- Follow `AGENTS.md`; respect `STOP` / `ABORT` / `CLEANUP`.
- Keep evidence to the minimum needed; clean up containers/VMs after the demo.
- If you are unsure about scope, stop and ask your mentor.

---

## 3. Daily cadence: one CVE per day

- Deliver **one verified CVE per working day**. A two-CVE chain counts as that day's single deliverable.
- The day's folder is `android/<category>/<CVE>/` (or `<platform>/<category>/<CVE>/` for other platforms).
- The day's log is `daily/YYYY-MM-DD.md`; add the CVE row to `MATRIX.md`.
- If a CVE is blocked, record the blocker, replace it, and still submit one entry for the day.
- Do not batch multiple CVEs into one day and do not leave a working day without a daily note.
- The daily note must link the CVE folder and its evidence. The mentor reviews the daily entry, not just the final folder.
- An unverified or “almost working” CVE does not count as the day's deliverable.

Daily note template (`daily/_TEMPLATE.md`):

```markdown
# Daily Log — YYYY-MM-DD

- CVE:
- Platform: Android
- Category: rce | reverse_shell | info_leak
- Trigger: browser_application | file_handler
- Trigger detail: browser application + browser version/OS, or file + application/version
- Outcome:
- Folder: android/<category>/<CVE>/
- Public PoC: yes | no
- Status: pass | blocked | replaced
- Evidence:
- Blockers:
- Next:
```

---

## 4. CVE criteria

- Valid CVE in the range **1 January 2025 – 31 December 2026**.
- Verify from at least two sources: NVD/vendor advisory/patch commit/security write-up.
- Include:
  - CVE ID,
  - vulnerable and patched versions,
  - root cause,
  - patch/commit/diff if available,
  - trigger path (browser application or file handler),
  - real impact.
- The CVE must be demonstrable in the lab with the version you pinned.
- The lab must run the real vulnerable product at the pinned version. A mock server that imitates the product is not a reproduction.
- CVEs outside 2025–2026 are **rejected**.
- Do not invent CVEs. If a CVE cannot be publicly verified, choose another one.

### If no public PoC exists

If the CVE is valid but there is no public PoC:

- reproduce it from advisories, patches, commit diffs, vendor documentation, or internet research;
- build your own PoC in the lab;
- document assumptions and reproduction steps;
- if, after research, the CVE cannot be verified or reproduced, replace it and record that in `MATRIX.md`.

Do not submit a fake PoC, an “almost working” exploit, or a theoretical write-up.

---

## 5. Accepted outcomes

### 5.1 RCE

- Execution must happen on the **vulnerable target**, not on the controller machine.
- The command must be **customizable** through a parameter such as `--cmd`, `?cmd=`, or a PoC field, and must fit the affected OS: `/bin/sh` on Linux/macOS/Android, `cmd.exe` or PowerShell on Windows, and the equivalent shell on iOS where applicable.
- Minimum demonstration:
  - `id` on Unix-like systems, or `whoami`/`ver` on Windows,
  - a custom command with a unique marker, e.g. `echo CVE_MARKER_OK`,
  - command output visible in evidence.
- **Rejected** if the PoC only runs `calc`, a hardcoded `whoami`, or a command that cannot be changed.
- Explain the execution context: user, sandbox, architecture, and limitations.

### 5.2 Reverse shell

- The callback must go to a listener you control in the lab; host and port must be configurable.
- The shell must be interactive, not a single command.
- Demonstration:
  - the listener receives the connection,
  - `id` and one custom command run from the shell,
  - the connection is closed and cleaned up.
- Do not use public IPs or third-party listeners.
- Explain reliability and fallback behavior when the shell is unstable.

### 5.3 Information leak (PII)

- The leak must contain **meaningful synthetic PII**, for example:
  - name,
  - email,
  - phone number,
  - address,
  - session token,
  - account/profile data.
- **Rejected** if the leak only exposes:
  - memory addresses/ASLR,
  - software versions,
  - error stacks without sensitive data,
  - data unrelated to users or accounts.
- Explain:
  - what data leaked,
  - where it came from,
  - who is affected,
  - the real impact (privacy, account takeover, identity exposure),
  - why the data matters.
- Prove it with visible PII fields in evidence; use synthetic data.

---

## 6. Trigger: browser application or file handler

The trigger is the mechanism that reaches the chosen outcome. A Python driver, a checker, or a raw HTTP request is **not** an accepted trigger by itself. The trigger must be exercised end-to-end in the lab.

### 6.1 Browser application trigger (client-side browser exploit)

- The vulnerable target must be the **browser application itself**: Chrome/Chromium, Firefox, Safari/WebKit, Edge, or another browser on Linux, Windows, Android, macOS, or iOS. This is a **client-side browser exploit** / **browser engine exploit** — for example a JavaScript-engine (V8, JavaScriptCore, SpiderMonkey), DOM, WebGL, WebAssembly, renderer, IPC, or sandbox-escape bug.
- The PoC is an HTML/JS/WASM page opened in the pinned vulnerable browser. The page is the exploit; it must trigger the browser bug and produce one of the outcomes in §5.
- Pin the browser: include the browser name, exact version, OS, build/architecture, and any flags or profile settings.
- Demonstrate the full flow from the page: the page triggers the browser bug, the browser performs the outcome, and the page/browser shows or receives the result (command output, reverse-shell callback, or PII leak).
- Evidence must show the browser page producing the outcome. Include the page source, browser version/OS/flags, and a screenshot or recording.
- If you use headless mode, explain how it differs from an interactive browser and include the headless command and version.
- Explain whether user interaction is required (page load, click, permission prompt) and what happens after the trigger.
- **Not accepted:** a server-side web application CVE that is merely reached through a browser page or HTTP request (auth bypass, XSS, SSRF, middleware bypass, server-side RCE). The vulnerability must be in the browser application, not in a web server behind it.

### 6.2 File handler abuse trigger

- The vulnerable target must be the **file-handling application itself**: PDF reader, Office suite, archive manager, media player, image parser, or another application that opens files. This is **file handler abuse** / **client-side file parser exploit**.
- The PoC is a malicious file opened by the pinned vulnerable application with minimal interaction. The file triggers the application and produces one of the outcomes in §5.
- Include the application name and exact version, the OS, the file, and the steps to open or preview it.
- The outcome must happen in the vulnerable application, not on the controller machine.
- Do not rely on Office macros on a real machine; use a pinned lab application and a synthetic file.
- Explain whether user interaction is required (open, preview, extract, play) and what happens after the trigger.
- Evidence must show the file being opened by the vulnerable application and the outcome (command output, callback, or PII).
- **Not accepted:** uploading a file to a web form; a script parsing a file; a server-side file parser. The file must be opened by the vulnerable application.

### 6.3 Common requirements

- The trigger path must be the same path used by `run.sh check` and `run.sh exploit`.
- `check` must prove the trigger is reachable without executing the destructive outcome.
- `exploit` must execute through the trigger, not through a separate shortcut.
- A page that only sends requests to a server-side web app is not a browser-application trigger.
- A page that only displays a proof file written by another script is not a browser-application trigger.
- A file that is only read or parsed by a script, and never opened by the vulnerable application, is not a file-handler trigger.
- Screenshots or logs without the trigger flow are not sufficient evidence.

---

## 7. Combining two CVEs

You may combine **two CVEs** (both 2025–2026) to produce one outcome:

- RCE,
- reverse shell, or
- PII information leak.

Requirements:

- Each CVE must be valid and verifiable.
- Document the chain: CVE A → condition → CVE B → outcome.
- Explain prerequisites, limitations, and why one CVE alone is insufficient.
- Provide evidence for each stage.
- If one CVE cannot be reproduced, replace it or document the failure; do not fake the chain.

Suggested directions (not a CVE list): renderer/browser bug + sandbox escape, file parser + LPE, information leak + session/account takeover. You must still find the CVEs and prove them yourself.

---

## 8. Folder structure and deliverables

Required layout:

```text
CveResearch/
├── README.md                      # this assignment
├── MATRIX.md                      # every CVE attempted + status
├── daily/
│   ├── _TEMPLATE.md
│   └── YYYY-MM-DD.md              # one entry per working day
├── android/
│   ├── rce/
│   │   └── CVE-2025-XXXXX/
│   │       ├── README.md
│   │       ├── lab/
│   │       ├── poc/
│   │       ├── run.sh
│   │       ├── evidence/
│   │       └── notes/
│   ├── reverse_shell/
│   │   └── CVE-YYYY-XXXXX/
│   └── info_leak/
│       └── CVE-YYYY-XXXXX/
├── ios/                           # same <platform>/<category>/<CVE>/ layout
├── linux/
├── mac/
└── windows/
```

Rules:

- One CVE folder per CVE: `android/<category>/CVE-YYYY-XXXXX/`.
- The category is the **final outcome**: `rce`, `reverse_shell`, or `info_leak`.
- A two-CVE chain lives under the final outcome category; use `chain/` inside that CVE folder for the second CVE's artifacts.
- Create each CVE folder directly under its category; do not reuse another CVE folder.
- Keep the folder name as the exact CVE ID.
- The same `<platform>/<category>/<CVE>/` layout applies to `ios/`, `linux/`, `mac/`, and `windows/`.

### `MATRIX.md`

Minimum columns:

| Date | Platform | Category | CVE | Trigger | Public PoC? | Status | Folder | Notes |
|---|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | Android | rce | CVE-YYYY-XXXXX | browser_application/file_handler | yes/no | pass/fail/replaced | `android/rce/CVE-YYYY-XXXXX/` | |

### Per-CVE `README.md`

Must include:

- summary and CVE ID,
- vulnerable and patched versions,
- root cause,
- trigger path,
- build/lab steps,
- how to run the PoC,
- custom command (RCE) or callback configuration (reverse shell),
- PII leaked and its impact (information leak),
- evidence,
- limitations and reliability,
- references.

### `run.sh`

Minimum contract:

```bash
./run.sh lab                         # start the lab if needed
./run.sh check --target <url|file>   # exit 0 if vulnerable, non-zero otherwise
./run.sh exploit --target <url|file> --cmd 'id' --lhost <ip> --lport <port>
./run.sh cleanup
```

- `check` must not run destructive exploit steps.
- `exploit` must accept the customization required by the category.
- `cleanup` stops containers/VMs and removes temporary artifacts.
- No hidden manual steps; document every prerequisite.

---

## 9. Definition of done

The assignment is complete only when:

- The CVE is in 2025–2026 and verified.
- The target runs from a clean lab with the pinned vulnerable version.
- The trigger is a browser-application exploit (HTML/JS page in a pinned vulnerable browser) or a file-handler abuse (malicious file opened by a pinned vulnerable application).
- The trigger itself produces the outcome; a Python driver, checker, raw HTTP request, or server-side web app does not count.
- `run.sh check` proves the target is vulnerable through the declared trigger.
- `run.sh exploit` achieves the chosen outcome through the declared trigger.
- RCE: the custom command runs on the target, not on the controller.
- Reverse shell: the listener receives a shell and a custom command runs.
- PII: synthetic sensitive data is visible and its impact is explained.
- Evidence is complete and auditable.
- The write-up is sufficient for the mentor to reproduce.
- The CVE folder is under the correct category and the daily note is filled.
- There is no hardcoded target/command that violates the category.
- The lab is cleaned up after the demo.

“Almost working,” crash-only, ASLR-only, or a screenshot without a reproducer is **not** done.

---

## 10. Acceptance checklist

- [ ] Valid, verified CVE from 2025–2026.
- [ ] Browser-application trigger: HTML/JS page in a pinned vulnerable browser, with browser version/OS/arch/flags.
- [ ] File-handler trigger: malicious file opened by a pinned vulnerable application, with app version/OS/steps.
- [ ] The trigger itself produces the outcome; a Python driver/checker/server-side web app is not the trigger.
- [ ] Outcome is RCE / reverse shell / PII leak.
- [ ] RCE: custom command option + `id` + unique marker demonstrated.
- [ ] Reverse shell: callback to a lab listener, interactive.
- [ ] PII: synthetic sensitive fields visible, impact explained.
- [ ] If chained: two CVEs from 2025–2026, chain documented.
- [ ] If no public PoC: reproduced from advisory/patch/research, not invented.
- [ ] Folder is `android/<category>/CVE-YYYY-XXXXX/` (or `<platform>/<category>/<CVE>/`).
- [ ] Daily note exists at `daily/YYYY-MM-DD.md` and links the CVE folder.
- [ ] `MATRIX.md` row is updated.
- [ ] `run.sh check`, `exploit`, and `cleanup` work.
- [ ] Evidence exists in `evidence/`.
- [ ] Write-up is complete.
- [ ] No real/public targets and no real PII.
- [ ] Lab is cleaned up.

---

## 11. Scoring rubric

| Component | Weight | What is assessed |
|---|---:|---|
| Exploitability | 30% | Outcome actually achieved; custom command/callback/PII; reliability |
| Reproducibility | 25% | Clean lab, pinned version, `run.sh` works without manual steps |
| Research quality | 20% | Advisory/patch/diff, root cause, references, accuracy |
| Impact | 15% | RCE/revshell/PII impact explained realistically; PII is meaningful |
| Safety/cleanup | 10% | Lab-only, synthetic data, cleanup, no persistence |

Bonus:

- a valid two-CVE chain,
- a CVE with no public PoC successfully reproduced from research,
- exceptionally clean and auditable evidence.

---

## 12. Rejected

- CVEs outside 2025–2026.
- Invalid or unverifiable CVEs.
- Browser crashes, DoS, or ASLR-only findings without the requested outcome.
- RCE with a hardcoded command (`calc`, `whoami`) and no customization.
- PoCs that run on the controller, not the target.
- Information leaks that only expose memory addresses/versions/errors.
- Real PII or public/third-party targets.
- Persistence, worming, lateral movement, or real data exfiltration.
- Fake PoCs, “almost working” exploits, screenshots without a reproducer, or copying a public exploit without understanding it.
- A mock or simulated target that does not run the pinned vulnerable product.
- A server-side web application CVE that is only reached through a browser page or HTTP request (auth bypass, XSS, SSRF, middleware bypass, server-side RCE), not a browser-application or file-handler bug.
- A “browser trigger” that is only a Python script, raw HTTP requests, or a page that just calls a server-side web app, with no browser-application bug.
- A “file trigger” that is only an upload or HTTP request, with no file opened by a vulnerable application.
- Trigger evidence that does not show the browser application or file handler producing the outcome.
- More than one CVE submitted for a single day (a chain counts as one), or a day with no daily note.
- Mixing CVE research deliverables into the production Angler branch.

---

## 13. Suggested research workflow

1. Pick a candidate CVE from 2025–2026 in NVD/vendor advisories/commits.
2. Collect the patch/diff and root cause.
3. Create the day's CVE folder under the correct category.
4. Build a lab with the pinned vulnerable version.
5. Reproduce the trigger (browser application or file handler)
6. Build the PoC in stages; prove each primitive.
7. Achieve the outcome (RCE/revshell/PII).
8. Add command/callback customization and evidence.
9. Write the CVE `README.md`, the daily note, and the `MATRIX.md` row.
10. Test from a clean state with `run.sh`.
11. Demo to the mentor; clean up the lab.

If you get stuck:

- document what you tried in the daily note and `notes/`,
- inspect the patch/commit for hints,
- use other write-ups/research as references,
- if reproduction remains impossible, replace the CVE, record it in `MATRIX.md`, and still submit the day's entry.

Do not stop at “almost working”; do not fake the result either. The final standard is an exploit-ready result you can prove.

---

## 14. Submission and branch

- Store deliverables under `CveResearch/` using `android/<category>/CVE-YYYY-XXXXX/` (or `<platform>/<category>/<CVE>/`).
- Update `daily/YYYY-MM-DD.md` and `MATRIX.md` on the same day.
- Use a separate branch/PR as instructed by the mentor, e.g. `cve-research/<name>`.
- **Do not mix** CVE research deliverables into the Angler branch `chore/retire-obsolete-cves`. That branch is for the Angler module and the SSHole CVE commit; the intern CVE research is a separate deliverable.
- Commit messages must be clear: CVE ID, category, and exploit summary.
- A demo is mandatory: the mentor runs `run.sh check` and `run.sh exploit` from a clean state.

