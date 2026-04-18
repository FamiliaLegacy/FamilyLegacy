create table places (
  id uuid primary key default gen_random_uuid(),
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

create table people (
  id uuid primary key default gen_random_uuid(),
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
  gender text check (gender in ('male', 'female', 'unknown')),
  birth_date text,
  birth_date_confidence text check (birth_date_confidence in ('exact', 'approximate', 'estimated', 'unknown')) default 'unknown',
  birth_place_id uuid references places(id),
  death_date text,
  death_date_confidence text check (death_date_confidence in ('exact', 'approximate', 'estimated', 'unknown')) default 'unknown',
  death_place_id uuid references places(id),
  biography text,
  racial_status_historical text,
  occupation text,
  confidence text check (confidence in ('confirmed', 'likely', 'possible', 'speculative')) default 'possible',
  is_anchor boolean default false,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table relationships (
  id uuid primary key default gen_random_uuid(),
  person_a_id uuid not null references people(id),
  person_b_id uuid not null references people(id),
  relationship_type text not null check (relationship_type in (
    'parent', 'child', 'spouse', 'sibling', 'half_sibling',
    'enslaved_by', 'godparent', 'godchild', 'other'
  )),
  confidence text check (confidence in ('confirmed', 'likely', 'possible', 'speculative')) default 'possible',
  start_date text,
  end_date text,
  notes text,
  created_at timestamptz default now()
);

create type document_type as enum (
  'birth_certificate', 'death_certificate', 'marriage_record',
  'baptism_record', 'church_record', 'census_record',
  'slave_register', 'emancipation_record', 'land_record',
  'photograph', 'handwritten_note', 'newspaper', 'other'
);

create table documents (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  document_type document_type not null,
  document_date text,
  document_date_confidence text default 'unknown',
  place_id uuid references places(id),
  source_name text,
  source_url text,
  source_reference text,
  original_language text default 'es',
  original_text text,
  corrected_text text,
  summary text,
  storage_path text,
  mime_type text,
  confidence text check (confidence in ('confirmed', 'likely', 'possible', 'speculative')) default 'possible',
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table document_people (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references documents(id) on delete cascade,
  person_id uuid not null references people(id) on delete cascade,
  role_in_document text,
  notes text
);

create table events (
  id uuid primary key default gen_random_uuid(),
  person_id uuid references people(id),
  event_type text not null check (event_type in (
    'birth', 'baptism', 'marriage', 'death', 'residence',
    'census', 'emancipation', 'enslavement', 'labor',
    'migration', 'land_transaction', 'other'
  )),
  event_date text,
  event_date_confidence text default 'unknown',
  place_id uuid references places(id),
  description text,
  document_id uuid references documents(id),
  confidence text check (confidence in ('confirmed', 'likely', 'possible', 'speculative')) default 'possible',
  notes text,
  created_at timestamptz default now()
);

create table hypotheses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  hypothesis_type text check (hypothesis_type in (
    'identity_match', 'parent_child', 'spouse', 'location',
    'plantation_tie', 'document_match', 'other'
  )),
  status text check (status in ('open', 'confirmed', 'likely', 'possible', 'disproven')) default 'open',
  people_involved uuid[],
  documents_involved uuid[],
  next_steps text,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table research_tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  status text check (status in ('todo', 'in_progress', 'done', 'blocked')) default 'todo',
  priority text check (priority in ('high', 'medium', 'low')) default 'medium',
  related_person_id uuid references people(id),
  related_document_id uuid references documents(id),
  due_date date,
  notes text,
  created_at timestamptz default now()
);

alter table people enable row level security;
alter table relationships enable row level security;
alter table documents enable row level security;
alter table document_people enable row level security;
alter table events enable row level security;
alter table places enable row level security;
alter table hypotheses enable row level security;
alter table research_tasks enable row level security;

do $$
declare t text;
begin
  foreach t in array array['people', 'relationships', 'documents', 'document_people', 'events', 'places', 'hypotheses', 'research_tasks']
  loop
    execute format('create policy "auth_all" on %I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

create index on people (last_name_paternal);
create index on people (last_name_maternal);
create index on events (person_id);
create index on events (event_type);
create index on document_people (document_id);
create index on document_people (person_id);
create index on relationships (person_a_id);
create index on relationships (person_b_id);
