import serial
import os
import sys
import glob

import time # for unix time
import datetime # for file name



# set what log file ending should be. Will be simple file if empty
file_type = ".txt"

# set name of log file to current datetime
log_file_name = str(datetime.datetime.now()) + file_type

# set temp file to name "temp"
temp_file_name = "temp"

# init log file
current_time = datetime.datetime.now()
with open ("logs/" + log_file_name,'w') as file:
    file.write(str(current_time) + ': Python launched. Reminder, this log will only output data stream from ESP, not Godot')

# TESTING open temp file
with open ("temp/" + temp_file_name,'w') as file:
    file.write(" ")

def get_serial_ports():
    """
            Lists serial port names

            :raises EnvironmentError:
                    On unsupported or unknown platforms
            :returns:
                    A list of the serial ports available on the system
    """
    if sys.platform.startswith('win'):
            ports = ['COM%s' % (i + 1) for i in range(256)]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
            # this excludes your current terminal "/dev/tty"
            ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
            ports = glob.glob('/dev/tty.*')
    else:
            raise EnvironmentError('Unsupported platform')

    result = []
    for port in ports:
            try:
                    s = serial.Serial(port)
                    s.close()
                    result.append(port)
            except (OSError, serial.SerialException):
                    pass
    return result

serial_port_index = -1
# autoconnect if possible
serial_ports = get_serial_ports()
for com in range(len(serial_ports)):
    if serial_ports[com] == '/dev/tty.ESP32':
        serial_port_index = com
        print("ESP32 Found! Automatically connecting.")

# if not auto connected, prompt user
if serial_port_index == -1:
    print("Failed to auto connect. Please select ESP32 from com ports:")
    print("Open Serial Ports: " + str(serial_ports))
    serial_port_index = int(input("Enter index of Serial Port: "))


# open serial port at chosen index
ser = serial.Serial(serial_ports[serial_port_index], 115200, timeout=.1)
ser = serial.Serial(serial_ports[serial_port_index], 9600, timeout=.1)
ser = serial.Serial(serial_ports[serial_port_index], 115200, timeout=6)
ser.xonxoff=1


# program loop
running = True
while running:
    ser_data=ser.readline()
    print(ser_data)


# make new text file on launch

# ensure theres a file called "temp" for temp logging, if not make it

# log data in both files when updated. Remove the previous one in "temp". Log with timestamp

# read in godot, seperate data into a list with rsplit then into variables
