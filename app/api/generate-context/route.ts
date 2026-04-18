import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { generateHistoricalContext } from "@/lib/ai/gemini";

export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { personId, contextType = "historical_snapshot" } = await req.json();
  if (!personId) return NextResponse.json({ error: "personId required" }, { status: 400 });

  // Return cached result if available
  const { data: cached } = await supabase
    .from("ai_contexts")
    .select("content")
    .eq("person_id", personId)
    .eq("context_type", contextType)
    .single();

  if (cached) return NextResponse.json({ content: cached.content, cached: true });

  const { data: person, error } = await supabase
    .from("people")
    .select("*, birth_place:places!birth_place_id(*)")
    .eq("id", personId)
    .single();

  if (error || !person) return NextResponse.json({ error: "Person not found" }, { status: 404 });

  try {
    const content = await generateHistoricalContext(person, contextType);

    await supabase.from("ai_contexts").upsert(
      { person_id: personId, context_type: contextType, content },
      { onConflict: "person_id,context_type" },
    );

    return NextResponse.json({ content });
  } catch (err: any) {
    console.error("Gemini error:", err);
    return NextResponse.json({ error: err.message ?? "Generation failed" }, { status: 500 });
  }
}
