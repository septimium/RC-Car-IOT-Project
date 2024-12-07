from machine import Pin, PWM
import network
import socket
from time import sleep

led = machine.Pin("LED", machine.Pin.OUT)
led.off()
# Motor pins
buzz = Pin(16, Pin.OUT)
buzz.high()
in1 = Pin(0, Pin.OUT) 
in2 = Pin(1, Pin.OUT) 
enb1 = PWM(Pin(6)) 
enb1.freq(1500) 
in3 = Pin(2, Pin.OUT) 
in4 = Pin(3, Pin.OUT)
enb2 = PWM(Pin(8)) 
enb2.freq(1500) 

# Motor functions
def motor1_stop():
    in1.low()  # Stop motor
    in2.low()  # Stop motor
    enb1.duty_u16(0)  # Disable motor (set PWM duty cycle to 0)

def motor1_forward(speed):
    in1.low()  # Set IN3 high
    in2.high()   # Set IN4 low
    enb1.duty_u16(speed)  # Set motor speed (0-65535 for duty cycle)

def motor1_backward(speed):
    in1.high()  # Set IN3 low
    in2.low()  # Set IN4 high
    enb1.duty_u16(speed)  # Set motor speed (0-65535 for duty cycle)
    
def motor2_stop():
    in3.low()  # Stop motor
    in4.low()  # Stop motor
    enb2.duty_u16(0)  # Disable motor (set PWM duty cycle to 0)

def motor2_forward(speed):
    in3.high()  # Set IN3 high
    in4.low()   # Set IN4 low
    enb2.duty_u16(speed)  # Set motor speed (0-65535 for duty cycle)

def motor2_backward(speed):
    in3.low()  # Set IN3 low
    in4.high()  # Set IN4 high
    enb2.duty_u16(speed)  # Set motor speed (0-65535 for duty cycle)
    
def honk():
    buzz.low()
    
def honkstop():
    buzz.high()

# Wi-Fi Access Point Configuration
ap = network.WLAN(network.AP_IF)
ap.config(essid="MYPICO", password="1234567890")
ap.active(True)

while ap.active() == False:
    pass # Wait for 0.5 seconds (blinking rate)

  # Turn the LED on once connected

# Socket Configuration
s = socket.socket()
s.bind(('0.0.0.0', 1234))
s.listen(1) 

while True:
    s1, remote = s.accept()  # Accept incoming connection
    print(f"Connection from {remote}")
    while True:
        led.on()
        data = s1.readline().strip()

        if data == b'forward':
            motor1_forward(65535)
            motor2_forward(65535)

        elif data == b'reverse':
            motor1_backward(65535)
            motor2_backward(65535)
        
        elif data == b'right':
            motor1_forward(65535)
            motor2_backward(65535)
                
                
        elif data == b'left':
            motor1_backward(65535)
            motor2_forward(65535)
        
        elif data == b'honk':
            honk()
        
        elif data == b'none':
            motor1_stop()
            motor2_stop()
            honkstop()
            