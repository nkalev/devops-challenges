from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World from Docker'

@app.route('/api')
def rest_hello_world():
    return '{"id":1,"message":"Hello World from Docker"}'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
