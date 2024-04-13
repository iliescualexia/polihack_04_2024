import cv2
import mediapipe as mp
import math


def get_posture_feedback(video_file):
    global ret, frame, distance

    mp_pose = mp.solutions.pose
    pose = mp_pose.Pose(static_image_mode=False, min_detection_confidence=0.5, min_tracking_confidence=0.5)
    mp_drawing = mp.solutions.drawing_utils

    cap = cv2.VideoCapture(video_file)
    # cap = cv2.VideoCapture(0)

    bad_posture_frames = 0
    total_frames = 0
    shoulder_y_threshold = 0.08
    max_distance = 0

    ret, frame = cap.read()
    if ret:
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        results = pose.process(frame_rgb)

        if results.pose_landmarks is not None:
            landmarks = results.pose_landmarks.landmark

            left_shoulder = (landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,
                             landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y)
            right_shoulder = (landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,
                              landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y)

            left_hip = (landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,
                        landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y)
            right_hip = (landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,
                         landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y)

            distance_left = math.sqrt((left_shoulder[0] - left_hip[0]) ** 2 + (left_shoulder[1] - left_hip[1]) ** 2)
            distance_right = math.sqrt(
                (right_shoulder[0] - right_hip[0]) ** 2 + (right_shoulder[1] - right_hip[1]) ** 2)

            max_distance = max(distance_right, distance_left)

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        results = pose.process(frame_rgb)

        if results.pose_landmarks is not None:
            landmarks = results.pose_landmarks.landmark

            left_shoulder = (landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,
                             landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y)
            right_shoulder = (landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,
                              landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y)

            left_hip = (landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,
                        landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y)
            right_hip = (landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,
                         landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y)

            distance_left = math.sqrt((left_shoulder[0] - left_hip[0]) ** 2 + (left_shoulder[1] - left_hip[1]) ** 2)
            distance_right = math.sqrt(
                (right_shoulder[0] - right_hip[0]) ** 2 + (right_shoulder[1] - right_hip[1]) ** 2)

            distance = max(distance_right, distance_left)
            max_distance = max(distance, max_distance)

            if distance < max_distance - 0.3:
                bad_posture_frames += 1

            if abs(left_shoulder[1] - right_shoulder[1]) > shoulder_y_threshold:
                bad_posture_frames += 1

            mp_drawing.draw_landmarks(frame, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)
            total_frames += 1

    percentage_bad_posture = (bad_posture_frames / total_frames) * 100
    print(f"Percentage of bad posture: {percentage_bad_posture:.2f}%")
    cap.release()
    cv2.destroyAllWindows()

    return percentage_bad_posture
