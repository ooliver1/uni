from flask import Flask, render_template

app = Flask(__name__)

technologies = [
    { "name": "HTML", "taught": "Autumn semester", "description": "HTML is the standard markup language for creating Web pages." },
    { "name": "CSS", "taught": "Autumn semester", "description": "CSS is a language that describes the style of an HTML document." },
    { "name": "JavaScript", "taught": "Spring semester", "description": "JavaScript is the programming language of HTML and the Web because it runs in all modern browsers." },
    { "name": "Python/Flask", "taught": "Spring semester", "description": "Flask is a popular server side framework for writing web applications in Python." },
    { "name": "SQL", "taught": "Spring semester", "description": "SQL is a standard language for storing, manipulating and retrieving data in databases." },
    { "name": "Perl", "taught": "Aaaaaah please no!", "description": "What is this, 1999?" }
]

@app.route('/')
def galleryPage():
    return render_template('index.html',technologies = technologies)

@app.route('/tech/<int:techId>')
def singleProductPage(techId):
    return render_template('SingleTech.html', technology = technologies[techId])

if __name__ == '__main__':
    app.run(debug=True)
