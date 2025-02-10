from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def hello():
    return render_template('index.html',message="Hello world!")

@app.route('/goodbye')
def goodbye():
    return render_template('index.html',message="Bye for now!")

@app.route('/hello/<name>')
def helloName(name):
    return render_template('name.html',name=name)

if __name__ == '__main__':
    app.run(debug=True)
