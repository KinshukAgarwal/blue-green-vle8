#!/usr/bin/env bash
# Zero-downtime probe: hit the Service continuously, log every response, report failures.
# Usage: traffic-check.sh <seconds> [logfile]   (URL = ClusterIP of myapp-service)
DUR=${1:-60}; LOG=${2:-/dev/null}
URL="http://$(kubectl get svc myapp-service -o jsonpath='{.spec.clusterIP}')/"
end=$((SECONDS + DUR)); total=0; fail=0; blue=0; green=0; last=""
: > "$LOG"
while [ $SECONDS -lt $end ]; do
  out=$(curl -s -m 2 -w ' HTTP%{http_code}' "$URL"); rc=$?
  ver=$(grep -o 'VERSION [12] - [A-Z]*' <<<"$out"); code=${out##* }
  total=$((total + 1)); ts=$(date +%T.%3N)
  if [ $rc -ne 0 ] || [ "$code" != HTTP200 ] || [ -z "$ver" ]; then
    fail=$((fail + 1)); echo "$ts FAIL curl_rc=$rc $code" | tee -a "$LOG"; continue
  fi
  echo "$ts $code $ver" >> "$LOG"
  case $ver in *BLUE) blue=$((blue + 1));; *GREEN) green=$((green + 1));; esac
  [ "$ver" != "$last" ] && echo "[traffic] $ts  $code  $ver"; last=$ver
  sleep 0.1
done
echo "[traffic] summary: requests=$total  blue=$blue  green=$green  failed=$fail" | tee -a "$LOG"
