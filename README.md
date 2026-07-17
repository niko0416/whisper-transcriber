# 🎙️ Whisper Transcriber

Een simpele, lokale webinterface om audio en video automatisch om te zetten
naar tekst, gebouwd op [OpenAI Whisper](https://github.com/openai/whisper).
Alles draait **op je eigen computer** — er wordt niets naar internet
verstuurd, behalve eenmalig het downloaden van het gekozen AI-model.

---

## Voor de niet-technische gebruiker: installeren in 3 stappen

1. Download deze repository (groene knop **Code → Download ZIP** hierboven,
   of vraag iemand om `git clone` te doen) en pak de ZIP uit op een plek
   naar keuze (bijv. `Documenten\WhisperTranscriber`).
2. Dubbelklik op **`install.bat`**. Dit installeert eenmalig alles wat nodig
   is (kan een paar minuten duren, er is internet nodig).
3. Na installatie staat er een snelkoppeling **"Whisper Transcriber"** op je
   bureaublad. Dubbelklik daarop om de app te starten — je browser opent
   automatisch.

Dat is het! Voortaan hoef je alleen nog die snelkoppeling te gebruiken.

### De app op je taakbalk zetten

Windows staat niet toe dat een installatiescript automatisch iets aan je
taakbalk vastpint (dat mag je zelf beslissen). Het kost je 10 seconden:

1. Start de app via de snelkoppeling op je bureaublad.
2. Rechtsklik op het icoon dat verschijnt in de taakbalk onderin.
3. Kies **"Aan taakbalk vastmaken"** (*Pin to taskbar*).

Klaar — voortaan start je de app met één klik vanaf de taakbalk.

### Gebruiken

1. Sleep een audio- of videobestand in het vak, of klik erop om een bestand
   te kiezen.
2. Kies een model en eventueel de taal (of laat op "Automatisch herkennen"
   staan).
3. Klik op **Start transcriptie** en wacht tot de tekst verschijnt.
4. Kopieer de tekst, of download hem als `.txt` of als ondertiteling
   (`.srt`).

Het eerste gebruik van een nieuw model duurt iets langer, omdat het model dan
eenmalig gedownload wordt (paar honderd MB tot een paar GB, afhankelijk van
het model). Daarna staat het lokaal opgeslagen en gaat het meteen snel.

---

## Welk model kiezen?

Je kan bovenin de interface wisselen van model. Grofweg geldt: **groter
model = nauwkeuriger, maar trager**. Op een computer zonder aparte
videokaart (GPU) — zoals een standaard Lenovo all-in-one — draait alles op
de processor (CPU), en dat is de belangrijkste beperkende factor.

| Model | Grootte | Nauwkeurigheid | Snelheid op CPU | Advies |
|---|---|---|---|---|
| **tiny** | ~75 MB | Basaal | Zeer snel | Snel een ruwe tekst nodig? Prima. |
| **base** | ~145 MB | Goed | Snel | **Aanbevolen standaard** voor een computer zonder GPU. |
| **small** | ~490 MB | Beter | Redelijk | Duidelijk nauwkeuriger, kost wat meer geduld — goede keuze voor belangrijke opnames. |
| **medium** | ~1,5 GB | Zeer goed | Traag | Kan op CPU merkbaar lang duren (soms trager dan de opname zelf). Alleen voor korte, belangrijke fragmenten. |
| **turbo** (large-v3) | ~1,6 GB | Uitstekend | Matig | Nieuwste model van OpenAI: bijna zo goed als het allergrootste model, maar een stuk sneller. Beste keuze als *small* niet goed genoeg is. |

**Advies voor een standaard Lenovo desktop/all-in-one zonder losse
videokaart:** gebruik **base** als dagelijkse standaard, en schakel naar
**small** of **turbo** wanneer de kwaliteit echt belangrijk is en je iets
langer wil wachten. **Medium** en het volledige **large** model zijn zonder
videokaart vaak onpraktisch traag voor langere opnames — die zijn pas echt
fijn te gebruiken met een NVIDIA-GPU erbij.

Alle modellen ondersteunen meerdere talen, waaronder Nederlands.

---

## Voor de technisch onderlegde collega (updaten / meewerken)

```
git clone <url-van-deze-repo>
cd whisper-transcriber
install.bat      # eenmalig, of handmatig: python -m venv venv && venv\Scripts\pip install -r requirements.txt
start.bat        # app starten
```

De app is gebouwd op:
- [Flask](https://flask.palletsprojects.com/) — lichte webserver
- [openai-whisper](https://github.com/openai/whisper) — het spraakherkenningsmodel (MIT-licentie, © OpenAI)
- [imageio-ffmpeg](https://github.com/imageio/imageio-ffmpeg) — levert ffmpeg mee zodat er niets apart geïnstalleerd hoeft te worden

Alle code in `app.py` en `templates/index.html` mag vrij aangepast worden.
