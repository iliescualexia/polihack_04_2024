import os

import aubio
import joblib
import librosa
import numpy as np
import soundfile as sf
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split, cross_val_score, StratifiedKFold
from sklearn.preprocessing import StandardScaler


def extract_pitch_features(audio_file):
    y, sr = librosa.load(audio_file)

    noise_estimated = np.abs(librosa.stft(y)) ** 2

    clean_signal = librosa.istft(librosa.stft(y) - noise_estimated)

    try:
        sf.write('polihack_server/resources/clean_sound/clean.wav', clean_signal, sr)
        print("Denoised audio saved successfully")
    except Exception as e:
        print("Error occurred while saving denoised audio:", e)

    y_clean, sr_clean = librosa.load('polihack_server/resources/clean_sound/clean.wav')

    hop_size = 512
    pitch_tracker = aubio.pitch("yin", hop_size, hop_size, sr_clean)

    pitch_values = []

    for i in range(0, len(y_clean), hop_size):
        frame = y_clean[i:i + hop_size]

        pitch = pitch_tracker(frame)[0]
        pitch_values.append(pitch)

    pitch_values = np.array(pitch_values)

    mean_pitch = np.mean(pitch_values)
    std_pitch = np.std(pitch_values)
    max_pitch = np.max(pitch_values)
    min_pitch = np.min(pitch_values)

    return [mean_pitch, std_pitch, max_pitch, min_pitch]


monotone_dir = 'polihack_server/resources/monotone_samples'
varied_dir = 'polihack_server/resources/varied_tones_samples'

monotone_files = [os.path.join(monotone_dir, file) for file in os.listdir(monotone_dir) if file.endswith('.mp3')]
features_monotone = [extract_pitch_features(file) for file in monotone_files]
labels_monotone = [0] * len(features_monotone)

varied_files = [os.path.join(varied_dir, file) for file in os.listdir(varied_dir) if file.endswith('.mp3')]
features_varied = [extract_pitch_features(file) for file in varied_files]
labels_varied = [1] * len(features_varied)

X = np.vstack([features_monotone, features_varied])
y = np.hstack([labels_monotone, labels_varied])

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

clf = RandomForestClassifier(random_state=42)
clf.fit(X_train, y_train)

cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

scores = cross_val_score(clf, X, y, cv=cv, scoring='accuracy')
print("Mean Accuracy:", scores.mean())
print("Standard Deviation of Accuracy:", scores.std())

y_pred_test = clf.predict(X_test)
accuracy_test = accuracy_score(y_test, y_pred_test)
print("Accuracy on the test set:", accuracy_test)

joblib.dump(clf, 'polihack_server/resources/model/monotone_classifier_model.pkl')
