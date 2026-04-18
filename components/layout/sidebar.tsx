"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  CheckSquare,
  Clock,
  FileText,
  GitBranch,
  LayoutDashboard,
  Lightbulb,
  LogOut,
  Users,
} from "lucide-react";

import { signOut } from "@/app/(auth)/login/actions";
import { cn } from "@/lib/utils";

const navItems = [
  { href: "/dashboard", label: "Dashboard", icon: LayoutDashboard },
  { href: "/people", label: "People", icon: Users },
  { href: "/tree", label: "Family Tree", icon: GitBranch },
  { href: "/timeline", label: "Timeline", icon: Clock },
  { href: "/documents", label: "Documents", icon: FileText },
  { href: "/leads", label: "Research Leads", icon: Lightbulb },
  { href: "/tasks", label: "Tasks", icon: CheckSquare },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="sticky top-0 flex h-screen w-60 shrink-0 flex-col border-r border-stone-200 bg-stone-50/80 backdrop-blur dark:border-stone-800 dark:bg-stone-950">
      <div className="border-b border-stone-200 px-6 py-5 dark:border-stone-800">
        <h1 className="font-serif text-lg leading-tight text-amber-700 dark:text-amber-400">
          Family Legacy
        </h1>
        <p className="mt-0.5 text-xs text-stone-500 dark:text-stone-500">
          Mestre · Belén · Echevarría
        </p>
      </div>
      <nav className="flex-1 space-y-0.5 px-3 py-4">
        {navItems.map(({ href, label, icon: Icon }) => (
          <Link
            key={href}
            href={href}
            className={cn(
              "flex items-center gap-3 rounded-md px-3 py-2.5 text-sm transition-colors",
              pathname === href || pathname.startsWith(`${href}/`)
                ? "bg-amber-100 text-amber-900 dark:bg-amber-900/40 dark:text-amber-300"
                : "text-stone-600 hover:bg-stone-200/70 hover:text-stone-900 dark:text-stone-400 dark:hover:bg-stone-800/60 dark:hover:text-stone-200",
            )}
          >
            <Icon className="h-4 w-4 shrink-0" />
            {label}
          </Link>
        ))}
      </nav>
      <div className="border-t border-stone-200 px-3 py-4 dark:border-stone-800">
        <form action={signOut}>
          <button
            type="submit"
            className="flex w-full items-center gap-3 rounded-md px-3 py-2.5 text-sm text-stone-500 transition-colors hover:bg-stone-200/70 hover:text-stone-800 dark:text-stone-500 dark:hover:bg-stone-800/60 dark:hover:text-stone-300"
          >
            <LogOut className="h-4 w-4" />
            Sign Out
          </button>
        </form>
      </div>
    </aside>
  );
}
