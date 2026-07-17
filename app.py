"""
Lokale Whisper Transcriber - eenvoudige webinterface.

Start dit met start.bat (Windows) en open http://127.0.0.1:5000 in de browser.
Alles draait lokaal op deze computer, er wordt niets naar internet verstuurd
(behalve eenmalig het downloaden van het gekozen AI-model).
"""
import os
import tempfile
import traceback

from flask import Flask, render_template, request, jsonify, send_file
from faster_whisper import WhisperModel

app = Flask(__name__)

# Modellen worden pas geladen als ze voor het eerst gebruikt worden,
# en blijven daarna in het geheugen zodat de volgende transcriptie sneller start.
_loaded_models = {}

MODEL_INFO = {
    "tiny":            {"label": "Tiny - erg snel, minder nauwkeurig"},
    "base":            {"label": "Base - snel, goede standaardkeuze"},
    "small":           {"label": "Small - nauwkeuriger, wat langzamer"},
    "medium":          {"label": "Medium - zeer nauwkeurig, traag zonder videokaart"},
    "distil-large-v3": {"label": "Turbo (large-v3) - snel en zeer nauwkeurig"},
}


def get_model(name):
    if name not in MODEL_INFO:
        name = "base"
    if name not in _loaded_models:
        # compute_type="int8" is duidelijk sneller op een CPU zonder videokaart,
        # met nagenoeg gelijke nauwkeurigheid.
        _loaded_models[name] = WhisperModel(name, device="cpu", compute_type="int8")
    return _loaded_models[name]


@app.route("/")
def index():
    return render_template("index.html", models=MODEL_INFO)


@app.route("/transcribe", methods=["POST"])
def transcribe():
    if "audio" not in request.files:
        return jsonify({"error": "Geen bestand ontvangen."}), 400

    audio_file = request.files["audio"]
    model_name = request.form.get("model", "base")
    language = request.form.get("language", "") or None  # leeg = automatisch detecteren

    suffix = os.path.splitext(audio_file.filename)[1] or ".audio"
    tmp_path = None
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            audio_file.save(tmp.name)
            tmp_path = tmp.name

        model = get_model(model_name)
        segments, info = model.transcribe(tmp_path, language=language)
        segments = list(segments)  # faster-whisper geeft een generator terug

        return jsonify({
            "text": " ".join(s.text.strip() for s in segments).strip(),
            "language": info.language,
            "segments": [
                {"start": s.start, "end": s.end, "text": s.text.strip()}
                for s in segments
            ],
        })
    except Exception as exc:
        traceback.print_exc()
        return jsonify({"error": f"Er ging iets mis tijdens het transcriberen: {exc}"}), 500
    finally:
        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)


if __name__ == "__main__":
    print("=" * 60)
    print(" Whisper Transcriber start op http://127.0.0.1:5000")
    print(" Laat dit venster open staan zolang je de app gebruikt.")
    print("=" * 60)
    app.run(host="127.0.0.1", port=5000, debug=False)
