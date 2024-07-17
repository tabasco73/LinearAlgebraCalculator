import requests
import json

from utility.utility_files import read_prompt

url = "http://127.0.0.1:5000/api/endpoint"
headers = {"Content-Type": "application/json"}
data = {"user_message": read_prompt('Testdata/uppgift1.txt')}

response = requests.post(url, headers=headers, data=json.dumps(data))

print("Status Code:", response.status_code)
print("Response JSON:", response.json())