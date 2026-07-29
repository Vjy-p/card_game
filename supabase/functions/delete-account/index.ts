import { createClient } from "npm:@supabase/supabase-js@2";

Deno.serve(async (req) => {
  try {
    const authHeader = req.headers.get("Authorization");

    if (!authHeader) {
      return new Response(
        JSON.stringify({
          success: false,
          message: "Missing Authorization header",
        }),
        { status: 401 },
      );
    }

    // Client for verifying the caller
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      {
        global: {
          headers: {
            Authorization: authHeader,
          },
        },
      },
    );

    const {
      data: { user },
      error,
    } = await supabase.auth.getUser();

    if (error || !user) {
      return new Response(
        JSON.stringify({
          success: false,
          message: error?.message ?? "User not allowed",
        }),
        { status: 401 },
      );
    }

    // Admin client
    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    await admin.from("players").delete().eq("user_id", user.id);
    await admin.from("profiles").delete().eq("id", user.id);

    const { error: deleteError } = await admin.auth.admin.deleteUser(user.id);

    if (deleteError != null) {
      return new Response(
        JSON.stringify({
          success: false,
          message: deleteError.message,
        }),
        { status: 400 },
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
      }),
      { status: 200 },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({
        success: false,
        message: String(e),
      }),
      { status: 500 },
    );
  }
});
