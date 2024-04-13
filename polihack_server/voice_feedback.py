import json
import re
from sklearn.preprocessing import StandardScaler
import joblib
import numpy as np

from openai import OpenAI
from tone_feedback import extract_pitch_features


def is_monotone(audio_file):
    scaler = StandardScaler()
    model = joblib.load('polihack_server/resources/model/monotone_classifier_model.pkl')

    features = np.array([extract_pitch_features(audio_file)])
    scaled_features = scaler.fit_transform(features.reshape(1, -1))

    prediction = model.predict(features)
    return prediction[0] == 0


class Feedback:
    def __init__(self, tone, stuttering, pauses):
        self.tone = tone
        self.stuttering = stuttering
        self.pauses = pauses


class VoiceAnalyzer:
    def __init__(self):
        self.client = OpenAI()

    def get_feedback(self, audio_file_path):
        try:
            f = open("transcript.txt", "w")
            audio_file = open(audio_file_path, "rb")

            transcript = self.client.audio.transcriptions.create(
                file=audio_file,
                model="whisper-1",
                response_format="verbose_json",
                timestamp_granularities=["word"],
                prompt="Transcribe a public speech, incorporating pauses between words as ellipses '...' to represent "
                       "moments of hesitation or stuttering by the speaker."
            )

            pretty_json = json.dumps(transcript.words, indent=4)
            f.write(pretty_json)

            print(find_pauses(transcript.words))
            print(find_pauses_between_words(transcript.words))

            return transcript.words

        except Exception as e:
            return f"Error occurred: {str(e)}"

        finally:
            f.close()


def find_pauses(words):
    count = 0
    for word_data in words:
        m = re.search(r'\.\.\.', word_data['word'])
        if m is not None:
            count = count + 1
    return count


def find_pauses_between_words(words):
    count = 0
    prev_end = words[0]['end']
    for word_data in words:
        start = word_data['start']
        if start - prev_end > 0.5:
            count = count + 1
        prev_end = word_data['end']
    return count

