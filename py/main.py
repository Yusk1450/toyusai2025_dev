from pythonosc import udp_client
from pythonosc.osc_message_builder import OscMessageBuilder
import requests

# 誘導灯のIPアドレスリスト
lightIPAddress = [
    "192.168.0.207",
    "192.168.0.208",
    "192.168.0.209",
    "192.168.0.210",
    "192.168.0.211",
    "192.168.0.212"
]

# マジックミラー用のIPアドレスリスト
resetIPAddress = [
    "192.168.0.205",
    "192.168.0.206"
]

PORT = 33333

for ip in lightIPAddress:
    # UDPのクライアントを作る
    client = udp_client.UDPClient(ip, PORT)
    
    # /light_offに送信するメッセージを作って送信する
    msg = OscMessageBuilder(address='/light_off')
    m = msg.build()
    
    client.send(m)
    print(f"Sent /light_off to {ip}")

for ip in resetIPAddress:
    # UDPのクライアントを作る
    client = udp_client.UDPClient(ip, PORT)
    
    # /resetに送信するメッセージを作って送信する
    msg = OscMessageBuilder(address='/reset')
    m = msg.build()
    
    client.send(m)
    print(f"Sent /reset to {ip}")


requests.get("http://192.168.0.199:8888/server/reset")