import os
from flask import Flask
from dotenv import load_dotenv

load_dotenv();
app = Flask(__name__)

PORT = os.getenv('PORT')
OTHERs= os.getenv('other name')

print(PORT)
print(__name__)

@app.route("/")
def home():
    return f"Hello, Flask! PORT :{PORT} others: {}"

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True,port=PORT)