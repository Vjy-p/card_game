#!/usr/bin/env bash
set -euo pipefail

: "${SUPABASE_PROJECT_REF:?Set SUPABASE_PROJECT_REF}"
: "${GAME_MAINTENANCE_SECRET:?Set GAME_MAINTENANCE_SECRET}"

supabase link --project-ref "$SUPABASE_PROJECT_REF"
supabase db push
supabase secrets set \
  GAME_MAINTENANCE_SECRET="$GAME_MAINTENANCE_SECRET"
supabase functions deploy resolve-game-timeouts --no-verify-jwt

echo "Phase 8 deployed."
echo "Configure your scheduler to POST to:"
echo "https://${SUPABASE_PROJECT_REF}.supabase.co/functions/v1/resolve-game-timeouts"
echo "Header: x-game-maintenance-secret: <GAME_MAINTENANCE_SECRET>"
