-- Komplett im Supabase SQL Editor ausführen.
create extension if not exists pgcrypto;
create table public.households (id uuid primary key default gen_random_uuid(), name text not null, invite_code text unique not null default upper(substr(md5(random()::text),1,8)), created_by uuid not null references auth.users(id), created_at timestamptz default now());
create table public.household_members (household_id uuid references public.households on delete cascade, user_id uuid references auth.users on delete cascade, primary key(household_id,user_id));
create or replace function public.my_household_ids() returns setof uuid language sql security definer stable set search_path=public as $$ select household_id from household_members where user_id=auth.uid() $$;
create table public.recipes (id uuid primary key default gen_random_uuid(), household_id uuid references households on delete cascade, user_id uuid not null references auth.users(id), name text not null, category text, duration int, servings numeric not null default 2, instructions text, image_url text, created_at timestamptz default now());
create table public.ingredients (id uuid primary key default gen_random_uuid(), household_id uuid references households on delete cascade, user_id uuid not null references auth.users(id), recipe_id uuid not null references recipes on delete cascade, name text not null, quantity numeric, unit text, category text default 'Sonstiges', store text default 'Edeka');
create table public.meal_plan (id uuid primary key default gen_random_uuid(), household_id uuid references households on delete cascade, user_id uuid not null references auth.users(id), date date not null, slot text not null default 'Abendessen', recipe_id uuid references recipes on delete set null, servings numeric not null default 2, free_text text, created_at timestamptz default now());
create table public.shopping_items (id uuid primary key default gen_random_uuid(), household_id uuid references households on delete cascade, user_id uuid not null references auth.users(id), name text not null, quantity numeric, unit text, category text default 'Sonstiges', done boolean default false, manual boolean default true, store text default 'Edeka', created_at timestamptz default now());
-- Für das Zwei-Personen-MVP: beide Accounts sehen zunächst Datensätze beider eingeloggter Nutzer.
-- Vor echter öffentlicher Nutzung household_id erzwingen und Policies auf my_household_ids() einschränken.
alter table recipes enable row level security;alter table ingredients enable row level security;alter table meal_plan enable row level security;alter table shopping_items enable row level security;
create policy "authenticated recipes" on recipes for all to authenticated using (true) with check (auth.uid()=user_id);
create policy "authenticated ingredients" on ingredients for all to authenticated using (true) with check (auth.uid()=user_id);
create policy "authenticated meals" on meal_plan for all to authenticated using (true) with check (auth.uid()=user_id);
create policy "authenticated shopping" on shopping_items for all to authenticated using (true) with check (auth.uid()=user_id);
insert into storage.buckets(id,name,public) values('recipe-images','recipe-images',true) on conflict do nothing;
create policy "public images" on storage.objects for select using(bucket_id='recipe-images');
create policy "auth upload images" on storage.objects for insert to authenticated with check(bucket_id='recipe-images');
create policy "owner delete images" on storage.objects for delete to authenticated using(bucket_id='recipe-images' and owner_id=auth.uid()::text);