import cv2
import mediapipe as mp
import numpy as np
import time

# ----------------------------
# Setup
# ----------------------------
mp_hands = mp.solutions.hands
mp_draw = mp.solutions.drawing_utils

hands = mp_hands.Hands(
    max_num_hands=1,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.7
)

cap = cv2.VideoCapture(0)

canvas = None
prev_x, prev_y = 0, 0
brush_thickness = 5
eraser_thickness = 40

# ----------------------------
# Helper functions
# ----------------------------
def fingers_up(hand_landmarks):
    """
    Returns a list of 5 values indicating whether each finger is up:
    [thumb, index, middle, ring, pinky]
    """
    landmarks = hand_landmarks.landmark

    fingers = []

    # Thumb (simple x-based check; works for many front-facing webcam cases)
    if landmarks[4].x < landmarks[3].x:
        fingers.append(1)
    else:
        fingers.append(0)

    # Other fingers: tip y < pip y means finger is up
    tip_ids = [8, 12, 16, 20]
    pip_ids = [6, 10, 14, 18]

    for tip_id, pip_id in zip(tip_ids, pip_ids):
        if landmarks[tip_id].y < landmarks[pip_id].y:
            fingers.append(1)
        else:
            fingers.append(0)

    return fingers


def save_canvas(canvas_img):
    filename = f"air_writing_{int(time.time())}.png"
    cv2.imwrite(filename, canvas_img)
    return filename


# ----------------------------
# Main loop
# ----------------------------
while True:
    success, frame = cap.read()
    if not success:
        print("Could not read from webcam.")
        break

    frame = cv2.flip(frame, 1)
    h, w, _ = frame.shape

    if canvas is None:
        canvas = np.zeros_like(frame)

    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = hands.process(rgb)

    mode = "Idle"

    if result.multi_hand_landmarks:
        for hand_landmarks in result.multi_hand_landmarks:
            mp_draw.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

            landmarks = hand_landmarks.landmark
            finger_states = fingers_up(hand_landmarks)

            # Index fingertip
            x = int(landmarks[8].x * w)
            y = int(landmarks[8].y * h)

            # Draw fingertip marker
            cv2.circle(frame, (x, y), 8, (0, 255, 0), -1)

            # Mode 1: Draw when only index finger is up
            if finger_states[1] == 1 and finger_states[2] == 0:
                mode = "Draw"

                if prev_x == 0 and prev_y == 0:
                    prev_x, prev_y = x, y

                cv2.line(canvas, (prev_x, prev_y), (x, y), (255, 0, 0), brush_thickness)
                prev_x, prev_y = x, y

            # Mode 2: Erase when index + middle are up
            elif finger_states[1] == 1 and finger_states[2] == 1:
                mode = "Erase"
                cv2.circle(frame, (x, y), 20, (0, 0, 255), 2)
                cv2.line(canvas, (x, y), (x, y), (0, 0, 0), eraser_thickness)
                prev_x, prev_y = 0, 0

            # Otherwise idle
            else:
                mode = "Idle"
                prev_x, prev_y = 0, 0
    else:
        prev_x, prev_y = 0, 0

    # Merge frame and canvas
    output = cv2.addWeighted(frame, 0.7, canvas, 0.3, 0)

    # Instructions
    cv2.putText(output, f"Mode: {mode}", (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 255), 2)
    cv2.putText(output, "Index up = Draw", (10, 65),
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)
    cv2.putText(output, "Index + Middle = Erase", (10, 95),
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)
    cv2.putText(output, "Press c = Clear | s = Save | q = Quit", (10, 125),
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)

    cv2.imshow("Air Writing", output)

    key = cv2.waitKey(1) & 0xFF

    if key == ord('c'):
        canvas = np.zeros_like(frame)
        print("Canvas cleared.")
    elif key == ord('s'):
        filename = save_canvas(canvas)
        print(f"Saved as {filename}")
    elif key == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()