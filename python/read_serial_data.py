import serial
import os
import sys
import glob

import time # for unix time
import datetime # for file name



# set what log file ending should be. Will be simple file if empty
file_type = ".txt"

# set name of log file to current datetime
log_file_name = str(time.time()) + file_type

# set temp file to name "temp"
temp_file_name = "temp"

# init log file
current_time = datetime.datetime.now()
with open ("logs/" + log_file_name,'w') as file:
    file.write(str(current_time) + ': Python launched. Reminder, this log will only output data stream from ESP, not Godot\n')

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
ser = serial.Serial(serial_ports[serial_port_index], 115200, timeout=6)
ser.xonxoff=1


# program loop
running = True
while running:
    # read newest serial data line, decode bytes and remove newline
    ser_data=ser.readline().decode().rstrip()

    # log formatted serial data
    log_format_ser = str(datetime.datetime.now()) +": " + ser_data

    # print timestamp and serial data
    print(log_format_ser)

    # append data to permanent log
    with open ("logs/" + log_file_name,'a') as file:
        file.write(log_format_ser + '\n')

    # format data seperated by commas to tempfile. <time>,<battery>,<led1>,<led2>,<time solenoid open>
    ser_data_list = []
    ser_data_list.append(str(round(time.time())))
    ser_data_list += ser_data.split()

    temp_string = ""
    ser_data_list_length = len(ser_data_list)
    for i in range(ser_data_list_length):
        if i != ser_data_list_length - 1:
            temp_string += ser_data_list[i] + ","
        else:
            temp_string += ser_data_list[i]

    # write data seperated by commas to temp file
    with open ("temp/" + temp_file_name,'w') as file:
        file.write(temp_string)
