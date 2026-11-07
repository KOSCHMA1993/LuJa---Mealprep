-- V2-Migration einmal im Supabase SQL Editor ausführen
alter table public.ingredients add column if not exists store text default 'Edeka';
alter table public.shopping_items add column if not exists store text default 'Edeka';

-- Bestehende Storage-Policies sauber neu anlegen
drop policy if exists "public images" on storage.objects;
drop policy if exists "auth upload images" on storage.objects;
drop policy if exists "owner update images" on storage.objects;
drop policy if exists "owner delete images" on storage.objects;
create policy "public images" on storage.objects for select using (bucket_id='recipe-images');
create policy "auth upload images" on storage.objects for insert to authenticated with check (bucket_id='recipe-images');
create policy "owner update images" on storage.objects for update to authenticated using (bucket_id='recipe-images' and owner_id=auth.uid()::text);
create policy "owner delete images" on storage.objects for delete to authenticated using (bucket_id='recipe-images' and owner_id=auth.uid()::text);
