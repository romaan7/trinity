import requests
import json
import datetime

def getEventsPerWeek():
    url = "https://www.eventbriteapi.com/v3/events/search/"
    querystring = {"location.address": "Dublin", "start_date.range_start": datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S"), "token": "DSL5CXCJDV7UDZLLMN7J"}
    response = requests.request("GET", url, params=querystring)
    city_event_data = json.loads(response.text)
    return city_event_data
