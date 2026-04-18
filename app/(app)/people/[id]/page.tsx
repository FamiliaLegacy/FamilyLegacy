import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, Calendar, User } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { HistoricalContext } from "@/components/historical-context";
import { createClient } from "@/lib/supabase/server";

export default async function PersonPage({ params }: { params: { id: string } }) {
  const supabase = await createClient();

  const [{ data: person }, { data: relationships }, { data: events }] = await Promise.all([
    supabase
      .from("people")
      .select("*, birth_place:places!birth_place_id(*), death_place:places!death_place_id(*)")
      .eq("id", params.id)
      .single(),
    supabase
      .from("relationships")
      .select(
        "*, person_a:people!person_a_id(id,display_name,birth_date,confidence), person_b:people!person_b_id(id,display_name,birth_date,confidence)",
      )
      .or(`person_a_id.eq.${params.id},person_b_id.eq.${params.id}`),
    supabase
      .from("events")
      .select("*, place:places(*)")
      .eq("person_id", params.id)
      .order("event_date", { ascending: true }),
  ]);

  if (!person) notFound();

  const parents =
    relationships
      ?.filter((r) => r.relationship_type === "parent" && r.person_b_id === params.id)
      .map((r) => r.person_a) ?? [];
  const children =
    relationships
      ?.filter((r) => r.relationship_type === "parent" && r.person_a_id === params.id)
      .map((r) => r.person_b) ?? [];
  const spouses =
    relationships
      ?.filter((r) => r.relationship_type === "spouse")
      .map((r) => (r.person_a_id === params.id ? r.person_b : r.person_a)) ?? [];

  return (
    <div className="p-4 md:p-8 space-y-6 max-w-3xl">
      <Link
        href="/people"
        className="inline-flex items-center gap-2 text-sm text-stone-500 hover:text-stone-800 dark:hover:text-stone-200 transition-colors"
      >
        <ArrowLeft className="h-4 w-4" />
        All People
      </Link>

      {/* Name + badges */}
      <div className="flex items-start gap-4">
        <div className="flex h-12 w-12 md:h-14 md:w-14 shrink-0 items-center justify-center rounded-full bg-amber-100 dark:bg-amber-900/40">
          <User className="h-6 w-6 md:h-7 md:w-7 text-amber-700 dark:text-amber-400" />
        </div>
        <div className="flex-1 min-w-0">
          <h1 className="font-serif text-2xl md:text-4xl text-stone-900 dark:text-stone-100 leading-tight">
            {person.display_name}
          </h1>
          <div className="flex flex-wrap gap-2 mt-2">
            <Badge
              className={
                person.confidence === "confirmed"
                  ? "bg-emerald-100 text-emerald-900 dark:bg-emerald-900/40 dark:text-emerald-300"
                  : "bg-amber-100 text-amber-900 dark:bg-amber-900/40 dark:text-amber-300"
              }
            >
              {person.confidence}
            </Badge>
            {person.is_anchor && (
              <Badge variant="outline" className="border-amber-300 text-amber-700 dark:border-amber-700 dark:text-amber-400">
                Anchor Person
              </Badge>
            )}
            {person.racial_status_historical && (
              <Badge variant="secondary">{person.racial_status_historical}</Badge>
            )}
            {person.gender && person.gender !== "unknown" && (
              <Badge variant="secondary" className="capitalize">
                {person.gender}
              </Badge>
            )}
          </div>
        </div>
      </div>

      {/* Vital dates */}
      <div className="grid gap-3 sm:grid-cols-2">
        {(person.birth_date || person.birth_place) && (
          <Card className="border-stone-200 bg-white/85 dark:border-stone-800 dark:bg-stone-900/80">
            <CardContent className="p-4 flex items-center gap-3">
              <Calendar className="h-4 w-4 text-amber-600 shrink-0" />
              <div>
                <p className="text-xs text-stone-500 uppercase tracking-wide">Born</p>
                <p className="text-sm font-medium text-stone-900 dark:text-stone-100">
                  {person.birth_date ?? "Unknown"}
                  {person.birth_date_confidence !== "exact" && person.birth_date && (
                    <span className="text-xs text-stone-400 ml-1">
                      ({person.birth_date_confidence})
                    </span>
                  )}
                </p>
                {person.birth_place && (
                  <p className="text-xs text-stone-500 mt-0.5">
                    {person.birth_place.name}, {person.birth_place.country}
                  </p>
                )}
              </div>
            </CardContent>
          </Card>
        )}
        {(person.death_date || person.death_place) && (
          <Card className="border-stone-200 bg-white/85 dark:border-stone-800 dark:bg-stone-900/80">
            <CardContent className="p-4 flex items-center gap-3">
              <Calendar className="h-4 w-4 text-stone-400 shrink-0" />
              <div>
                <p className="text-xs text-stone-500 uppercase tracking-wide">Died</p>
                <p className="text-sm font-medium text-stone-900 dark:text-stone-100">
                  {person.death_date ?? "Unknown"}
                  {person.death_date_confidence !== "exact" && person.death_date && (
                    <span className="text-xs text-stone-400 ml-1">
                      ({person.death_date_confidence})
                    </span>
                  )}
                </p>
                {person.death_place && (
                  <p className="text-xs text-stone-500 mt-0.5">
                    {person.death_place.name}, {person.death_place.country}
                  </p>
                )}
              </div>
            </CardContent>
          </Card>
        )}
      </div>

      {/* Gemini historical context */}
      <HistoricalContext personId={person.id} personName={person.display_name} />

      {/* Family connections */}
      {(parents.length > 0 || spouses.length > 0 || children.length > 0) && (
        <Card className="border-stone-200 bg-white/85 dark:border-stone-800 dark:bg-stone-900/80">
          <CardHeader className="pb-3">
            <CardTitle className="font-serif text-xl text-stone-900 dark:text-stone-100">
              Family
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-5">
            {parents.length > 0 && (
              <FamilySection label="Parents" people={parents} />
            )}
            {spouses.length > 0 && (
              <FamilySection label="Spouse" people={spouses} />
            )}
            {children.length > 0 && (
              <FamilySection label="Children" people={children} />
            )}
          </CardContent>
        </Card>
      )}

      {/* Timeline */}
      {events && events.length > 0 && (
        <Card className="border-stone-200 bg-white/85 dark:border-stone-800 dark:bg-stone-900/80">
          <CardHeader className="pb-3">
            <CardTitle className="font-serif text-xl text-stone-900 dark:text-stone-100">
              Timeline
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="relative space-y-5 before:absolute before:left-[9px] before:top-2 before:bottom-2 before:w-px before:bg-stone-200 dark:before:bg-stone-700">
              {events.map((event: { id: string; event_type: string; event_date?: string; description?: string; confidence: string; place?: { name: string } }) => (
                <div key={event.id} className="flex gap-4 pl-7 relative">
                  <div className="absolute left-0 top-[5px] h-[18px] w-[18px] rounded-full border-2 border-amber-400 bg-white dark:bg-stone-900 flex items-center justify-center">
                    <div className="h-1.5 w-1.5 rounded-full bg-amber-500" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-stone-500 capitalize">
                      {event.event_type.replace(/_/g, " ")}
                      {event.event_date ? ` · ${event.event_date}` : ""}
                    </p>
                    {event.place && (
                      <p className="text-xs text-stone-400">{event.place.name}</p>
                    )}
                    {event.description && (
                      <p className="text-sm text-stone-700 dark:text-stone-300 mt-1 leading-relaxed">
                        {event.description}
                      </p>
                    )}
                    <Badge variant="secondary" className="text-xs mt-1.5">
                      {event.confidence}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Research notes */}
      {person.notes && (
        <Card className="border-stone-200 bg-white/85 dark:border-stone-800 dark:bg-stone-900/80">
          <CardHeader className="pb-3">
            <CardTitle className="font-serif text-xl text-stone-900 dark:text-stone-100">
              Research Notes
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-stone-600 dark:text-stone-400 leading-relaxed whitespace-pre-line">
              {person.notes}
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
}

interface FamilyMember { id: string; display_name: string; birth_date?: string }
function FamilySection({ label, people }: { label: string; people: FamilyMember[] }) {
  return (
    <div>
      <p className="text-xs uppercase tracking-wide text-stone-400 dark:text-stone-500 mb-2">
        {label}
      </p>
      <div className="space-y-1">
        {people.map(
          (p) =>
            p && (
              <Link
                key={p.id}
                href={`/people/${p.id}`}
                className="flex items-center justify-between rounded-md px-3 py-2 text-sm hover:bg-stone-100 dark:hover:bg-stone-800 transition-colors"
              >
                <span className="text-stone-900 dark:text-stone-100">{p.display_name}</span>
                <span className="text-xs text-stone-400">
                  {p.birth_date ? `b. ${p.birth_date}` : ""}
                </span>
              </Link>
            ),
        )}
      </div>
    </div>
  );
}
