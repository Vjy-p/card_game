import { createClient } from "https://esm.sh/@supabase/supabase-js@2.0.0";

Deno.serve(async (request) => {
  const requestId = crypto.randomUUID();
  const expectedSecret = Deno.env.get("MAINTENANCE_SECRET");
  const providedSecret = request.headers.get("x-maintenance-secret");

  if (!expectedSecret || providedSecret !== expectedSecret) {
    return Response.json(
      { ok: false, request_id: requestId, error: "unauthorized" },
      { status: 401 },
    );
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const [health, cleanup] = await Promise.all([
    supabase.rpc("backend_health"),
    supabase.rpc("cleanup_backend_operational_data"),
  ]);

  if (health.error || cleanup.error) {
    console.error(JSON.stringify({
      request_id: requestId,
      health_error: health.error?.message,
      cleanup_error: cleanup.error?.message,
    }));
    return Response.json(
      { ok: false, request_id: requestId, error: "backend_health_failed" },
      { status: 500 },
    );
  }

  return Response.json({
    ok: true,
    request_id: requestId,
    health: health.data,
    cleanup: cleanup.data,
  });
});
