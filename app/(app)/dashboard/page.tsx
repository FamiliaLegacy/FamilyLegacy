import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const dashboardCards = [
  "Family lines and anchor people",
  "Primary documents and translations",
  "Timeline reconstruction",
  "Research leads and open tasks",
];

export default function DashboardPage() {
  return (
    <div className="space-y-8 p-8">
      <div>
        <h1 className="font-serif text-4xl text-stone-900 dark:text-stone-100">Family Archive</h1>
        <p className="mt-2 max-w-2xl text-stone-600 dark:text-stone-400">
          A private genealogy and document platform for reconstructing the Mestre, Belén,
          Echevarría, López, and related maternal family lines.
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {dashboardCards.map((title) => (
          <Card
            key={title}
            className="border-stone-200 bg-white/85 shadow-sm dark:border-stone-800 dark:bg-stone-900/80"
          >
            <CardHeader>
              <CardTitle className="font-serif text-lg text-stone-900 dark:text-stone-100">
                {title}
              </CardTitle>
            </CardHeader>
            <CardContent className="text-sm text-stone-600 dark:text-stone-400">
              This section will be connected to Supabase-backed archive data in the next tasks.
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
