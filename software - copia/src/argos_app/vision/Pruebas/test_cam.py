import cv2

cap = cv2.VideoCapture(0)

ret, frame = cap.read()

if ret:
    cv2.imwrite("prueba.jpg", frame)
    print("Imagen capturada correctamente")
else:
    print("No se pudo capturar imagen")

cap.release()
