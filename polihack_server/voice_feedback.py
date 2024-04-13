import json
import re
from sklearn.preprocessing import StandardScaler
import joblib
import numpy as np

from openai import OpenAI
from tone_feedback import extract_pitch_features


def is_monotone(audio_file_path):
    # scaler = StandardScaler()
    model = joblib.load('polihack_server/resources/model/correct/monotone_classifier_model.pkl')

    audio_file = open(audio_file_path, 'rb')

    features = np.array([extract_pitch_features(audio_file)])
    # scaled_features = scaler.fit_transform(features.reshape(1, -1))

    prediction = model.predict(features)
    audio_file.close()
    return prediction[0] == 0


class Feedback:
    def __init__(self, tone, stuttering, pauses, repeated_words, feedback):
        self.is_monotone = tone
        self.stuttering_value = stuttering
        self.pauses_value = pauses
        self.repeated_words = repeated_words
        self.ai_feedback = feedback


class VoiceAnalyzer:
    def __init__(self):
        self.client = OpenAI()

    def analyze_speech(self, text):
        response = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            max_tokens=100,
            messages=[
                {"role": "system", "content": "Analyze the following text for coherence and explain why it has "
                                              "problems considering it is a public speech(Use only 100 words): " + text}
            ]
        )

        return response.choices[0].message.content.strip()

    def get_feedback(self, audio_file_path):
        try:
            f = open("transcript.txt", "w")
            audio_file = open(audio_file_path, "rb")

            transcript = self.client.audio.transcriptions.create(
                file=audio_file,
                model="whisper-1",
                response_format="verbose_json",
                timestamp_granularities=["word"],
                prompt="Transcribe a public speech but also represent "
                       "moments of hesitation or stuttering by the speaker."
            )

            pretty_json = json.dumps(transcript.words, indent=4)
            f.write(pretty_json)

            print(self.analyze_speech(transcript.text))

            return Feedback(is_monotone(audio_file_path),
                            find_stuttering(transcript.words),
                            find_pauses(transcript.words),
                            find_repeated_words(transcript.words),
                            self.analyze_speech(transcript.text))


        except Exception as e:
            return f"Error occurred: {str(e)}"

        finally:
            f.close()


def find_pauses(words):
    count = 0
    prev_end = words[0]['end']
    for word_data in words:
        start = word_data['start']
        if start - prev_end > 1.7:
            count = count + 1
        prev_end = word_data['end']
    return (count / len(words)) * 100


def find_stuttering(words):
    count = 0
    for word_data in words:
        start = word_data['start']
        end = word_data['end']
        if end - start > 0.5:
            count = count + 1
    return (count / len(words)) * 100


def find_repeated_words(words):
    step = 20
    repeated_words = []
    for i in range(0, len(words)):
        step_list = words[i:i + step]
        word_list = []
        for word in step_list:
            word_list.append(str.lower(word['word']))

        for word in word_list:
            count = word_list.count(word)
            if count > 5:
                if not repeated_words.count(word) > 0:
                    repeated_words.append(word)

    if len(words) % step != 0:
        step_list = words[i:i + step]
        word_list = []
        for word in step_list:
            word_list.append(word['word'])

        for word in word_list:
            count = word_list.count(word)
            if count > 5:
                if not repeated_words.count(word) > 0:
                    repeated_words.append(word)

    return repeated_words
