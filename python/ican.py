import requests

proxies = {
    'http': 'socks5h://127.0.0.1:9150',
    'https': 'socks5h://127.0.0.1:9150'
}

url = 'http://icanhazip.com'
#url = 'http://hanein.news'
#url = 'http://github.com'

# request without Tor (original IP)
#r = requests.get(url)
#print(r.text)
#exit()
# request with Tor (Tor IP)
r = requests.get(url, proxies=proxies)
print(r.text)

# Force change IP
from stem.control import Controller
from stem import Signal

with Controller.from_port(port = 9151) as controller:
    controller.authenticate('we@kT@r')  
    controller.signal(Signal.NEWNYM) 

# Changed Tor IP
r = requests.get(url, proxies=proxies)
print(r.text)
