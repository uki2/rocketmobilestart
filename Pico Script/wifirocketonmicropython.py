import network
from machine import Pin
import socket
import time

# przypoisanie pinu do zmiennej
led = Pin("LED", Pin.OUT)

relay = Pin(16, Pin.OUT)

relay.value(0)

# ustawianie ledu na wylaczony
led_state = "OFF"
relay_state = "OFF"




# Konfiguracja oraz wlaczenie wifi
ap = network.WLAN(network.AP_IF)
ap.config(essid='UkiWifi', password='Guwno123')
ap.active(True)

# drukowanie adressu ssid
print('Access Point SSID:', ap.config('essid'))
print('IP Address:', ap.ifconfig()[0])

# otwarcie portu 80
def open_socket():
    # gets adress information for the socket, create a socket, bind it, then start listening for any clients trying to connect
    address = socket.getaddrinfo('0.0.0.0', 80)[0][-1]
    s = socket.socket()
    s.bind(address)
    s.listen(1)
    # then we will return this socket so we can use it in our main section
    return (s)

s = open_socket()

# strona 
def web_page():
    if led.value() == 1:
        led_state = "ON"
    else:
        led_state = "OFF"
        
    
    if led.value() == 1:
        relay_state = "ON"
    else:
        relay_state = "OFF"

    html = """<!DOCTYPE HTML>
<html>
    <head>
        <title>Pico W LED Control</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
        <h1>Pico W LED Control</h1>
        <p>LED State: <strong>""" + led_state + """</strong></p>
        <p><a href="/?led=on"><button>Turn ON</button></a></p>
        <p><a href="/?led=off"><button>Turn OFF</button></a></p>
        <p>Relay State: <strong>""" + relay_state + """</strong></p>
        <p><a href="/?relay=on"><button>Turn ON RELAY</button></a></p>
        <p><a href="/?relay=off"><button>Turn OFF RELAY</button></a></p>
    </body>
</html>"""
    return html


# requesty
while True:
    cl, addr = s.accept()
    print('connect with', addr)
    request = cl.recv(1024)
    request = str(request)
    #print('Request:', request) nie potrzebny debug na razie
    led_on = request.find('/?led=on')
    led_off = request.find('/?led=off')
    relay_on = request.find('/?relay=on')
    relay_off = request.find('/?relay=off')
    if led_on == 6:
        print('LED ON')
        led.value(1)
    if led_off == 6:
        print('LED OFF')
        led.value(0)
    #relay on off    
    if relay_on == 6:
        print('LED ON')
        relay.value(1) #zmien tooo
    if relay_off == 6:
        print('LED OFF')
        relay.value(0)  #zmien tooo2321321321
    response = web_page()
    cl.send('HTTP/1.0 200 OK\r\nContent-type: text/html\r\n\r\n')
    cl.send(response)
    cl.close()
