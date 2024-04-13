import json
import re
from openai import OpenAI
import soundfile


class VoiceFeedback:
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
                prompt=""
            )

            pretty_json = json.dumps(transcript.words, indent=4)
            f.write(pretty_json)

            print(find_pauses(transcript.words))
            print(find_pauses_between_words(transcript.words))

            analyze_tone(audio_file_path)

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


def analyze_tone(filename):
    audio_samples, sample_rate = soundfile.read(filename, dtype='int16')
    print(audio_samples)
