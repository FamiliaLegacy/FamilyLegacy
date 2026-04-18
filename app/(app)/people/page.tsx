import Link from "next/link";
import { User } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/server";

export default async function PeoplePage() {
  const supabase = await createClient();
  const { data: people } = await supabase
    .from("people")
    .select(
      "id, display_name, first_name, last_name_paternal, birth_date, death_date, confidence, is_anchor, racial_status_historical",
    )
    .order("birth_date", { ascending: true, nullsFirst: false });

  const confirmed = people?.filter((p) => p.confidence === "confirmed") ?? [];
  const research = people?.filter((p) => p.confidence !== "confirmed") ?? [];

  return (
    <div className="p-4 md:p-8 space-y-8">
      <div>
        <h1 className="font-serif text-3xl md:text-4xl text-stone-900 dark:text-stone-100">
          People
        </h1>
        <p className="mt-2 text-stone-500 dark:text-stone-400">
          {people?.length ?? 0} known family members across all lineages
        </p>
      </div>

      {confirmed.length > 0 && (
        <section>
          <h2 className="font-serif text-xl text-stone-700 dark:text-stone-300 mb-4">Confirmed</h2>
          <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
            {confirmed.map((person) => (
              <PersonCard key={person.id} person={person} />
            ))}
          </div>
        </section>
      )}

      {research.length > 0 && (
        <section>
          <h2 className="font-serif text-xl text-stone-700 dark:text-stone-300 mb-4">
            Research Leads
          </h2>
          <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
            {research.map((person) => (
              <PersonCard key={person.id} person={person} />
            ))}
          </div>
        </section>
      )}

      {!people?.length && (
        <div className="rounded-lg border border-dashed border-stone-300 dark:border-stone-700 p-12 text-center">
          <p className="text-stone-500 dark:text-stone-400">
            No people yet — run the database migrations to load your family data.
          </p>
        </div>
      )}
    </div>
  );
}

function PersonCard({ person }: { person: any }) {
  const lifespan = [
    person.birth_date ? `b. ${person.birth_date}` : null,
    person.death_date ? `d. ${person.death_date}` : null,
  ]
    .filter(Boolean)
    .join(" · ");

  return (
    <Link href={`/people/${person.id}`}>
      <Card className="h-full border-stone-200 bg-white/85 shadow-sm transition-all hover:shadow-md hover:border-amber-300/70 dark:border-stone-800 dark:bg-stone-900/80 dark:hover:border-amber-700/50">
        <CardContent className="p-4">
          <div className="flex items-start justify-between gap-2">
            <div className="flex items-center gap-3 min-w-0">
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-amber-100 dark:bg-amber-900/40">
                <User className="h-4 w-4 text-amber-700 dark:text-amber-400" />
              </div>
              <div className="min-w-0">
                <p className="font-medium text-stone-900 dark:text-stone-100 leading-tight truncate">
                  {person.display_name}
                </p>
                {lifespan && (
                  <p className="text-xs text-stone-500 dark:text-stone-400 mt-0.5">{lifespan}</p>
                )}
              </div>
            </div>
            <div className="flex flex-col items-end gap-1 shrink-0">
              {person.is_anchor && (
                <Badge className="bg-amber-100 text-amber-900 dark:bg-amber-900/40 dark:text-amber-300 text-xs">
                  Anchor
                </Badge>
              )}
              <Badge variant="secondary" className="text-xs capitalize">
                {person.confidence}
              </Badge>
            </div>
          </div>
          {person.racial_status_historical && (
            <p className="mt-2 text-xs text-stone-400 dark:text-stone-500 pl-12">
              Historical: {person.racial_status_historical}
            </p>
          )}
        </CardContent>
      </Card>
    </Link>
  );
}
