import { MobileNav } from "./mobile-nav";

export function Header() {
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
      </div>
    </header>
  );
}
