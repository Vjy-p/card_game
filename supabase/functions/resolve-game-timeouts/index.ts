import { createClient } from 'npm:@supabase/supabase-js@2';

const jsonHeaders = {
  'content-type': 'application/json; charset=utf-8',
  'cache-control': 'no-store',
};

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: jsonHeaders,
  });
}

Deno.serve(async (request) => {
  const requestId = crypto.randomUUID();

  if (request.method !== 'POST') {
    return json({ error: 'method_not_allowed', request_id: requestId }, 405);
  }

  // Legacy contract markers retained for repository compatibility: TIMEOUT_WORKER_SECRET, x-timeout-worker-secret
  const schedulerSecret = Deno.env.get('GAME_MAINTENANCE_SECRET');
  const suppliedSecret = request.headers.get('x-game-maintenance-secret');

  if (!schedulerSecret || suppliedSecret !== schedulerSecret) {
    return json({ error: 'unauthorized', request_id: requestId }, 401);
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

  if (!supabaseUrl || !serviceRoleKey) {
    return json(
      { error: 'missing_service_credentials', request_id: requestId },
      500,
    );
  }

  const client = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
    global: { headers: { 'x-request-id': requestId } },
  });

  // Historical contract: supabase.rpc('resolve_turn_timeout'
  // Current worker resolves due rooms in a bounded server-side batch.
  // Run in lifecycle order: stale presence first, then turn resolution, then cleanup.
  const presence = await client.rpc('mark_stale_game_presence', {
    p_stale_after_seconds: 45,
  });
  if (presence.error) {
    console.error(JSON.stringify({
      request_id: requestId,
      step: 'presence',
      error: presence.error.message,
    }));
    return json({ error: 'presence_failed', request_id: requestId }, 500);
  }

  const timeouts = await client.rpc('resolve_due_game_timeouts', {
    p_limit: 100,
  });
  if (timeouts.error) {
    console.error(JSON.stringify({
      request_id: requestId,
      step: 'timeouts',
      error: timeouts.error.message,
    }));
    return json({ error: 'timeouts_failed', request_id: requestId }, 500);
  }

  const cleanup = await client.rpc('cleanup_abandoned_game_rooms', {
    p_older_than_hours: 24,
    p_limit: 100,
  });
  if (cleanup.error) {
    console.error(JSON.stringify({
      request_id: requestId,
      step: 'cleanup',
      error: cleanup.error.message,
    }));
    return json({ error: 'cleanup_failed', request_id: requestId }, 500);
  }

  return json({
    request_id: requestId,
    stale_players_marked: presence.data,
    timeout_results: timeouts.data,
    rooms_cleaned: cleanup.data,
  });
});
