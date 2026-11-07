-- EINMALIG AUSFUEHREN. Vorher unten deine Login-E-Mail eintragen.
do $$
declare
  target_email text := 'DEINE-EMAIL@BEISPIEL.DE';
  uid uuid;
  rid uuid;
begin
  select id into uid from auth.users where lower(email)=lower(target_email);
  if uid is null then raise exception 'Kein Supabase-Benutzer mit E-Mail % gefunden', target_email; end if;

  -- 1 Vegane Bolognese, 4 Portionen
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Vegane Bolognese','Pasta, vegan',40,4,'Zwiebel, Karotte und Sellerie fein würfeln und anbraten. Linsen und Tomaten zugeben, würzen und etwa 25 Minuten köcheln. Mit Spaghetti servieren.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Spaghetti',400,'g','Vorrat','Edeka'),(uid,rid,'Rote Linsen',180,'g','Vorrat','Edeka'),(uid,rid,'Passierte Tomaten',700,'ml','Vorrat','Edeka'),(uid,rid,'Zwiebel',1,'Stück','Gemüse','Edeka'),(uid,rid,'Karotte',2,'Stück','Gemüse','Edeka'),(uid,rid,'Stangensellerie',2,'Stangen','Gemüse','Edeka'),(uid,rid,'Tomatenmark',2,'EL','Vorrat','Edeka'),(uid,rid,'Knoblauch',2,'Zehen','Gemüse','Edeka');

  -- 2 Ragout vom Otto, vorläufig als Pilzragout angelegt
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Ragout vom Otto','Ragout, vegetarisch',45,4,'Pilze kräftig anbraten. Zwiebel und Knoblauch zufügen. Mit Brühe ablöschen, Senf und Sahne einrühren und einkochen lassen. Abschmecken und mit Beilage servieren.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Champignons',500,'g','Gemüse','Edeka'),(uid,rid,'Zwiebel',1,'Stück','Gemüse','Edeka'),(uid,rid,'Knoblauch',1,'Zehe','Gemüse','Edeka'),(uid,rid,'Gemüsebrühe',300,'ml','Vorrat','Edeka'),(uid,rid,'Kochsahne',200,'ml','Kühlung','Edeka'),(uid,rid,'Senf',1,'EL','Vorrat','Edeka'),(uid,rid,'Petersilie',1,'Bund','Gemüse','Edeka');

  -- 3 Quiche
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Gemüse-Quiche','Ofengericht, vegetarisch',60,4,'Teig in eine Quicheform legen. Gemüse kurz anbraten und darauf verteilen. Eier, Sahne und Käse verrühren, würzen und darübergeben. Bei 190 °C etwa 35 Minuten backen.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Quiche- oder Mürbeteig',1,'Packung','Kühlung','Edeka'),(uid,rid,'Lauch',1,'Stange','Gemüse','Edeka'),(uid,rid,'Paprika',1,'Stück','Gemüse','Edeka'),(uid,rid,'Eier',3,'Stück','Kühlung','Edeka'),(uid,rid,'Sahne',200,'ml','Kühlung','Edeka'),(uid,rid,'Geriebener Käse',150,'g','Kühlung','Edeka');

  -- 4 Pizza Margherita
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Pizza Margherita','Pizza, vegetarisch',35,2,'Teig ausrollen, mit Tomatensauce bestreichen und mit Mozzarella belegen. Bei maximaler Ofentemperatur 10 bis 15 Minuten backen. Basilikum danach daraufgeben.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Pizzateig',1,'Packung','Kühlung','Edeka'),(uid,rid,'Passierte Tomaten',200,'ml','Vorrat','Edeka'),(uid,rid,'Mozzarella',2,'Kugeln','Kühlung','Edeka'),(uid,rid,'Basilikum',1,'Bund','Gemüse','Edeka');

  -- 5 Gemüsepizza
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Gemüsepizza','Pizza, vegetarisch',40,2,'Teig ausrollen und mit Tomatensauce bestreichen. Gemüse dünn schneiden, mit Käse verteilen und bei hoher Temperatur knusprig backen.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Pizzateig',1,'Packung','Kühlung','Edeka'),(uid,rid,'Passierte Tomaten',200,'ml','Vorrat','Edeka'),(uid,rid,'Mozzarella',1,'Kugel','Kühlung','Edeka'),(uid,rid,'Paprika',1,'Stück','Gemüse','Edeka'),(uid,rid,'Zucchini',1,'Stück','Gemüse','Edeka'),(uid,rid,'Champignons',150,'g','Gemüse','Edeka');

  -- 6 Reisbowl
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Reisbowl mit Tofu','Bowl, vegan',35,2,'Reis kochen. Tofu würfeln und knusprig anbraten. Gemüse schneiden. Alles in Schalen anrichten und mit Sojasauce und Sesam servieren.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Reis',180,'g','Vorrat','Edeka'),(uid,rid,'Naturtofu',200,'g','Kühlung','Edeka'),(uid,rid,'Avocado',1,'Stück','Gemüse','Edeka'),(uid,rid,'Gurke',0.5,'Stück','Gemüse','Edeka'),(uid,rid,'Karotte',2,'Stück','Gemüse','Edeka'),(uid,rid,'Sojasauce',3,'EL','Vorrat','Edeka'),(uid,rid,'Sesam',1,'EL','Vorrat','Edeka');

  -- 7 Schwarzer Reissalat
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Schwarzer Reissalat','Salat, vegan',45,4,'Schwarzen Reis garen und abkühlen lassen. Gemüse und Mango schneiden. Mit Limettensaft, Öl und Sojasauce vermengen und mit Kräutern abschmecken.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Schwarzer Reis',250,'g','Vorrat','Edeka'),(uid,rid,'Mango',1,'Stück','Obst','Edeka'),(uid,rid,'Paprika',1,'Stück','Gemüse','Edeka'),(uid,rid,'Frühlingszwiebeln',3,'Stück','Gemüse','Edeka'),(uid,rid,'Limette',2,'Stück','Obst','Edeka'),(uid,rid,'Koriander',1,'Bund','Gemüse','Edeka'),(uid,rid,'Sojasauce',2,'EL','Vorrat','Edeka');

  -- 8 Süßkartoffel-Rote-Linsen-Suppe
  insert into public.recipes(user_id,name,category,duration,servings,instructions)
  values(uid,'Süßkartoffel-Rote-Linsen-Suppe','Suppe, vegan',35,4,'Zwiebel anbraten. Süßkartoffel würfeln und mit Linsen, Kokosmilch und Brühe zufügen. Etwa 20 Minuten weich kochen, teilweise oder vollständig pürieren und abschmecken.') returning id into rid;
  insert into public.ingredients(user_id,recipe_id,name,quantity,unit,category,store) values
  (uid,rid,'Süßkartoffel',600,'g','Gemüse','Edeka'),(uid,rid,'Rote Linsen',200,'g','Vorrat','Edeka'),(uid,rid,'Kokosmilch',400,'ml','Vorrat','Edeka'),(uid,rid,'Gemüsebrühe',700,'ml','Vorrat','Edeka'),(uid,rid,'Zwiebel',1,'Stück','Gemüse','Edeka'),(uid,rid,'Ingwer',20,'g','Gemüse','Edeka'),(uid,rid,'Limette',1,'Stück','Obst','Edeka');
end $$;
