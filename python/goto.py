import requests
link = "http://zqktlwiuavvvqqt4ybvgvi7tyo4hjl5xgfuvpdf6otjiycgwqbym2qad.onion"
resp = requests.get(link, 
        proxies=dict(http='socks5://127.0.0.1:9050',
            https='socks5://127.0.0.1:9050'))
print(resp.text)
