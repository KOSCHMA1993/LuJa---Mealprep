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
