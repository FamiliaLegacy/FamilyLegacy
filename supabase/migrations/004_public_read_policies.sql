-- Allow anyone (unauthenticated) to read the core genealogy tables
create policy "public_read" on people    for select to anon using (true);
create policy "public_read" on relationships for select to anon using (true);
create policy "public_read" on events    for select to anon using (true);
create policy "public_read" on places    for select to anon using (true);
create policy "public_read" on ai_contexts for select to anon using (true);
