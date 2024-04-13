import os
import logging
import os
import uuid

from flask import Flask, request, jsonify

from polihack_server.body_pose import get_posture_feedback
from voice_feedback import VoiceAnalyzer

logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')

file_handler = logging.FileHandler('logs.log')
file_handler.setLevel(logging.INFO)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)

logger = logging.getLogger('')
logger.addHandler(file_handler)
logger.addHandler(console_handler)

def convert_audio_file(audio_file):
    filename = audio_file.filename
    file_path = os.path.join("polihack_server/resources/received_data", filename)
    audio_file.save(file_path)
    random_id = uuid.uuid4()
    mp3_file_path = os.path.splitext(file_path)[0] + str(random_id) + '.mp3'
    os.system(f"ffmpeg -i {file_path} {mp3_file_path}")
    return mp3_file_path

def convert_video_file(video_file):
    filename = video_file.filename
    file_path = os.path.join("polihack_server/resources/received_data", filename)
    video_file.save(file_path)
    random_id = uuid.uuid4()
    mp4_file_path = os.path.splitext(file_path)[0] + str(random_id) + '.mp4'
    os.system(f"ffmpeg -i {file_path} {mp4_file_path}")
    return mp4_file_path


class App:
    def __init__(self):
        self.voice = VoiceAnalyzer()
        self.app = Flask(__name__)

        @self.app.route('/speech/<number>')
        def set_voice(number):
            speech = "polihack_server/resources/speech{}.mp3".format(number)
            return self.voice.get_feedback(speech)

        @self.app.route('/upload', methods=['POST'])
        def upload_file():
            if 'file1' not in request.files:
                jsonify({'error': 'No file part'})

            audio_file = request.files['file1']
            video_file = request.files['file2']
            if audio_file.filename == '' or video_file.filename == '':
                return 'No selected file'

            print(f"Received audio file: {audio_file.filename}")
            print("Received video file: " + video_file.filename)

            mp4_file_path = convert_video_file(video_file)
            mp3_file_path = convert_audio_file(audio_file)

            audio_response = self.voice.get_feedback(mp3_file_path)
            video_response = get_posture_feedback(mp4_file_path)

            serialized_response = {
                'is_monotone': 'true' if audio_response.is_monotone else 'false',
                'pauses_value': audio_response.pauses_value,
                'stuttering_value': audio_response.stuttering_value,
                'repeated_words': [] if audio_response.repeated_words is None else audio_response.repeated_words,
                'ai_feedback': audio_response.ai_feedback,
                'bad_posture': video_response
            }

            return jsonify(serialized_response)

    def run(self):
        self.app.run()


if __name__ == "__main__":
    app = App()
    app.run()
