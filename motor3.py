import time
import ev3dev2.motor as motor
import math

for vol in range(-100, 101, 20):
    f = open('out{}.csv'.format(vol), 'w+')
    motor_a = motor.LargeMotor(motor.OUTPUT_B)
    startTime = time.time()
    while (True):
        currentTime = time.time() - startTime
        motor_pose = motor_a.position
        motor_vel = motor_a.speed
        motor_a.run_direct(duty_cycle_sp = vol)

        f.write('{}, {}, {}\n'.format(currentTime, motor_pose, motor_vel))

        if currentTime > 1:
            motor_a.run_direct(duty_cycle_sp = 0)
            break

    motor_a.stop()
    time.sleep(3)
f.close()