#!/usr/bin/env bash
set -euo pipefail

supabase start

STATUS_JSON="$(supabase status --output json)"
export SUPABASE_URL="$(printf '%s' "$STATUS_JSON" | dart run tool/read_json.dart API_URL)"
export SUPABASE_ANON_KEY="$(printf '%s' "$STATUS_JSON" | dart run tool/read_json.dart ANON_KEY)"

flutter test integration_test/supabase_multiplayer_e2e_test.dart
