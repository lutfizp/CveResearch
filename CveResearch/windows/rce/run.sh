
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXED_DIR="$ROOT/../CVE-2025-29927-fixed"

VULN_NAME="cve-2025-29927-vuln"
FIXED_NAME="cve-2025-29927-fixed"

case "${1:-start}" in
  stop)
    docker rm -f "$VULN_NAME" "$FIXED_NAME" 2>/dev/null || true
    echo "[+] Lab containers stopped."
    exit 0
    ;;

  status)
    docker ps -a --filter "name=cve-2025-29927"
    exit 0
    ;;

  start)
    ;;

  *)
    echo "Usage: $0 [start|stop|status]"
    exit 1
    ;;
esac

if [[ ! -d "$FIXED_DIR" ]]; then
  echo "[-] Fixed directory not found: $FIXED_DIR"
  exit 1
fi

if [[ ! -f "$ROOT/.env" ]]; then
  if ! command -v openssl >/dev/null 2>&1; then
    echo "[-] OpenSSL is required to generate NEXTAUTH_SECRET."
    exit 1
  fi

  echo "NEXTAUTH_SECRET=$(openssl rand -base64 32)" > "$ROOT/.env"
  chmod 600 "$ROOT/.env"
  echo "[+] Generated local environment file."
fi

echo "[+] Removing previous lab containers..."
docker rm -f "$VULN_NAME" "$FIXED_NAME" 2>/dev/null || true

echo "[+] Building vulnerable image..."
docker build -t cve-2025-29927:vuln "$ROOT"

echo "[+] Building fixed image..."
docker build -t cve-2025-29927:fixed "$FIXED_DIR"

echo "[+] Starting vulnerable container..."
docker run -d \
  --name "$VULN_NAME" \
  -p 3100:3000 \
  --env-file "$ROOT/.env" \
  -e NEXTAUTH_URL=http://localhost:3100 \
  cve-2025-29927:vuln

echo "[+] Starting fixed container..."
docker run -d \
  --name "$FIXED_NAME" \
  -p 3101:3000 \
  --env-file "$ROOT/.env" \
  -e NEXTAUTH_URL=http://localhost:3101 \
  cve-2025-29927:fixed

echo
echo "[+] Lab started."
echo "    Vulnerable: http://localhost:3100"
echo "    Fixed:      http://localhost:3101"
echo
echo "Commands:"
echo "    bash run.sh status"
echo "    bash run.sh stop"
