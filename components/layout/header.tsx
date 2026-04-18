import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { MobileNav } from "./mobile-nav";

export async function Header() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <header className="sticky top-0 z-10 border-b border-stone-200 bg-white/80 px-4 py-3 backdrop-blur dark:border-stone-800 dark:bg-stone-950/80 md:px-8 md:py-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <MobileNav />
          <div>
            <p className="text-xs uppercase tracking-[0.2em] text-stone-400 dark:text-stone-500 hidden sm:block">
              Family Archive
            </p>
            <h2 className="font-serif text-lg md:text-xl text-stone-900 dark:text-stone-100 leading-tight">
              Manning · Mestre · Belén · López · Echevarría
            </h2>
          </div>
        </div>
        {!user && (
          <Link
            href="/login"
            className="rounded-md border border-stone-300 px-3 py-1.5 text-xs text-stone-600 hover:border-amber-400 hover:text-amber-700 transition-colors dark:border-stone-700 dark:text-stone-400 dark:hover:border-amber-600 dark:hover:text-amber-400"
          >
            Family Sign In
          </Link>
        )}
      </div>
    </header>
  );
}
