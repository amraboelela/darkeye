import requests
import json

proxies = {
    'http': 'socks5h://127.0.0.1:9050',
    'https': 'socks5h://127.0.0.1:9050'
}

#data = requests.get("http://altaddresswcxlld.onion",proxies=proxies).text
#link = "http://altaddresswcxlld.onion"

link = "http://zqktlwiuavvvqqt4ybvgvi7tyo4hjl5xgfuvpdf6otjiycgwqbym2qad.onion/wiki/Main_Page"
#link = "http://zqktlwiuavvvqqt4ybvgvi7tyo4hjl5xgfuvpdf6otjiycgwqbym2qad.onion"
#link = "http://haneinhodfxcjcnsm6efuyzdffcrejd7jmstte7hwdvhf67x6okyb2ad.onion/"
#link = "http://mf34jlghauz5pxjcmdymdqbe5pva4v24logeys446tdrgd5lpsrocmqd.onion"
data = requests.get(link, proxies=proxies).text

print(data)

