export function Header() {
  return (
    <header className="border-b border-stone-200 bg-white/80 px-8 py-4 backdrop-blur dark:border-stone-800 dark:bg-stone-950/70">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-xs uppercase tracking-[0.28em] text-stone-500 dark:text-stone-500">
            Family Archive
          </p>
          <h2 className="mt-1 font-serif text-xl text-stone-900 dark:text-stone-100">
            Manning · Mestre · Belén · López · Echevarría
          </h2>
        </div>
      </div>
    </header>
  );
}
