# Unser Essensplan – kostenlose PWA mit Supabase

## Enthalten
- Login für zwei Personen
- Rezepte, Foto-Upload und Zutaten
- 14-Tage-Plan
- automatische Einkaufsliste für die kommenden 7 Tage
- Umrechnung nach Portionen und Zusammenfassung gleicher Zutat+Einheit
- manuelle Artikel und Abhaken
- installierbare PWA

## Einrichtung (ca. 20–30 Minuten)
1. Kostenloses Projekt unter https://supabase.com erstellen.
2. Im SQL Editor den kompletten Inhalt von `supabase.sql` ausführen.
3. Authentication → Providers → Email aktiv lassen. Für einen schnellen privaten Test kann „Confirm email“ deaktiviert werden.
4. Project Settings → API öffnen. Project URL und Publishable Key (oder legacy anon Key) kopieren. **Nie service_role verwenden.**
5. Dateien auf einen statischen HTTPS-Host deployen, z. B. GitHub Pages, Cloudflare Pages oder Netlify.
6. Seite öffnen, URL/Key speichern und beide Accounts registrieren.
7. iPhone: Safari → Teilen → Zum Home-Bildschirm. Samsung: Chrome → Menü → App installieren.

## Lokal testen
Service Worker benötigen HTTP(S), nicht `file://`:
```bash
python3 -m http.server 8080
```
Dann `http://localhost:8080` öffnen.

## Wichtiger Sicherheitshinweis
Die mitgelieferten Policies sind ein schnelles privates Zwei-Personen-MVP: jeder angemeldete Account sieht die gemeinsamen App-Daten. Teile den App-Link daher zunächst nur mit deiner Frau und lasse öffentliche Registrierung nicht dauerhaft offen. Für eine öffentliche App sollten `household_id` und Einladungs-Codes konsequent in allen Schreibvorgängen und RLS-Policies erzwungen werden.

## Foto-Scan
Die App speichert Rezeptfotos, liest Beschriftungen aber noch nicht automatisch aus. Kostenlose OCR ist als spätere Erweiterung mit Tesseract.js möglich, erhöht jedoch Ladezeit und Fehleranfälligkeit auf Mobilgeräten.


## Update auf Version 2
1. In Supabase den Inhalt von `migration-v2.sql` einmal im SQL Editor ausführen.
2. Auf GitHub alle Dateien aus diesem Paket hochladen und vorhandene Dateien überschreiben.
3. Nach dem Pages-Deployment die App einmal vollständig neu laden. Auf dem Smartphone bei Bedarf die PWA schließen und erneut öffnen.
4. Zutaten können optional ein fünftes Feld für das Geschäft enthalten: `Menge | Einheit | Zutat | Bereich | Geschäft`.


## Version 3
- Wochenplaneinträge können bearbeitet werden: Datum, Mahlzeit, Rezept, Portionen und freier Eintrag.
- Rezeptbearbeitung aus Version 2 bleibt enthalten.
- Für Version 3 ist keine zusätzliche SQL-Migration erforderlich. Die Datei `migration-v2.sql` muss aber vor dem ersten Einsatz von Version 2/3 einmal ausgeführt worden sein.


## Starter-Rezepte importieren
1. `starter-rezepte.sql` öffnen.
2. In der Zeile `target_email` die E-Mail des bereits registrierten App-Kontos einsetzen.
3. Datei vollständig im Supabase SQL Editor ausführen.
4. App neu laden.
Achtung: Das Skript nur einmal ausführen, sonst entstehen Dubletten.


## Version 5: Bearbeitungsbuttons und Cache-Fix
- Sichtbare Schaltfläche `Eintrag bearbeiten` auf der Seite Woche.
- Sichtbare Schaltfläche `Rezept bearbeiten` auf der Rezeptseite.
- Versionsanzeige `v5` im Kopf der App.
- Aktualisierter Service Worker, damit GitHub-Pages-Updates nicht in der alten PWA-Version hängen bleiben.
- Keine zusätzliche SQL-Migration erforderlich.
