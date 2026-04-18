import Link from "next/link";
import { CheckSquare, Clock, FileText, Lightbulb, Users } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { getDashboardStats, getRecentDocuments, getRecentPeople } from "@/lib/db/queries/stats";

export default async function DashboardPage() {
  const [stats, recentPeople, recentDocs] = await Promise.all([
    getDashboardStats(),
    getRecentPeople(),
    getRecentDocuments(),
  ]);

  const statCards = [
    { label: "People", value: stats.totalPeople, icon: Users, href: "/people" },
    { label: "Documents", value: stats.totalDocuments, icon: FileText, href: "/documents" },
    { label: "Events", value: stats.totalEvents, icon: Clock, href: "/timeline" },
    { label: "Open Leads", value: stats.openLeads, icon: Lightbulb, href: "/leads" },
    { label: "Open Tasks", value: stats.openTasks, icon: CheckSquare, href: "/tasks" },
  ];

  return (
    <div className="space-y-8 p-8">
      <div>
        <h1 className="font-serif text-4xl text-stone-900 dark:text-stone-100">Family Archive</h1>
        <p className="mt-2 max-w-2xl text-stone-600 dark:text-stone-400">
          A private genealogy and document platform for reconstructing the Mestre, Belén,
          Echevarría, López, and related maternal family lines.
        </p>
      </div>

      <div className="grid grid-cols-2 gap-4 md:grid-cols-5">
        {statCards.map(({ label, value, icon: Icon, href }) => (
          <Link key={label} href={href}>
            <Card className="h-full border-stone-200 bg-white/85 shadow-sm transition-colors hover:bg-stone-100/90 dark:border-stone-800 dark:bg-stone-900/80 dark:hover:bg-stone-800/80">
              <CardContent className="pb-4 pt-5">
                <div className="mb-2 flex items-center gap-2 text-stone-500 dark:text-stone-400">
                  <Icon className="h-4 w-4" />
                  <span className="text-sm">{label}</span>
                </div>
                <p className="font-serif text-3xl text-stone-900 dark:text-stone-100">{value}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>

      <div className="grid gap-6 xl:grid-cols-2">
        <Card className="border-stone-200 bg-white/85 shadow-sm dark:border-stone-800 dark:bg-stone-900/80">
          <CardHeader>
            <CardTitle className="font-serif text-xl text-stone-900 dark:text-stone-100">
              Recent People
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {recentPeople.length ? (
              recentPeople.map((person) => (
                <div
                  key={person.id}
                  className="flex items-center justify-between rounded-lg border border-stone-200 px-4 py-3 dark:border-stone-800"
                >
                  <div>
                    <p className="font-medium text-stone-900 dark:text-stone-100">
                      {person.display_name}
                    </p>
                    <p className="text-sm text-stone-500 dark:text-stone-400">
                      {person.birth_date ?? "Birth date unknown"}
                    </p>
                  </div>
                  <div className="flex items-center gap-2">
                    {person.is_anchor ? (
                      <Badge className="bg-amber-100 text-amber-900 dark:bg-amber-900/40 dark:text-amber-300">
                        Anchor
                      </Badge>
                    ) : null}
                    <Badge variant="secondary">{person.confidence}</Badge>
                  </div>
                </div>
              ))
            ) : (
              <p className="text-sm text-stone-500 dark:text-stone-400">
                No people have been added yet.
              </p>
            )}
          </CardContent>
        </Card>

        <Card className="border-stone-200 bg-white/85 shadow-sm dark:border-stone-800 dark:bg-stone-900/80">
          <CardHeader>
            <CardTitle className="font-serif text-xl text-stone-900 dark:text-stone-100">
              Recent Documents
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {recentDocs.length ? (
              recentDocs.map((document) => (
                <div
                  key={document.id}
                  className="flex items-center justify-between rounded-lg border border-stone-200 px-4 py-3 dark:border-stone-800"
                >
                  <div>
                    <p className="font-medium text-stone-900 dark:text-stone-100">
                      {document.title}
                    </p>
                    <p className="text-sm text-stone-500 capitalize dark:text-stone-400">
                      {document.document_type.replaceAll("_", " ")}
                    </p>
                  </div>
                  <div className="text-right">
                    <Badge variant="secondary">{document.confidence}</Badge>
                    <p className="mt-2 text-xs text-stone-500 dark:text-stone-400">
                      {document.document_date ?? "Date unknown"}
                    </p>
                  </div>
                </div>
              ))
            ) : (
              <p className="text-sm text-stone-500 dark:text-stone-400">
                No documents have been added yet.
              </p>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
