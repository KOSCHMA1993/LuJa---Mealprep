update public.ingredients set store='Naturgut' where store is null or trim(store)='' or lower(store)='edeka';
update public.ingredients set store='DM' where lower(store)='dm';
update public.shopping_items set store='Naturgut' where store is null or trim(store)='' or lower(store)='edeka';
update public.shopping_items set store='DM' where lower(store)='dm';
