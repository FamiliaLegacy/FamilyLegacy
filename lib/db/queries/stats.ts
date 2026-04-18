import { createClient } from "@/lib/supabase/server";

export async function getDashboardStats() {
  const supabase = await createClient();

  const [people, documents, events, tasks, leads] = await Promise.all([
    supabase.from("people").select("id", { count: "exact", head: true }),
    supabase.from("documents").select("id", { count: "exact", head: true }),
    supabase.from("events").select("id", { count: "exact", head: true }),
    supabase.from("research_tasks").select("id,status", { count: "exact" }),
    supabase.from("hypotheses").select("id,status", { count: "exact" }),
  ]);

  return {
    totalPeople: people.count ?? 0,
    totalDocuments: documents.count ?? 0,
    totalEvents: events.count ?? 0,
    openTasks: tasks.data?.filter((task) => task.status !== "done").length ?? 0,
    openLeads: leads.data?.filter((lead) => lead.status === "open").length ?? 0,
  };
}

export async function getRecentPeople(limit = 5) {
  const supabase = await createClient();
  const { data } = await supabase
    .from("people")
    .select("id,display_name,birth_date,confidence,is_anchor")
    .order("created_at", { ascending: false })
    .limit(limit);

  return data ?? [];
}

export async function getRecentDocuments(limit = 5) {
  const supabase = await createClient();
  const { data } = await supabase
    .from("documents")
    .select("id,title,document_type,document_date,confidence")
    .order("created_at", { ascending: false })
    .limit(limit);

  return data ?? [];
}
