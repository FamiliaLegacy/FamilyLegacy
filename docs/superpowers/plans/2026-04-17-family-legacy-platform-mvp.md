# Family Legacy Platform — MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a private, research-grade family genealogy platform for Puerto Rican ancestry reconstruction, starting with the maternal Mestre/Belén/Echevarría lineage.

**Architecture:** Next.js 14 App Router + TypeScript + Tailwind + shadcn/ui frontend; Supabase for auth, PostgreSQL database, and file storage; React Flow for interactive tree visualization. All data is source-cited with confidence scoring.

**Tech Stack:** Next.js 14, TypeScript, Tailwind CSS, shadcn/ui, Supabase (auth + postgres + storage), React Flow, Zod, TanStack Query, next-safe-action

---

## File Map

### App Shell & Layout
- Create: `app/layout.tsx` — root layout, font, theme provider
- Create: `app/(app)/layout.tsx` — authenticated shell with sidebar
- Create: `app/(app)/dashboard/page.tsx` — dashboard home
- Create: `components/layout/sidebar.tsx` — nav sidebar
- Create: `components/layout/header.tsx` — top bar
- Create: `components/providers.tsx` — query client, theme, supabase

### Auth
- Create: `app/(auth)/login/page.tsx`
- Create: `app/(auth)/login/actions.ts` — server actions for sign in/out
- Create: `lib/supabase/server.ts` — server client
- Create: `lib/supabase/client.ts` — browser client
- Create: `middleware.ts` — route protection

### Database
- Create: `supabase/migrations/001_core_schema.sql` — all core tables
- Create: `lib/db/types.ts` — TypeScript types derived from schema
- Create: `lib/db/queries/people.ts`
- Create: `lib/db/queries/documents.ts`
- Create: `lib/db/queries/events.ts`
- Create: `lib/db/queries/relationships.ts`

### People Module
- Create: `app/(app)/people/page.tsx` — people list
- Create: `app/(app)/people/[id]/page.tsx` — person detail
- Create: `app/(app)/people/new/page.tsx` — add person form
- Create: `components/people/person-card.tsx`
- Create: `components/people/person-form.tsx`
- Create: `components/people/confidence-badge.tsx`

### Documents Module
- Create: `app/(app)/documents/page.tsx`
- Create: `app/(app)/documents/[id]/page.tsx`
- Create: `app/(app)/documents/upload/page.tsx`
- Create: `components/documents/document-card.tsx`
- Create: `components/documents/document-viewer.tsx`
- Create: `components/documents/upload-form.tsx`
- Create: `lib/storage/upload.ts`

### Family Tree
- Create: `app/(app)/tree/page.tsx`
- Create: `components/tree/family-tree.tsx` — React Flow wrapper
- Create: `components/tree/person-node.tsx` — custom node
- Create: `lib/tree/build-tree.ts` — data → React Flow nodes/edges

### Timeline
- Create: `app/(app)/timeline/page.tsx`
- Create: `components/timeline/timeline-view.tsx`
- Create: `components/timeline/event-card.tsx`

### Research Leads
- Create: `app/(app)/leads/page.tsx`
- Create: `components/leads/hypothesis-card.tsx`

---

## Task 1: Project Scaffold

**Files:**
- Create: `package.json`, `tsconfig.json`, `tailwind.config.ts`, `next.config.ts`
- Create: `components/providers.tsx`
- Create: `app/layout.tsx`

- [ ] **Step 1: Initialize Next.js project**

```bash
cd /Volumes/USB/Projects/family-legacy-platform
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir=false --import-alias="@/*"
```

Expected: project scaffold created, `app/` directory present.

- [ ] **Step 2: Install core dependencies**

```bash
npm install @supabase/supabase-js @supabase/ssr reactflow @tanstack/react-query next-safe-action zod lucide-react clsx tailwind-merge class-variance-authority
npm install -D @types/node
```

- [ ] **Step 3: Install shadcn/ui**

```bash
npx shadcn@latest init
# Choose: Default style, Zinc base color, CSS variables yes
npx shadcn@latest add button card badge input label textarea select separator sheet dialog tabs
```

- [ ] **Step 4: Add environment file**

Create `.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

Create `.env.example` with same keys but empty values.

- [ ] **Step 5: Create lib/utils.ts**

```typescript
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

- [ ] **Step 6: Commit**

```bash
git init
git add .
git commit -m "feat: initialize Next.js project with shadcn and dependencies"
```

---

## Task 2: Supabase Setup & Core Schema

**Files:**
- Create: `lib/supabase/server.ts`
- Create: `lib/supabase/client.ts`
- Create: `supabase/migrations/001_core_schema.sql`
- Create: `lib/db/types.ts`

- [ ] **Step 1: Create Supabase browser client**

`lib/supabase/client.ts`:
```typescript
import { createBrowserClient } from "@supabase/ssr"

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

- [ ] **Step 2: Create Supabase server client**

`lib/supabase/server.ts`:
```typescript
import { createServerClient } from "@supabase/ssr"
import { cookies } from "next/headers"

export async function createClient() {
  const cookieStore = await cookies()
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return cookieStore.getAll() },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {}
        },
      },
    }
  )
}
```

- [ ] **Step 3: Write core database schema**

`supabase/migrations/001_core_schema.sql`:
```sql
-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Places
create table places (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  municipality text,
  region text,
  country text default 'Puerto Rico',
  barrio text,
  lat numeric,
  lng numeric,
  notes text,
  created_at timestamptz default now()
);

-- People
create table people (
  id uuid primary key default uuid_generate_v4(),
  first_name text not null,
  middle_name text,
  last_name_paternal text,
  last_name_maternal text,
  display_name text generated always as (
    first_name || coalesce(' ' || middle_name, '') ||
    coalesce(' ' || last_name_paternal, '') ||
    coalesce(' ' || last_name_maternal, '')
  ) stored,
  alternate_names text[],
  gender text check (gender in ('male','female','unknown')),
  birth_date text,           -- stored as text to allow "~1873", "abt 1870", exact dates
  birth_date_confidence text check (birth_date_confidence in ('exact','approximate','estimated','unknown')) default 'unknown',
  birth_place_id uuid references places(id),
  death_date text,
  death_date_confidence text check (death_date_confidence in ('exact','approximate','estimated','unknown')) default 'unknown',
  death_place_id uuid references places(id),
  biography text,
  racial_status_historical text,  -- as recorded in historical docs: "pardo libre", "esclavo", etc.
  occupation text,
  confidence text check (confidence in ('confirmed','likely','possible','speculative')) default 'possible',
  is_anchor boolean default false,  -- key family members
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Relationships
create table relationships (
  id uuid primary key default uuid_generate_v4(),
  person_a_id uuid not null references people(id),
  person_b_id uuid not null references people(id),
  relationship_type text not null check (relationship_type in (
    'parent','child','spouse','sibling','half_sibling',
    'enslaved_by','godparent','godchild','other'
  )),
  confidence text check (confidence in ('confirmed','likely','possible','speculative')) default 'possible',
  start_date text,
  end_date text,
  notes text,
  created_at timestamptz default now()
);

-- Document types enum
create type document_type as enum (
  'birth_certificate','death_certificate','marriage_record',
  'baptism_record','church_record','census_record',
  'slave_register','emancipation_record','land_record',
  'photograph','handwritten_note','newspaper','other'
);

-- Documents
create table documents (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  document_type document_type not null,
  document_date text,
  document_date_confidence text default 'unknown',
  place_id uuid references places(id),
  source_name text,         -- e.g. "Archivo General de Puerto Rico"
  source_url text,
  source_reference text,    -- e.g. "Volume 3, Folio 42"
  original_language text default 'es',
  original_text text,       -- raw transcript preserving original
  corrected_text text,      -- researcher-corrected version
  summary text,
  storage_path text,        -- Supabase Storage path
  mime_type text,
  confidence text check (confidence in ('confirmed','likely','possible','speculative')) default 'possible',
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Link documents to people mentioned
create table document_people (
  id uuid primary key default uuid_generate_v4(),
  document_id uuid not null references documents(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  role_in_document text,  -- e.g. "subject","informant","witness","parent_mentioned"
  notes text
);

-- Timeline events
create table events (
  id uuid primary key default uuid_generate_v4(),
  person_id uuid references people(id),
  event_type text not null check (event_type in (
    'birth','baptism','marriage','death','residence',
    'census','emancipation','enslavement','labor',
    'migration','land_transaction','other'
  )),
  event_date text,
  event_date_confidence text default 'unknown',
  place_id uuid references places(id),
  description text,
  document_id uuid references documents(id),
  confidence text check (confidence in ('confirmed','likely','possible','speculative')) default 'possible',
  notes text,
  created_at timestamptz default now()
);

-- Research leads / hypotheses
create table hypotheses (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  description text,
  hypothesis_type text check (hypothesis_type in (
    'identity_match','parent_child','spouse','location',
    'plantation_tie','document_match','other'
  )),
  status text check (status in ('open','confirmed','likely','possible','disproven')) default 'open',
  people_involved uuid[],
  documents_involved uuid[],
  next_steps text,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Research tasks
create table research_tasks (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  description text,
  status text check (status in ('todo','in_progress','done','blocked')) default 'todo',
  priority text check (priority in ('high','medium','low')) default 'medium',
  related_person_id uuid references people(id),
  related_document_id uuid references documents(id),
  due_date date,
  notes text,
  created_at timestamptz default now()
);

-- RLS: enable on all tables
alter table people enable row level security;
alter table relationships enable row level security;
alter table documents enable row level security;
alter table document_people enable row level security;
alter table events enable row level security;
alter table places enable row level security;
alter table hypotheses enable row level security;
alter table research_tasks enable row level security;

-- RLS policies: authenticated users can read/write all (single-user app for now)
do $$ 
declare t text;
begin
  foreach t in array array['people','relationships','documents','document_people','events','places','hypotheses','research_tasks']
  loop
    execute format('create policy "auth_all" on %I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

-- Indexes
create index on people (last_name_paternal);
create index on people (last_name_maternal);
create index on events (person_id);
create index on events (event_type);
create index on document_people (document_id);
create index on document_people (person_id);
create index on relationships (person_a_id);
create index on relationships (person_b_id);
```

- [ ] **Step 4: Run migration in Supabase dashboard**

Go to Supabase dashboard → SQL Editor → paste and run `001_core_schema.sql`.

- [ ] **Step 5: Create TypeScript types**

`lib/db/types.ts`:
```typescript
export type Confidence = 'confirmed' | 'likely' | 'possible' | 'speculative'
export type DateConfidence = 'exact' | 'approximate' | 'estimated' | 'unknown'

export interface Person {
  id: string
  first_name: string
  middle_name: string | null
  last_name_paternal: string | null
  last_name_maternal: string | null
  display_name: string
  alternate_names: string[] | null
  gender: 'male' | 'female' | 'unknown'
  birth_date: string | null
  birth_date_confidence: DateConfidence
  birth_place_id: string | null
  death_date: string | null
  death_date_confidence: DateConfidence
  death_place_id: string | null
  biography: string | null
  racial_status_historical: string | null
  occupation: string | null
  confidence: Confidence
  is_anchor: boolean
  notes: string | null
  created_at: string
  updated_at: string
}

export interface Relationship {
  id: string
  person_a_id: string
  person_b_id: string
  relationship_type: 'parent' | 'child' | 'spouse' | 'sibling' | 'half_sibling' | 'enslaved_by' | 'godparent' | 'godchild' | 'other'
  confidence: Confidence
  start_date: string | null
  end_date: string | null
  notes: string | null
  created_at: string
}

export interface Place {
  id: string
  name: string
  municipality: string | null
  region: string | null
  country: string
  barrio: string | null
  lat: number | null
  lng: number | null
  notes: string | null
  created_at: string
}

export type DocumentType = 
  | 'birth_certificate' | 'death_certificate' | 'marriage_record'
  | 'baptism_record' | 'church_record' | 'census_record'
  | 'slave_register' | 'emancipation_record' | 'land_record'
  | 'photograph' | 'handwritten_note' | 'newspaper' | 'other'

export interface Document {
  id: string
  title: string
  document_type: DocumentType
  document_date: string | null
  document_date_confidence: DateConfidence
  place_id: string | null
  source_name: string | null
  source_url: string | null
  source_reference: string | null
  original_language: string
  original_text: string | null
  corrected_text: string | null
  summary: string | null
  storage_path: string | null
  mime_type: string | null
  confidence: Confidence
  notes: string | null
  created_at: string
  updated_at: string
}

export interface Event {
  id: string
  person_id: string | null
  event_type: 'birth' | 'baptism' | 'marriage' | 'death' | 'residence' | 'census' | 'emancipation' | 'enslavement' | 'labor' | 'migration' | 'land_transaction' | 'other'
  event_date: string | null
  event_date_confidence: DateConfidence
  place_id: string | null
  description: string | null
  document_id: string | null
  confidence: Confidence
  notes: string | null
  created_at: string
}

export interface Hypothesis {
  id: string
  title: string
  description: string | null
  hypothesis_type: string | null
  status: 'open' | 'confirmed' | 'likely' | 'possible' | 'disproven'
  people_involved: string[] | null
  documents_involved: string[] | null
  next_steps: string | null
  notes: string | null
  created_at: string
  updated_at: string
}

export interface ResearchTask {
  id: string
  title: string
  description: string | null
  status: 'todo' | 'in_progress' | 'done' | 'blocked'
  priority: 'high' | 'medium' | 'low'
  related_person_id: string | null
  related_document_id: string | null
  due_date: string | null
  notes: string | null
  created_at: string
}
```

- [ ] **Step 6: Commit**

```bash
git add .
git commit -m "feat: add Supabase clients and core database schema"
```

---

## Task 3: Authentication & Route Protection

**Files:**
- Create: `middleware.ts`
- Create: `app/(auth)/login/page.tsx`
- Create: `app/(auth)/login/actions.ts`

- [ ] **Step 1: Create middleware**

`middleware.ts`:
```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return request.cookies.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()

  const isAuthRoute = request.nextUrl.pathname.startsWith('/login')
  
  if (!user && !isAuthRoute) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  if (user && isAuthRoute) {
    return NextResponse.redirect(new URL('/dashboard', request.url))
  }

  return supabaseResponse
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'],
}
```

- [ ] **Step 2: Create login server actions**

`app/(auth)/login/actions.ts`:
```typescript
'use server'
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export async function signIn(formData: FormData) {
  const supabase = await createClient()
  const { error } = await supabase.auth.signInWithPassword({
    email: formData.get('email') as string,
    password: formData.get('password') as string,
  })
  if (error) return { error: error.message }
  redirect('/dashboard')
}

export async function signOut() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  redirect('/login')
}
```

- [ ] **Step 3: Create login page**

`app/(auth)/login/page.tsx`:
```tsx
import { signIn } from './actions'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-stone-950">
      <Card className="w-full max-w-sm border-stone-800 bg-stone-900">
        <CardHeader className="space-y-1">
          <CardTitle className="text-2xl text-stone-100 font-serif">Family Legacy</CardTitle>
          <CardDescription className="text-stone-400">
            Sign in to access your family archive
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form action={signIn} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-stone-300">Email</Label>
              <Input
                id="email"
                name="email"
                type="email"
                required
                className="bg-stone-800 border-stone-700 text-stone-100"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password" className="text-stone-300">Password</Label>
              <Input
                id="password"
                name="password"
                type="password"
                required
                className="bg-stone-800 border-stone-700 text-stone-100"
              />
            </div>
            <Button type="submit" className="w-full bg-amber-700 hover:bg-amber-600 text-white">
              Sign In
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
```

- [ ] **Step 4: Commit**

```bash
git add .
git commit -m "feat: add authentication with Supabase and route protection middleware"
```

---

## Task 4: App Shell — Layout, Sidebar, Navigation

**Files:**
- Create: `app/(app)/layout.tsx`
- Create: `components/layout/sidebar.tsx`
- Create: `components/layout/header.tsx`
- Create: `components/providers.tsx`
- Create: `app/layout.tsx`

- [ ] **Step 1: Create root layout**

`app/layout.tsx`:
```tsx
import type { Metadata } from 'next'
import { Inter, Playfair_Display } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/providers'

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' })
const playfair = Playfair_Display({ subsets: ['latin'], variable: '--font-playfair' })

export const metadata: Metadata = {
  title: 'Family Legacy Platform',
  description: 'Private family genealogy and archive',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className="dark">
      <body className={`${inter.variable} ${playfair.variable} font-sans antialiased`}>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
```

- [ ] **Step 2: Create providers**

`components/providers.tsx`:
```tsx
'use client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useState } from 'react'

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient())
  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  )
}
```

- [ ] **Step 3: Create sidebar**

`components/layout/sidebar.tsx`:
```tsx
'use client'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import {
  LayoutDashboard, Users, FileText, GitBranch,
  Clock, Lightbulb, CheckSquare, LogOut
} from 'lucide-react'
import { signOut } from '@/app/(auth)/login/actions'

const navItems = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/people', label: 'People', icon: Users },
  { href: '/tree', label: 'Family Tree', icon: GitBranch },
  { href: '/timeline', label: 'Timeline', icon: Clock },
  { href: '/documents', label: 'Documents', icon: FileText },
  { href: '/leads', label: 'Research Leads', icon: Lightbulb },
  { href: '/tasks', label: 'Tasks', icon: CheckSquare },
]

export function Sidebar() {
  const pathname = usePathname()
  return (
    <aside className="w-60 shrink-0 border-r border-stone-800 bg-stone-950 flex flex-col h-screen sticky top-0">
      <div className="px-6 py-5 border-b border-stone-800">
        <h1 className="font-serif text-lg text-amber-400 leading-tight">Family Legacy</h1>
        <p className="text-xs text-stone-500 mt-0.5">Mestre · Belén · Echevarría</p>
      </div>
      <nav className="flex-1 px-3 py-4 space-y-0.5">
        {navItems.map(({ href, label, icon: Icon }) => (
          <Link
            key={href}
            href={href}
            className={cn(
              'flex items-center gap-3 px-3 py-2.5 rounded-md text-sm transition-colors',
              pathname === href || pathname.startsWith(href + '/')
                ? 'bg-amber-900/40 text-amber-300'
                : 'text-stone-400 hover:text-stone-200 hover:bg-stone-800/60'
            )}
          >
            <Icon className="h-4 w-4 shrink-0" />
            {label}
          </Link>
        ))}
      </nav>
      <div className="px-3 py-4 border-t border-stone-800">
        <form action={signOut}>
          <button
            type="submit"
            className="flex items-center gap-3 px-3 py-2.5 rounded-md text-sm text-stone-500 hover:text-stone-300 hover:bg-stone-800/60 w-full transition-colors"
          >
            <LogOut className="h-4 w-4" />
            Sign Out
          </button>
        </form>
      </div>
    </aside>
  )
}
```

- [ ] **Step 4: Create app layout**

`app/(app)/layout.tsx`:
```tsx
import { Sidebar } from '@/components/layout/sidebar'

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen bg-stone-950">
      <Sidebar />
      <main className="flex-1 overflow-auto">
        {children}
      </main>
    </div>
  )
}
```

- [ ] **Step 5: Test app loads at /dashboard**

```bash
npm run dev
# Open http://localhost:3000 — should redirect to /login
# Sign in → should see sidebar with dark stone/amber theme
```

- [ ] **Step 6: Commit**

```bash
git add .
git commit -m "feat: add app shell with sidebar navigation and dark legacy theme"
```

---

## Task 5: Dashboard Page

**Files:**
- Create: `app/(app)/dashboard/page.tsx`
- Create: `lib/db/queries/stats.ts`

- [ ] **Step 1: Create stats query**

`lib/db/queries/stats.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'

export async function getDashboardStats() {
  const supabase = await createClient()
  const [people, documents, events, tasks, leads] = await Promise.all([
    supabase.from('people').select('id', { count: 'exact', head: true }),
    supabase.from('documents').select('id', { count: 'exact', head: true }),
    supabase.from('events').select('id', { count: 'exact', head: true }),
    supabase.from('research_tasks').select('id,status', { count: 'exact' }),
    supabase.from('hypotheses').select('id,status', { count: 'exact' }),
  ])
  return {
    totalPeople: people.count ?? 0,
    totalDocuments: documents.count ?? 0,
    totalEvents: events.count ?? 0,
    openTasks: tasks.data?.filter(t => t.status !== 'done').length ?? 0,
    openLeads: leads.data?.filter(l => l.status === 'open').length ?? 0,
  }
}

export async function getRecentPeople(limit = 5) {
  const supabase = await createClient()
  const { data } = await supabase
    .from('people')
    .select('id,display_name,birth_date,confidence,is_anchor')
    .order('created_at', { ascending: false })
    .limit(limit)
  return data ?? []
}

export async function getRecentDocuments(limit = 5) {
  const supabase = await createClient()
  const { data } = await supabase
    .from('documents')
    .select('id,title,document_type,document_date,confidence')
    .order('created_at', { ascending: false })
    .limit(limit)
  return data ?? []
}
```

- [ ] **Step 2: Create dashboard page**

`app/(app)/dashboard/page.tsx`:
```tsx
import { getDashboardStats, getRecentPeople, getRecentDocuments } from '@/lib/db/queries/stats'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Users, FileText, Clock, Lightbulb, CheckSquare } from 'lucide-react'
import Link from 'next/link'

export default async function DashboardPage() {
  const [stats, recentPeople, recentDocs] = await Promise.all([
    getDashboardStats(),
    getRecentPeople(),
    getRecentDocuments(),
  ])

  const statCards = [
    { label: 'People', value: stats.totalPeople, icon: Users, href: '/people' },
    { label: 'Documents', value: stats.totalDocuments, icon: FileText, href: '/documents' },
    { label: 'Events', value: stats.totalEvents, icon: Clock, href: '/timeline' },
    { label: 'Open Leads', value: stats.openLeads, icon: Lightbulb, href: '/leads' },
    { label: 'Open Tasks', value: stats.openTasks, icon: CheckSquare, href: '/tasks' },
  ]

  return (
    <div className="p-8 space-y-8">
      <div>
        <h2 className="text-3xl font-serif text-stone-100">Family Archive</h2>
        <p className="text-stone-400 mt-1">Mestre · Belén · Echevarría · López · Irizarry</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
        {statCards.map(({ label, value, icon: Icon, href }) => (
          <Link key={label} href={href}>
            <Card className="border-stone-800 bg-stone-900 hover:bg-stone-800/80 transition-colors cursor-pointer">
              <CardContent className="pt-5 pb-4">
                <div className="flex items-center gap-2 text-stone-400 mb-2">
                  <Icon className="h-4 w-4" />
                  <span className="text-xs uppercase tracking-wide">{label}</span>
                </div>
                <p className="text-3xl font-serif text-stone-100">{value}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        {/* Recent People */}
        <Card className="border-stone-800 bg-stone-900">
          <CardHeader className="pb-3">
            <CardTitle className="text-stone-200 text-base font-medium">Recent People</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {recentPeople.length === 0 && (
              <p className="text-stone-500 text-sm">No people added yet.</p>
            )}
            {recentPeople.map(p => (
              <Link key={p.id} href={`/people/${p.id}`}
                className="flex items-center justify-between py-2 px-3 rounded hover:bg-stone-800 transition-colors group">
                <div>
                  <p className="text-stone-200 text-sm group-hover:text-amber-300 transition-colors">
                    {p.display_name}
                  </p>
                  {p.birth_date && <p className="text-stone-500 text-xs">b. {p.birth_date}</p>}
                </div>
                <Badge variant="outline" className={confidenceColor(p.confidence)}>
                  {p.confidence}
                </Badge>
              </Link>
            ))}
          </CardContent>
        </Card>

        {/* Recent Documents */}
        <Card className="border-stone-800 bg-stone-900">
          <CardHeader className="pb-3">
            <CardTitle className="text-stone-200 text-base font-medium">Recent Documents</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {recentDocs.length === 0 && (
              <p className="text-stone-500 text-sm">No documents uploaded yet.</p>
            )}
            {recentDocs.map(d => (
              <Link key={d.id} href={`/documents/${d.id}`}
                className="flex items-center justify-between py-2 px-3 rounded hover:bg-stone-800 transition-colors group">
                <div>
                  <p className="text-stone-200 text-sm group-hover:text-amber-300 transition-colors">
                    {d.title}
                  </p>
                  <p className="text-stone-500 text-xs capitalize">
                    {d.document_type.replace(/_/g, ' ')} {d.document_date ? `· ${d.document_date}` : ''}
                  </p>
                </div>
              </Link>
            ))}
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

function confidenceColor(c: string) {
  switch (c) {
    case 'confirmed': return 'border-green-700 text-green-400'
    case 'likely': return 'border-blue-700 text-blue-400'
    case 'possible': return 'border-amber-700 text-amber-400'
    default: return 'border-stone-600 text-stone-400'
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add .
git commit -m "feat: add dashboard with stats, recent people, and recent documents"
```

---

## Task 6: People Module — List, Detail, Add

**Files:**
- Create: `lib/db/queries/people.ts`
- Create: `app/(app)/people/page.tsx`
- Create: `app/(app)/people/[id]/page.tsx`
- Create: `app/(app)/people/new/page.tsx`
- Create: `components/people/confidence-badge.tsx`
- Create: `components/people/person-form.tsx`

- [ ] **Step 1: Create people queries**

`lib/db/queries/people.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'
import type { Person } from '@/lib/db/types'

export async function getPeople() {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('people')
    .select('*')
    .order('last_name_paternal', { ascending: true })
  if (error) throw error
  return data as Person[]
}

export async function getPersonById(id: string) {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('people')
    .select(`
      *,
      birth_place:places!birth_place_id(name, municipality),
      death_place:places!death_place_id(name, municipality)
    `)
    .eq('id', id)
    .single()
  if (error) throw error
  return data
}

export async function getPersonRelationships(personId: string) {
  const supabase = await createClient()
  const { data } = await supabase
    .from('relationships')
    .select(`
      *,
      person_a:people!person_a_id(id, display_name, birth_date, confidence),
      person_b:people!person_b_id(id, display_name, birth_date, confidence)
    `)
    .or(`person_a_id.eq.${personId},person_b_id.eq.${personId}`)
  return data ?? []
}

export async function getPersonEvents(personId: string) {
  const supabase = await createClient()
  const { data } = await supabase
    .from('events')
    .select('*, place:places(name, municipality), document:documents(id, title)')
    .eq('person_id', personId)
    .order('event_date', { ascending: true })
  return data ?? []
}

export async function getPersonDocuments(personId: string) {
  const supabase = await createClient()
  const { data } = await supabase
    .from('document_people')
    .select('*, document:documents(*)')
    .eq('person_id', personId)
  return data ?? []
}
```

- [ ] **Step 2: Create confidence badge component**

`components/people/confidence-badge.tsx`:
```tsx
import { Badge } from '@/components/ui/badge'
import type { Confidence } from '@/lib/db/types'

const styles: Record<Confidence, string> = {
  confirmed: 'border-green-700 text-green-400 bg-green-950/40',
  likely: 'border-blue-700 text-blue-400 bg-blue-950/40',
  possible: 'border-amber-700 text-amber-400 bg-amber-950/40',
  speculative: 'border-stone-600 text-stone-400 bg-stone-900',
}

export function ConfidenceBadge({ confidence }: { confidence: Confidence }) {
  return (
    <Badge variant="outline" className={styles[confidence]}>
      {confidence}
    </Badge>
  )
}
```

- [ ] **Step 3: Create people list page**

`app/(app)/people/page.tsx`:
```tsx
import { getPeople } from '@/lib/db/queries/people'
import { ConfidenceBadge } from '@/components/people/confidence-badge'
import { Button } from '@/components/ui/button'
import Link from 'next/link'
import { UserPlus } from 'lucide-react'

export default async function PeoplePage() {
  const people = await getPeople()

  return (
    <div className="p-8 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-serif text-stone-100">People</h2>
          <p className="text-stone-400 text-sm mt-0.5">{people.length} recorded individuals</p>
        </div>
        <Button asChild className="bg-amber-700 hover:bg-amber-600">
          <Link href="/people/new"><UserPlus className="h-4 w-4 mr-2" />Add Person</Link>
        </Button>
      </div>

      <div className="space-y-1">
        {people.map(p => (
          <Link
            key={p.id}
            href={`/people/${p.id}`}
            className="flex items-center justify-between px-4 py-3 rounded-lg border border-stone-800 bg-stone-900 hover:bg-stone-800 transition-colors group"
          >
            <div>
              <p className="text-stone-100 font-medium group-hover:text-amber-300 transition-colors">
                {p.display_name}
              </p>
              <p className="text-stone-500 text-sm">
                {[p.birth_date && `b. ${p.birth_date}`, p.death_date && `d. ${p.death_date}`]
                  .filter(Boolean).join(' · ')}
              </p>
            </div>
            <ConfidenceBadge confidence={p.confidence} />
          </Link>
        ))}
        {people.length === 0 && (
          <p className="text-stone-500 text-center py-12">
            No people added yet. <Link href="/people/new" className="text-amber-400 hover:underline">Add the first person.</Link>
          </p>
        )}
      </div>
    </div>
  )
}
```

- [ ] **Step 4: Create person form component**

`components/people/person-form.tsx`:
```tsx
'use client'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'

interface PersonFormProps {
  action: (formData: FormData) => Promise<void>
  defaultValues?: Record<string, string>
}

export function PersonForm({ action, defaultValues = {} }: PersonFormProps) {
  return (
    <form action={action} className="space-y-6">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label className="text-stone-300">First Name *</Label>
          <Input name="first_name" required defaultValue={defaultValues.first_name}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Middle Name</Label>
          <Input name="middle_name" defaultValue={defaultValues.middle_name}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Paternal Surname</Label>
          <Input name="last_name_paternal" defaultValue={defaultValues.last_name_paternal}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Maternal Surname</Label>
          <Input name="last_name_maternal" defaultValue={defaultValues.last_name_maternal}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label className="text-stone-300">Gender</Label>
          <Select name="gender" defaultValue={defaultValues.gender ?? 'unknown'}>
            <SelectTrigger className="bg-stone-800 border-stone-700 text-stone-100">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="male">Male</SelectItem>
              <SelectItem value="female">Female</SelectItem>
              <SelectItem value="unknown">Unknown</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Confidence Level</Label>
          <Select name="confidence" defaultValue={defaultValues.confidence ?? 'possible'}>
            <SelectTrigger className="bg-stone-800 border-stone-700 text-stone-100">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="confirmed">Confirmed</SelectItem>
              <SelectItem value="likely">Likely</SelectItem>
              <SelectItem value="possible">Possible</SelectItem>
              <SelectItem value="speculative">Speculative</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label className="text-stone-300">Birth Date</Label>
          <Input name="birth_date" placeholder="e.g. 1873, ~1870, 12 Mar 1892"
            defaultValue={defaultValues.birth_date}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Death Date</Label>
          <Input name="death_date" placeholder="e.g. 1945, ~1940"
            defaultValue={defaultValues.death_date}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
      </div>

      <div className="space-y-2">
        <Label className="text-stone-300">Historical Status (as recorded)</Label>
        <Input name="racial_status_historical"
          placeholder="e.g. pardo libre, esclavo, blanco — use original document language"
          defaultValue={defaultValues.racial_status_historical}
          className="bg-stone-800 border-stone-700 text-stone-100" />
      </div>

      <div className="space-y-2">
        <Label className="text-stone-300">Alternate Names / Spellings</Label>
        <Input name="alternate_names" placeholder="comma-separated"
          defaultValue={defaultValues.alternate_names}
          className="bg-stone-800 border-stone-700 text-stone-100" />
      </div>

      <div className="space-y-2">
        <Label className="text-stone-300">Biography / Notes</Label>
        <Textarea name="biography" rows={4}
          defaultValue={defaultValues.biography}
          className="bg-stone-800 border-stone-700 text-stone-100" />
      </div>

      <Button type="submit" className="bg-amber-700 hover:bg-amber-600 text-white">
        Save Person
      </Button>
    </form>
  )
}
```

- [ ] **Step 5: Create add person page with server action**

`app/(app)/people/new/page.tsx`:
```tsx
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { PersonForm } from '@/components/people/person-form'

async function addPerson(formData: FormData) {
  'use server'
  const supabase = await createClient()
  const alternateNamesRaw = formData.get('alternate_names') as string
  const alternateNames = alternateNamesRaw
    ? alternateNamesRaw.split(',').map(s => s.trim()).filter(Boolean)
    : null

  const { data, error } = await supabase.from('people').insert({
    first_name: formData.get('first_name') as string,
    middle_name: formData.get('middle_name') as string || null,
    last_name_paternal: formData.get('last_name_paternal') as string || null,
    last_name_maternal: formData.get('last_name_maternal') as string || null,
    gender: formData.get('gender') as string,
    birth_date: formData.get('birth_date') as string || null,
    death_date: formData.get('death_date') as string || null,
    racial_status_historical: formData.get('racial_status_historical') as string || null,
    alternate_names: alternateNames,
    biography: formData.get('biography') as string || null,
    confidence: formData.get('confidence') as string,
  }).select('id').single()

  if (error) throw error
  redirect(`/people/${data.id}`)
}

export default function NewPersonPage() {
  return (
    <div className="p-8 max-w-2xl">
      <h2 className="text-2xl font-serif text-stone-100 mb-6">Add Person</h2>
      <PersonForm action={addPerson} />
    </div>
  )
}
```

- [ ] **Step 6: Create person detail page**

`app/(app)/people/[id]/page.tsx`:
```tsx
import { getPersonById, getPersonRelationships, getPersonEvents, getPersonDocuments } from '@/lib/db/queries/people'
import { ConfidenceBadge } from '@/components/people/confidence-badge'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import Link from 'next/link'
import { notFound } from 'next/navigation'

export default async function PersonPage({ params }: { params: { id: string } }) {
  const [person, relationships, events, docs] = await Promise.all([
    getPersonById(params.id).catch(() => null),
    getPersonRelationships(params.id),
    getPersonEvents(params.id),
    getPersonDocuments(params.id),
  ])

  if (!person) notFound()

  return (
    <div className="p-8 space-y-6">
      <div className="flex items-start justify-between">
        <div>
          <h2 className="text-3xl font-serif text-stone-100">{person.display_name}</h2>
          {person.alternate_names?.length > 0 && (
            <p className="text-stone-400 text-sm mt-1">
              Also: {person.alternate_names.join(', ')}
            </p>
          )}
          <div className="flex items-center gap-3 mt-2">
            <ConfidenceBadge confidence={person.confidence} />
            {person.is_anchor && (
              <span className="text-xs text-amber-400 border border-amber-700 px-2 py-0.5 rounded">
                Anchor Person
              </span>
            )}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
        {person.birth_date && (
          <div className="bg-stone-900 border border-stone-800 rounded-lg px-4 py-3">
            <p className="text-stone-500 text-xs uppercase tracking-wide">Born</p>
            <p className="text-stone-200 mt-1">{person.birth_date}</p>
            {person.birth_place && <p className="text-stone-400 text-xs">{person.birth_place.name}</p>}
          </div>
        )}
        {person.death_date && (
          <div className="bg-stone-900 border border-stone-800 rounded-lg px-4 py-3">
            <p className="text-stone-500 text-xs uppercase tracking-wide">Died</p>
            <p className="text-stone-200 mt-1">{person.death_date}</p>
            {person.death_place && <p className="text-stone-400 text-xs">{person.death_place.name}</p>}
          </div>
        )}
        {person.racial_status_historical && (
          <div className="bg-stone-900 border border-stone-800 rounded-lg px-4 py-3">
            <p className="text-stone-500 text-xs uppercase tracking-wide">Status (Historical)</p>
            <p className="text-stone-200 mt-1 italic">{person.racial_status_historical}</p>
          </div>
        )}
      </div>

      {person.biography && (
        <Card className="border-stone-800 bg-stone-900">
          <CardContent className="pt-5">
            <p className="text-stone-300 leading-relaxed">{person.biography}</p>
          </CardContent>
        </Card>
      )}

      <Tabs defaultValue="events">
        <TabsList className="bg-stone-900 border border-stone-800">
          <TabsTrigger value="events">Events ({events.length})</TabsTrigger>
          <TabsTrigger value="relationships">Relationships ({relationships.length})</TabsTrigger>
          <TabsTrigger value="documents">Documents ({docs.length})</TabsTrigger>
        </TabsList>

        <TabsContent value="events" className="mt-4 space-y-2">
          {events.map(e => (
            <div key={e.id} className="flex items-start gap-4 px-4 py-3 rounded-lg border border-stone-800 bg-stone-900">
              <div className="text-xs text-stone-500 w-24 shrink-0 pt-0.5">{e.event_date ?? '?'}</div>
              <div>
                <p className="text-stone-200 text-sm capitalize">{e.event_type.replace(/_/g, ' ')}</p>
                {e.description && <p className="text-stone-400 text-sm">{e.description}</p>}
                {e.place && <p className="text-stone-500 text-xs">{e.place.name}</p>}
              </div>
            </div>
          ))}
          {events.length === 0 && <p className="text-stone-500 text-sm">No events recorded.</p>}
        </TabsContent>

        <TabsContent value="relationships" className="mt-4 space-y-2">
          {relationships.map(r => {
            const other = r.person_a_id === params.id ? r.person_b : r.person_a
            return (
              <Link key={r.id} href={`/people/${other.id}`}
                className="flex items-center justify-between px-4 py-3 rounded-lg border border-stone-800 bg-stone-900 hover:bg-stone-800 transition-colors">
                <div>
                  <p className="text-stone-200 text-sm">{other.display_name}</p>
                  <p className="text-stone-500 text-xs capitalize">{r.relationship_type.replace(/_/g, ' ')}</p>
                </div>
                <ConfidenceBadge confidence={r.confidence} />
              </Link>
            )
          })}
          {relationships.length === 0 && <p className="text-stone-500 text-sm">No relationships linked.</p>}
        </TabsContent>

        <TabsContent value="documents" className="mt-4 space-y-2">
          {docs.map(d => (
            <Link key={d.id} href={`/documents/${d.document.id}`}
              className="flex items-center justify-between px-4 py-3 rounded-lg border border-stone-800 bg-stone-900 hover:bg-stone-800 transition-colors">
              <div>
                <p className="text-stone-200 text-sm">{d.document.title}</p>
                <p className="text-stone-500 text-xs capitalize">
                  {d.document.document_type.replace(/_/g, ' ')} {d.role_in_document ? `· ${d.role_in_document}` : ''}
                </p>
              </div>
            </Link>
          ))}
          {docs.length === 0 && <p className="text-stone-500 text-sm">No documents linked.</p>}
        </TabsContent>
      </Tabs>
    </div>
  )
}
```

- [ ] **Step 7: Commit**

```bash
git add .
git commit -m "feat: add people module with list, detail, and add person pages"
```

---

## Task 7: Document Upload Module

**Files:**
- Create: `lib/storage/upload.ts`
- Create: `lib/db/queries/documents.ts`
- Create: `app/(app)/documents/page.tsx`
- Create: `app/(app)/documents/upload/page.tsx`
- Create: `app/(app)/documents/[id]/page.tsx`

- [ ] **Step 1: Create storage upload helper**

`lib/storage/upload.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'

export async function uploadDocument(file: File): Promise<string> {
  const supabase = await createClient()
  const ext = file.name.split('.').pop()
  const path = `documents/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`
  
  const { error } = await supabase.storage
    .from('family-documents')
    .upload(path, file, { contentType: file.type })
  
  if (error) throw error
  return path
}

export function getDocumentUrl(path: string): string {
  const supabase_url = process.env.NEXT_PUBLIC_SUPABASE_URL!
  return `${supabase_url}/storage/v1/object/public/family-documents/${path}`
}
```

- [ ] **Step 2: Create Supabase Storage bucket**

In Supabase dashboard → Storage → New bucket:
- Name: `family-documents`
- Public: false (authenticated access only)

Then in SQL editor, add storage policy:
```sql
create policy "authenticated users can upload documents"
on storage.objects for insert to authenticated
with check (bucket_id = 'family-documents');

create policy "authenticated users can read documents"  
on storage.objects for select to authenticated
using (bucket_id = 'family-documents');
```

- [ ] **Step 3: Create document queries**

`lib/db/queries/documents.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'
import type { Document } from '@/lib/db/types'

export async function getDocuments() {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('documents')
    .select('*')
    .order('created_at', { ascending: false })
  if (error) throw error
  return data as Document[]
}

export async function getDocumentById(id: string) {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('documents')
    .select('*, place:places(name,municipality), people:document_people(*, person:people(id,display_name))')
    .eq('id', id)
    .single()
  if (error) throw error
  return data
}
```

- [ ] **Step 4: Create document upload page**

`app/(app)/documents/upload/page.tsx`:
```tsx
import { createClient } from '@/lib/supabase/server'
import { uploadDocument } from '@/lib/storage/upload'
import { redirect } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'

async function uploadDocumentAction(formData: FormData) {
  'use server'
  const supabase = await createClient()
  const file = formData.get('file') as File
  
  let storagePath: string | null = null
  if (file && file.size > 0) {
    storagePath = await uploadDocument(file)
  }

  const { data, error } = await supabase.from('documents').insert({
    title: formData.get('title') as string,
    document_type: formData.get('document_type') as string,
    document_date: formData.get('document_date') as string || null,
    source_name: formData.get('source_name') as string || null,
    source_reference: formData.get('source_reference') as string || null,
    original_text: formData.get('original_text') as string || null,
    summary: formData.get('summary') as string || null,
    storage_path: storagePath,
    mime_type: file?.type || null,
    confidence: formData.get('confidence') as string,
    notes: formData.get('notes') as string || null,
  }).select('id').single()

  if (error) throw error
  redirect(`/documents/${data.id}`)
}

const documentTypes = [
  'birth_certificate','death_certificate','marriage_record','baptism_record',
  'church_record','census_record','slave_register','emancipation_record',
  'land_record','photograph','handwritten_note','newspaper','other'
]

export default function UploadDocumentPage() {
  return (
    <div className="p-8 max-w-2xl">
      <h2 className="text-2xl font-serif text-stone-100 mb-6">Upload Document</h2>
      <form action={uploadDocumentAction} className="space-y-5">
        <div className="space-y-2">
          <Label className="text-stone-300">Title *</Label>
          <Input name="title" required className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <Label className="text-stone-300">Document Type *</Label>
            <Select name="document_type" required>
              <SelectTrigger className="bg-stone-800 border-stone-700 text-stone-100">
                <SelectValue placeholder="Select type" />
              </SelectTrigger>
              <SelectContent>
                {documentTypes.map(t => (
                  <SelectItem key={t} value={t}>{t.replace(/_/g, ' ')}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label className="text-stone-300">Document Date</Label>
            <Input name="document_date" placeholder="e.g. 1892, Mar 1892"
              className="bg-stone-800 border-stone-700 text-stone-100" />
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <Label className="text-stone-300">Source / Archive</Label>
            <Input name="source_name" placeholder="e.g. Archivo General de Puerto Rico"
              className="bg-stone-800 border-stone-700 text-stone-100" />
          </div>
          <div className="space-y-2">
            <Label className="text-stone-300">Reference / Folio</Label>
            <Input name="source_reference" placeholder="e.g. Vol 3, Folio 42"
              className="bg-stone-800 border-stone-700 text-stone-100" />
          </div>
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">File (PDF or image)</Label>
          <Input name="file" type="file" accept=".pdf,.jpg,.jpeg,.png,.tiff,.webp"
            className="bg-stone-800 border-stone-700 text-stone-100 file:text-stone-300 file:bg-stone-700 file:border-0" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Original Text / Transcript</Label>
          <Textarea name="original_text" rows={5} placeholder="Paste or type original text as it appears in the document (do not correct)"
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Summary</Label>
          <Textarea name="summary" rows={3}
            className="bg-stone-800 border-stone-700 text-stone-100" />
        </div>
        <div className="space-y-2">
          <Label className="text-stone-300">Confidence</Label>
          <Select name="confidence" defaultValue="possible">
            <SelectTrigger className="bg-stone-800 border-stone-700 text-stone-100">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="confirmed">Confirmed</SelectItem>
              <SelectItem value="likely">Likely</SelectItem>
              <SelectItem value="possible">Possible</SelectItem>
              <SelectItem value="speculative">Speculative</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <Button type="submit" className="bg-amber-700 hover:bg-amber-600 text-white">
          Upload Document
        </Button>
      </form>
    </div>
  )
}
```

- [ ] **Step 5: Create documents list page**

`app/(app)/documents/page.tsx`:
```tsx
import { getDocuments } from '@/lib/db/queries/documents'
import { Button } from '@/components/ui/button'
import Link from 'next/link'
import { Upload } from 'lucide-react'

export default async function DocumentsPage() {
  const documents = await getDocuments()

  return (
    <div className="p-8 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-serif text-stone-100">Documents</h2>
          <p className="text-stone-400 text-sm mt-0.5">{documents.length} records in archive</p>
        </div>
        <Button asChild className="bg-amber-700 hover:bg-amber-600">
          <Link href="/documents/upload"><Upload className="h-4 w-4 mr-2" />Upload</Link>
        </Button>
      </div>
      <div className="space-y-1">
        {documents.map(d => (
          <Link key={d.id} href={`/documents/${d.id}`}
            className="flex items-center justify-between px-4 py-3 rounded-lg border border-stone-800 bg-stone-900 hover:bg-stone-800 transition-colors group">
            <div>
              <p className="text-stone-100 font-medium group-hover:text-amber-300 transition-colors">{d.title}</p>
              <p className="text-stone-500 text-sm capitalize">
                {d.document_type.replace(/_/g, ' ')} {d.document_date ? `· ${d.document_date}` : ''}
                {d.source_name ? ` · ${d.source_name}` : ''}
              </p>
            </div>
          </Link>
        ))}
        {documents.length === 0 && (
          <p className="text-stone-500 text-center py-12">
            No documents yet. <Link href="/documents/upload" className="text-amber-400 hover:underline">Upload the first record.</Link>
          </p>
        )}
      </div>
    </div>
  )
}
```

- [ ] **Step 6: Create document detail page**

`app/(app)/documents/[id]/page.tsx`:
```tsx
import { getDocumentById } from '@/lib/db/queries/documents'
import { getDocumentUrl } from '@/lib/storage/upload'
import { Card, CardContent } from '@/components/ui/card'
import Link from 'next/link'
import { notFound } from 'next/navigation'

export default async function DocumentPage({ params }: { params: { id: string } }) {
  const doc = await getDocumentById(params.id).catch(() => null)
  if (!doc) notFound()

  const fileUrl = doc.storage_path ? getDocumentUrl(doc.storage_path) : null

  return (
    <div className="p-8 space-y-6 max-w-4xl">
      <div>
        <h2 className="text-2xl font-serif text-stone-100">{doc.title}</h2>
        <p className="text-stone-400 text-sm mt-1 capitalize">
          {doc.document_type.replace(/_/g, ' ')}
          {doc.document_date ? ` · ${doc.document_date}` : ''}
          {doc.source_name ? ` · ${doc.source_name}` : ''}
          {doc.source_reference ? ` (${doc.source_reference})` : ''}
        </p>
      </div>

      {fileUrl && (
        <div className="border border-stone-800 rounded-lg overflow-hidden">
          {doc.mime_type === 'application/pdf' ? (
            <iframe src={fileUrl} className="w-full h-[600px]" />
          ) : (
            <img src={fileUrl} alt={doc.title} className="w-full max-h-[600px] object-contain bg-stone-950" />
          )}
        </div>
      )}

      <div className="grid md:grid-cols-2 gap-6">
        {doc.original_text && (
          <Card className="border-stone-800 bg-stone-900">
            <CardContent className="pt-5">
              <p className="text-xs text-stone-500 uppercase tracking-wide mb-3">Original Text</p>
              <p className="text-stone-300 text-sm leading-relaxed whitespace-pre-wrap font-mono">
                {doc.original_text}
              </p>
            </CardContent>
          </Card>
        )}
        {doc.corrected_text && (
          <Card className="border-stone-800 bg-stone-900">
            <CardContent className="pt-5">
              <p className="text-xs text-stone-500 uppercase tracking-wide mb-3">Corrected Text</p>
              <p className="text-stone-300 text-sm leading-relaxed whitespace-pre-wrap">
                {doc.corrected_text}
              </p>
            </CardContent>
          </Card>
        )}
      </div>

      {doc.summary && (
        <Card className="border-stone-800 bg-stone-900">
          <CardContent className="pt-5">
            <p className="text-xs text-stone-500 uppercase tracking-wide mb-3">Summary</p>
            <p className="text-stone-300">{doc.summary}</p>
          </CardContent>
        </Card>
      )}

      {doc.people?.length > 0 && (
        <div>
          <p className="text-xs text-stone-500 uppercase tracking-wide mb-3">People Mentioned</p>
          <div className="flex flex-wrap gap-2">
            {doc.people.map((dp: any) => (
              <Link key={dp.person.id} href={`/people/${dp.person.id}`}
                className="px-3 py-1.5 rounded border border-stone-700 text-stone-300 text-sm hover:text-amber-300 hover:border-amber-700 transition-colors">
                {dp.person.display_name}
                {dp.role_in_document && <span className="text-stone-500 text-xs ml-1">({dp.role_in_document})</span>}
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
```

- [ ] **Step 7: Commit**

```bash
git add .
git commit -m "feat: add document upload, list, and detail pages with Supabase storage"
```

---

## Task 8: Seed Data — Known Family Members

**Files:**
- Create: `supabase/seed/001_mestre_belen_family.sql`

- [ ] **Step 1: Create seed file with known ancestors**

`supabase/seed/001_mestre_belen_family.sql`:
```sql
-- Seed: Known Mestre/Belén/Echevarría family members
-- Confidence levels reflect available documentation as of project start

-- Places
insert into places (id, name, municipality, region, country, barrio) values
  ('a1000000-0000-0000-0000-000000000001', 'Yauco', 'Yauco', 'Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000002', 'Guánica', 'Guánica', 'Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000003', 'Barrio Carenero', 'Guánica', 'Southwestern', 'Puerto Rico', 'Carenero');

-- Known family members (maternal line focus)
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000001', 'Keith', 'Manning', null, 'male', 'confirmed', true, 'Primary researcher — Keith David Manning Jr.'),
  ('b1000000-0000-0000-0000-000000000002', 'Virginia', 'Mestre', null, 'female', 'confirmed', true, 'Mother of Keith Manning Jr.'),
  ('b1000000-0000-0000-0000-000000000003', 'Silvia', 'Belén', null, 'female', 'confirmed', true, 'Maternal grandmother — Silvia Belén'),
  ('b1000000-0000-0000-0000-000000000004', 'Pedro', 'Mestre', null, 'male', 'confirmed', true, 'Maternal grandfather — Pedro Mestre'),
  ('b1000000-0000-0000-0000-000000000005', 'María Inés', 'López', 'Echevarría', 'female', 'likely', true, 'Great-grandmother — María Inés López Echevarría'),
  ('b1000000-0000-0000-0000-000000000006', 'Benigna', 'Echevarría', null, 'female', 'possible', false, 'Ancestor — Benigna Echevarría'),
  ('b1000000-0000-0000-0000-000000000007', 'Dolores', 'Echevarría', null, 'female', 'possible', false, 'Ancestor — Dolores Echevarría'),
  ('b1000000-0000-0000-0000-000000000008', 'María', 'Almodovar', 'Echevarría', 'female', 'possible', false, 'Ancestor — María Almodovar Echevarría'),
  ('b1000000-0000-0000-0000-000000000009', 'Juan', 'Irizarry', null, 'male', 'possible', false, 'Don Juan Irizarry — documented slave owner, connected to Yauco area. Research priority.');

-- Core relationships
insert into relationships (person_a_id, person_b_id, relationship_type, confidence, notes) values
  ('b1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001', 'parent', 'confirmed', 'Virginia Mestre is mother of Keith Manning Jr.'),
  ('b1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002', 'parent', 'confirmed', 'Silvia Belén is mother of Virginia Mestre'),
  ('b1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002', 'parent', 'confirmed', 'Pedro Mestre is father of Virginia Mestre'),
  ('b1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004', 'spouse', 'confirmed', 'Silvia Belén and Pedro Mestre — confirmed couple');

-- Research tasks to get started
insert into research_tasks (title, description, priority, status) values
  ('Find baptism record for Silvia Belén in Guánica or Yauco church records', 'Search FamilySearch Puerto Rico Catholic Church Records for Silvia Belén. Check Yauco parish first (pre-Guánica founding). Try alternate spellings: Velen, Vélen.', 'high', 'todo'),
  ('Locate Pedro Mestre in Puerto Rico civil or church records', 'Search for Pedro Mestre in Guánica and Yauco. Mestre may be Catalan origin — look for immigration records or earlier ancestors from Spain.', 'high', 'todo'),
  ('Search for María Inés López Echevarría in Yauco records 1850–1900', 'Compound surname: paternal López, maternal Echevarría. Search FamilySearch collection PR-Catholic records Yauco. May appear as María Inés López or María López Echevarría.', 'high', 'todo'),
  ('Research Don Juan Irizarry in Yauco Registro de Esclavos 1872', 'Registro de Esclavos (Slave Registry) was compiled 1872 before abolition 1873. Search Archivo General de Puerto Rico or FamilySearch for Don Juan Irizarry as slave owner in Yauco municipio.', 'high', 'todo'),
  ('Identify Benigna, Dolores, and María Almodovar Echevarría — determine generational relationships', 'These Echevarría women may be sisters, mother-daughter, or cousins. Search for Echevarría family unit in Yauco. Look for marriage records that would show parents.', 'medium', 'todo'),
  ('Search Guánica founding records and early settlers', 'Guánica was separated from Yauco municipio — research the founding year and early settler records. Family likely migrated from Yauco to Guánica area (Barrio Carenero).', 'medium', 'todo');
```

- [ ] **Step 2: Run seed in Supabase dashboard**

Go to SQL Editor → paste and run seed file.

- [ ] **Step 3: Verify data appears in dashboard**

```bash
# Open http://localhost:3000/dashboard
# Should see: 9 people, 4 relationships, 6 tasks
# Open /people — confirm all 9 ancestors are listed
```

- [ ] **Step 4: Commit**

```bash
git add .
git commit -m "feat: seed known Mestre/Belén/Echevarría family members and initial research tasks"
```

---

## Task 9: Basic Family Tree Visualization

**Files:**
- Create: `lib/tree/build-tree.ts`
- Create: `components/tree/person-node.tsx`
- Create: `components/tree/family-tree.tsx`
- Create: `app/(app)/tree/page.tsx`

- [ ] **Step 1: Install React Flow**

```bash
npm install reactflow
```

- [ ] **Step 2: Create tree data builder**

`lib/tree/build-tree.ts`:
```typescript
import type { Node, Edge } from 'reactflow'

interface PersonNode {
  id: string
  display_name: string
  birth_date: string | null
  confidence: string
  is_anchor: boolean
}

interface Rel {
  id: string
  person_a_id: string
  person_b_id: string
  relationship_type: string
  confidence: string
}

export function buildTreeData(people: PersonNode[], relationships: Rel[]) {
  const nodes: Node[] = people.map((p, i) => ({
    id: p.id,
    type: 'personNode',
    position: { x: (i % 4) * 220, y: Math.floor(i / 4) * 140 },
    data: {
      label: p.display_name,
      birthDate: p.birth_date,
      confidence: p.confidence,
      isAnchor: p.is_anchor,
    },
  }))

  const edges: Edge[] = relationships
    .filter(r => r.relationship_type === 'parent' || r.relationship_type === 'spouse')
    .map(r => ({
      id: r.id,
      source: r.person_a_id,
      target: r.person_b_id,
      type: 'smoothstep',
      label: r.relationship_type,
      style: {
        stroke: r.relationship_type === 'spouse' ? '#d97706' : '#78716c',
        strokeWidth: 1.5,
      },
      labelStyle: { fontSize: 10, fill: '#78716c' },
    }))

  return { nodes, edges }
}
```

- [ ] **Step 3: Create person node component**

`components/tree/person-node.tsx`:
```tsx
import { Handle, Position, type NodeProps } from 'reactflow'
import Link from 'next/link'

const confidenceRing: Record<string, string> = {
  confirmed: 'ring-green-700',
  likely: 'ring-blue-700',
  possible: 'ring-amber-700',
  speculative: 'ring-stone-600',
}

export function PersonNode({ id, data }: NodeProps) {
  return (
    <div className={`bg-stone-900 border border-stone-700 rounded-lg px-4 py-3 min-w-[160px] ring-1 ${confidenceRing[data.confidence] ?? 'ring-stone-700'} shadow-lg`}>
      <Handle type="target" position={Position.Top} className="!bg-stone-600" />
      <Link href={`/people/${id}`}>
        <p className={`text-sm font-medium leading-tight hover:text-amber-300 transition-colors ${data.isAnchor ? 'text-amber-200' : 'text-stone-200'}`}>
          {data.label}
        </p>
        {data.birthDate && (
          <p className="text-xs text-stone-500 mt-0.5">b. {data.birthDate}</p>
        )}
      </Link>
      <Handle type="source" position={Position.Bottom} className="!bg-stone-600" />
    </div>
  )
}
```

- [ ] **Step 4: Create family tree wrapper**

`components/tree/family-tree.tsx`:
```tsx
'use client'
import ReactFlow, { Background, Controls, MiniMap } from 'reactflow'
import 'reactflow/dist/style.css'
import { PersonNode } from './person-node'
import { buildTreeData } from '@/lib/tree/build-tree'

const nodeTypes = { personNode: PersonNode }

interface Props {
  people: any[]
  relationships: any[]
}

export function FamilyTree({ people, relationships }: Props) {
  const { nodes, edges } = buildTreeData(people, relationships)

  return (
    <div className="w-full h-full">
      <ReactFlow
        nodes={nodes}
        edges={edges}
        nodeTypes={nodeTypes}
        fitView
        className="bg-stone-950"
        proOptions={{ hideAttribution: true }}
      >
        <Background color="#292524" gap={20} />
        <Controls className="!bg-stone-900 !border-stone-700 [&>button]:!text-stone-400 [&>button:hover]:!text-stone-200" />
        <MiniMap
          nodeColor={(n) => n.data?.isAnchor ? '#d97706' : '#44403c'}
          className="!bg-stone-900 !border-stone-800"
        />
      </ReactFlow>
    </div>
  )
}
```

- [ ] **Step 5: Create tree page**

`app/(app)/tree/page.tsx`:
```tsx
import { createClient } from '@/lib/supabase/server'
import { FamilyTree } from '@/components/tree/family-tree'

export default async function TreePage() {
  const supabase = await createClient()
  const [{ data: people }, { data: relationships }] = await Promise.all([
    supabase.from('people').select('id,display_name,birth_date,confidence,is_anchor'),
    supabase.from('relationships').select('id,person_a_id,person_b_id,relationship_type,confidence'),
  ])

  return (
    <div className="flex flex-col h-screen">
      <div className="px-8 py-4 border-b border-stone-800">
        <h2 className="text-xl font-serif text-stone-100">Family Tree</h2>
        <p className="text-stone-400 text-xs mt-0.5">Maternal lineage — Mestre · Belén · Echevarría</p>
      </div>
      <div className="flex-1">
        <FamilyTree people={people ?? []} relationships={relationships ?? []} />
      </div>
    </div>
  )
}
```

- [ ] **Step 6: Commit**

```bash
git add .
git commit -m "feat: add interactive family tree with React Flow and confidence indicators"
```

---

## Task 10: Research Leads / Hypotheses

**Files:**
- Create: `lib/db/queries/leads.ts`
- Create: `app/(app)/leads/page.tsx`

- [ ] **Step 1: Create leads queries**

`lib/db/queries/leads.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'

export async function getHypotheses() {
  const supabase = await createClient()
  const { data } = await supabase
    .from('hypotheses')
    .select('*')
    .order('created_at', { ascending: false })
  return data ?? []
}
```

- [ ] **Step 2: Create leads page**

`app/(app)/leads/page.tsx`:
```tsx
import { getHypotheses } from '@/lib/db/queries/leads'
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Plus } from 'lucide-react'

async function addHypothesis(formData: FormData) {
  'use server'
  const supabase = await createClient()
  await supabase.from('hypotheses').insert({
    title: formData.get('title') as string,
    description: formData.get('description') as string || null,
    hypothesis_type: formData.get('hypothesis_type') as string,
    status: 'open',
    next_steps: formData.get('next_steps') as string || null,
  })
  redirect('/leads')
}

const statusColors: Record<string, string> = {
  open: 'border-amber-700 text-amber-400',
  confirmed: 'border-green-700 text-green-400',
  likely: 'border-blue-700 text-blue-400',
  possible: 'border-stone-600 text-stone-400',
  disproven: 'border-red-900 text-red-500',
}

export default async function LeadsPage() {
  const leads = await getHypotheses()

  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-2xl font-serif text-stone-100">Research Leads</h2>
        <p className="text-stone-400 text-sm mt-0.5">{leads.length} hypotheses tracked</p>
      </div>

      {/* Add form */}
      <details className="border border-stone-800 rounded-lg bg-stone-900">
        <summary className="px-4 py-3 text-stone-300 text-sm cursor-pointer hover:text-stone-100 flex items-center gap-2">
          <Plus className="h-4 w-4" /> Add Research Lead
        </summary>
        <form action={addHypothesis} className="px-4 pb-4 space-y-4 pt-2">
          <div className="space-y-2">
            <Label className="text-stone-300">Title *</Label>
            <Input name="title" required className="bg-stone-800 border-stone-700 text-stone-100" />
          </div>
          <div className="space-y-2">
            <Label className="text-stone-300">Type</Label>
            <Select name="hypothesis_type" defaultValue="identity_match">
              <SelectTrigger className="bg-stone-800 border-stone-700 text-stone-100">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {['identity_match','parent_child','spouse','location','plantation_tie','document_match','other'].map(t => (
                  <SelectItem key={t} value={t}>{t.replace(/_/g, ' ')}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label className="text-stone-300">Description</Label>
            <Textarea name="description" rows={3} className="bg-stone-800 border-stone-700 text-stone-100" />
          </div>
          <div className="space-y-2">
            <Label className="text-stone-300">Next Steps</Label>
            <Textarea name="next_steps" rows={2} className="bg-stone-800 border-stone-700 text-stone-100" />
          </div>
          <Button type="submit" className="bg-amber-700 hover:bg-amber-600 text-white">Add Lead</Button>
        </form>
      </details>

      {/* Leads list */}
      <div className="space-y-2">
        {leads.map(h => (
          <div key={h.id} className="px-4 py-4 rounded-lg border border-stone-800 bg-stone-900 space-y-2">
            <div className="flex items-start justify-between gap-4">
              <p className="text-stone-100 font-medium">{h.title}</p>
              <Badge variant="outline" className={statusColors[h.status] ?? ''}>
                {h.status}
              </Badge>
            </div>
            {h.description && <p className="text-stone-400 text-sm">{h.description}</p>}
            {h.next_steps && (
              <p className="text-amber-500/80 text-sm">→ {h.next_steps}</p>
            )}
          </div>
        ))}
        {leads.length === 0 && <p className="text-stone-500 text-center py-12">No leads yet.</p>}
      </div>
    </div>
  )
}
```

- [ ] **Step 3: Commit**

```bash
git add .
git commit -m "feat: add research leads / hypotheses tracking page"
```

---

## Task 11: Timeline Page

**Files:**
- Create: `lib/db/queries/events.ts`
- Create: `app/(app)/timeline/page.tsx`

- [ ] **Step 1: Create events query**

`lib/db/queries/events.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'

export async function getAllEvents() {
  const supabase = await createClient()
  const { data } = await supabase
    .from('events')
    .select('*, person:people(id,display_name), place:places(name,municipality), document:documents(id,title)')
    .order('event_date', { ascending: true })
  return data ?? []
}
```

- [ ] **Step 2: Create timeline page**

`app/(app)/timeline/page.tsx`:
```tsx
import { getAllEvents } from '@/lib/db/queries/events'
import Link from 'next/link'

const eventTypeColors: Record<string, string> = {
  birth: 'bg-green-900 text-green-300',
  baptism: 'bg-emerald-900 text-emerald-300',
  marriage: 'bg-amber-900 text-amber-300',
  death: 'bg-stone-700 text-stone-300',
  enslavement: 'bg-red-950 text-red-400',
  emancipation: 'bg-blue-900 text-blue-300',
  migration: 'bg-purple-900 text-purple-300',
  census: 'bg-stone-800 text-stone-400',
  default: 'bg-stone-800 text-stone-400',
}

export default async function TimelinePage() {
  const events = await getAllEvents()

  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-2xl font-serif text-stone-100">Timeline</h2>
        <p className="text-stone-400 text-sm mt-0.5">{events.length} recorded events</p>
      </div>
      <div className="relative pl-8 space-y-4 before:absolute before:left-3 before:top-0 before:bottom-0 before:w-px before:bg-stone-800">
        {events.map(e => {
          const colorClass = eventTypeColors[e.event_type] ?? eventTypeColors.default
          return (
            <div key={e.id} className="relative">
              <div className="absolute -left-8 top-3 w-2.5 h-2.5 rounded-full bg-stone-700 border border-stone-600" />
              <div className="border border-stone-800 bg-stone-900 rounded-lg px-4 py-3">
                <div className="flex items-center gap-3 mb-1">
                  <span className={`text-xs px-2 py-0.5 rounded capitalize font-medium ${colorClass}`}>
                    {e.event_type.replace(/_/g, ' ')}
                  </span>
                  <span className="text-stone-500 text-xs">{e.event_date ?? 'date unknown'}</span>
                </div>
                {e.person && (
                  <Link href={`/people/${e.person.id}`}
                    className="text-stone-200 text-sm hover:text-amber-300 transition-colors">
                    {e.person.display_name}
                  </Link>
                )}
                {e.description && <p className="text-stone-400 text-sm mt-1">{e.description}</p>}
                <div className="flex items-center gap-3 mt-1.5">
                  {e.place && <span className="text-stone-500 text-xs">{e.place.name}{e.place.municipality ? `, ${e.place.municipality}` : ''}</span>}
                  {e.document && (
                    <Link href={`/documents/${e.document.id}`}
                      className="text-amber-600 text-xs hover:text-amber-400 transition-colors">
                      Source: {e.document.title}
                    </Link>
                  )}
                </div>
              </div>
            </div>
          )
        })}
        {events.length === 0 && <p className="text-stone-500">No events yet.</p>}
      </div>
    </div>
  )
}
```

- [ ] **Step 3: Commit**

```bash
git add .
git commit -m "feat: add chronological timeline with event type color coding"
```

---

## Task 12: Tasks Page

**Files:**
- Create: `lib/db/queries/tasks.ts`
- Create: `app/(app)/tasks/page.tsx`

- [ ] **Step 1: Create tasks query**

`lib/db/queries/tasks.ts`:
```typescript
import { createClient } from '@/lib/supabase/server'

export async function getResearchTasks() {
  const supabase = await createClient()
  const { data } = await supabase
    .from('research_tasks')
    .select('*')
    .order('priority', { ascending: true })
    .order('created_at', { ascending: false })
  return data ?? []
}
```

- [ ] **Step 2: Create tasks page**

`app/(app)/tasks/page.tsx`:
```tsx
import { getResearchTasks } from '@/lib/db/queries/tasks'
import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { Badge } from '@/components/ui/badge'

async function toggleTask(formData: FormData) {
  'use server'
  const supabase = await createClient()
  const id = formData.get('id') as string
  const current = formData.get('status') as string
  const next = current === 'done' ? 'todo' : 'done'
  await supabase.from('research_tasks').update({ status: next }).eq('id', id)
  revalidatePath('/tasks')
}

const priorityColors: Record<string, string> = {
  high: 'border-red-800 text-red-400',
  medium: 'border-amber-800 text-amber-400',
  low: 'border-stone-700 text-stone-400',
}

export default async function TasksPage() {
  const tasks = await getResearchTasks()
  const open = tasks.filter(t => t.status !== 'done')
  const done = tasks.filter(t => t.status === 'done')

  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-2xl font-serif text-stone-100">Research Tasks</h2>
        <p className="text-stone-400 text-sm mt-0.5">{open.length} open · {done.length} completed</p>
      </div>
      <div className="space-y-2">
        {tasks.map(t => (
          <form action={toggleTask} key={t.id}
            className={`flex items-start gap-3 px-4 py-3 rounded-lg border transition-colors ${t.status === 'done' ? 'border-stone-900 bg-stone-950 opacity-50' : 'border-stone-800 bg-stone-900'}`}>
            <input type="hidden" name="id" value={t.id} />
            <input type="hidden" name="status" value={t.status} />
            <button type="submit"
              className={`mt-1 w-4 h-4 rounded shrink-0 border transition-colors ${t.status === 'done' ? 'bg-amber-700 border-amber-700' : 'border-stone-600 hover:border-amber-600'}`}
            />
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                <p className={`text-sm font-medium ${t.status === 'done' ? 'line-through text-stone-500' : 'text-stone-200'}`}>
                  {t.title}
                </p>
                <Badge variant="outline" className={priorityColors[t.priority]}>
                  {t.priority}
                </Badge>
              </div>
              {t.description && <p className="text-stone-500 text-xs mt-1">{t.description}</p>}
            </div>
          </form>
        ))}
      </div>
    </div>
  )
}
```

- [ ] **Step 3: Commit**

```bash
git add .
git commit -m "feat: add research tasks page with toggle completion"
```

---

## Task 13: Final Polish & Placeholder Routes

**Files:**
- Modify: `app/page.tsx` (root redirect)

- [ ] **Step 1: Root page redirect**

`app/page.tsx`:
```tsx
import { redirect } from 'next/navigation'

export default function Home() {
  redirect('/dashboard')
}
```

- [ ] **Step 2: Verify full app flow**

```bash
npm run dev
# Test:
# 1. / → redirects to /login
# 2. Login → redirects to /dashboard
# 3. Dashboard shows stats (9 people, 0 docs, 6 tasks)
# 4. /people → lists 9 seeded family members
# 5. /people/[anchor-person-id] → shows detail with tabs
# 6. /people/new → form saves, redirects to detail
# 7. /tree → React Flow renders with nodes and edges
# 8. /timeline → empty but renders
# 9. /documents → empty, upload link works
# 10. /documents/upload → form renders
# 11. /leads → empty with add form
# 12. /tasks → shows 6 seeded research tasks
```

- [ ] **Step 3: TypeScript check**

```bash
npx tsc --noEmit
# Fix any type errors before committing
```

- [ ] **Step 4: Final commit**

```bash
git add .
git commit -m "feat: complete MVP Phase 1 — app shell, auth, people, documents, tree, timeline, leads, tasks"
```

---

## Phase 2 Backlog (not in this plan)

1. OCR/transcription integration (AWS Textract or Google Document AI)
2. AI-assisted entity extraction from uploaded documents  
3. Relationship link UI (link two people from person detail page)
4. Advanced tree layout algorithm (generational rows, not grid)
5. Document → person linking UI (from document detail page)
6. Event add form with place picker
7. Map view for migration visualization
8. Export: PDF family report
9. Search across people, documents, places
10. Public/private sharing toggle

---

## Self-Review Checklist

- [x] Auth and route protection covered (Task 3)
- [x] Core schema covers all entity types from spec (Task 2)
- [x] Confidence levels on all entities
- [x] Spanish double surname support (paternal + maternal columns)
- [x] Historical status field for slavery-era records
- [x] Seed data with known family members + research tasks
- [x] Document original text preserved separately from corrected text
- [x] All 8 major modules have at least a page
- [x] Dark amber/stone legacy aesthetic consistent throughout
- [x] Puerto Rican geographic data seeded (Yauco, Guánica, Barrio Carenero)
- [x] Don Juan Irizarry seeded as research priority person
