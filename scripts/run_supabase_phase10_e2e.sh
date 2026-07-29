#!/usr/bin/env bash
set -euo pipefail

supabase start
supabase db reset
scripts/load_phase10_test_fixtures.sh

STATUS_JSON="$(supabase status --output json)"
export SUPABASE_URL="$(printf '%s' "$STATUS_JSON" | dart run tool/read_json.dart API_URL)"
export SUPABASE_ANON_KEY="$(printf '%s' "$STATUS_JSON" | dart run tool/read_json.dart ANON_KEY)"
export SUPABASE_SERVICE_ROLE_KEY="$(printf '%s' "$STATUS_JSON" | dart run tool/read_json.dart SERVICE_ROLE_KEY)"

flutter test integration_test/supabase_phase10_deterministic_e2e_test.dart
