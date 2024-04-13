from voice_feedback import VoiceFeedback
from flask import Flask, redirect, url_for


class App:
    def __init__(self):
        self.voice = VoiceFeedback()
        self.app = Flask(__name__)

        @self.app.route('/speech/<number>')
        def set_voice(number):
            speech = "resources/speech{}.mp3".format(number)
            return self.voice.get_feedback(speech)

    def run(self):
        self.app.run()


if __name__ == "__main__":
    app = App()
    app.run()
