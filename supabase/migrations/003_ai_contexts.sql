create table ai_contexts (
  id uuid primary key default gen_random_uuid(),
  person_id uuid not null references people(id) on delete cascade,
  context_type text not null,
  content text not null,
  model text default 'gemini-1.5-flash',
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(person_id, context_type)
);

alter table ai_contexts enable row level security;

create policy "auth_all" on ai_contexts
  for all to authenticated
  using (true)
  with check (true);

create index on ai_contexts (person_id);
