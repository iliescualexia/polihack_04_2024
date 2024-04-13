import os
import uuid
from flask import Flask, request
from voice_feedback import VoiceAnalyzer, is_monotone


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
            if 'file2' and 'file1' not in request.files:
                return 'No file part'
            audio_file = request.files['file1']
            video_file = request.files['file2']
            if audio_file.filename == '' or video_file.filename == '':
                return 'No selected file'

            print(f"Received audio file: {audio_file.filename}")
            print("Received video file: " + video_file.filename)

            mp4_file_path = convert_video_file(video_file)
            mp3_file_path = convert_audio_file(audio_file)
            if is_monotone(mp3_file_path):
                return 'Voice is boring!'
            else:
                return 'Good job!'

    def run(self):
        self.app.run()


if __name__ == "__main__":
    app = App()
    app.run()
