import requests
import logging
import json


def getLatestData():
    # Call API for dublin bikes
    try:
        dublinbike_data_request = requests.get(
            "https://api.jcdecaux.com/vls/v1/stations?contract=Dublin&apiKey=29374861957fe56e1b065c24f9cf06f84ae8dce2")
        dublinbike_data = json.loads(dublinbike_data_request.text)
        return dublinbike_data
    except json.JSONDecodeError:
        logging.exception('Error when parsing JSON, raw data was ' + str(dublinbike_data))
        raise requests.RequestException('Unable to do my work! Invalid JSON data returned.')

