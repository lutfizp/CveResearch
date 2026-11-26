# Security Research Log — 2026-11-16

- Issue or advisory: CVE-2026-54011
- Platform / product: cross-site scripting (XSS)
- Vulnerability class: Medium 5.4
- Impact summary: When previewing Markdown files, Open WebUI renders Mermaid diagram blocks and inserts the resulting SVG into the DOM using innerHTML. Because Mermaid runs with securityLevel: 'loose', an attacker can supply crafted Mermaid content that executes JavaScript when a user opens the preview
- Affected versions: 0.9.6
- Fixed version or mitigation: mitigated
- Status: mitigated
- References: https://nvd.nist.gov/vuln/detail/CVE-2026-54011
- Evidence (sanitized):
- Notes / next steps: continuing demonstrationfor evidence

Do not include exploit code, credentials, personal data, or sensitive target details.
