#!/usr/bin/env python3
from typing import Literal
import cgi
import cgitb
import datetime

cgitb.enable()

form = cgi.FieldStorage()
year = form.getvalue("year", datetime.datetime.now().year)
format = form.getvalue("format", "verbose")


with open("../C1102/part-2/index.html", "r") as f:
    html = f.read()


def get_easter(year):
    a = year % 19
    b = year // 100
    c = year % 100
    d = b // 4
    e = b % 4
    f = (b + 8) // 25
    g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30
    i = c // 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) // 451
    month = (h + l - 7 * m + 114) // 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    return datetime.datetime(year, month, day)


def format_date(date: datetime.datetime, format: str) -> str:
    if format == "numerical":
        return date.strftime("%d/%m/%Y")
    elif format == "verbose":
        return date.strftime("%A %d %B %Y")
    else:
        return date.strftime("%A %d %B %Y (%d/%m/%Y)")


date = get_easter(int(year))
html = html.replace("<!-- easter date -->", format_date(date, "verbose"))
print("Content-Type: text/html")
print()
print(html)
