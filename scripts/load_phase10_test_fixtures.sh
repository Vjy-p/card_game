#!/usr/bin/env bash
set -euo pipefail

DB_URL="${SUPABASE_DB_URL:-postgresql://postgres:postgres@127.0.0.1:54322/postgres}"

psql "$DB_URL" \
  --set ON_ERROR_STOP=1 \
  --file supabase/test_migrations/202607090016_deterministic_game_fixtures.sql
