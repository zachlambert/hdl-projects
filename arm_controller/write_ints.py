#!/home/zach/.conda/envs/scientific/bin/python
import serial, time
import numpy as np

ser = serial.Serial("/dev/ttyUSB0", 9600, timeout=0.5)

angles = np.array([127., 127., 127.])
vel = np.array([0., 0., 0.])
acc = np.array([400., 400., 400.])

max_vel = 120
max_angle = 255

def write_angles():
    # print(angles)
    for i in range(3):
        ser.write(bytes([i]))
        print(bytes([int(angles[i])]))
        ser.write(bytes([int(angles[i])]))

def update_position(direction, dt):
    global vel, angles
    vel += dt * acc * direction
    for i in range(3):
        if vel[i] > max_vel:
            vel[i] = max_vel
        elif vel[i] < -max_vel:
            vel[i] = -max_vel
    angles += dt * vel
    for i in range(3):
        if angles[i] > max_angle:
            angles[i] = max_angle
        elif angles[i] < -max_angle:
            angles[i] = -max_angle

direction = 1
prev_time = time.time()
switch_time = 2
timer = switch_time/2

while (1):
    current_time = time.time()
    dt = current_time - prev_time
    prev_time = current_time
    update_position(direction, dt)
    write_angles()
    timer += dt
    if timer > switch_time:
        direction *= -1
        timer = 0
    time.sleep(0.005)
