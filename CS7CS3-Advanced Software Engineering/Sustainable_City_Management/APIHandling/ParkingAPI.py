import requests
import logging
import json
import xml.etree.ElementTree as ET
import xmljson


def getLatestData():
    # Call API for dublin parking
    try:
        dublinparking_data_request = requests.get(
            "http://data-sdublincoco.opendata.arcgis.com/datasets/c62b49536b5e466f807943e9a0cf6df0_0.geojson")
        dublinparking_data = json.loads(dublinparking_data_request.text)
        return dublinparking_data
    except json.JSONDecodeError:
        logging.exception('Error when parsing JSON, raw data was ' + str(dublinparking_data))
        raise requests.RequestException('Unable to do my work! Invalid JSON data returned.')


def get_live_data():
    dublinparking_data_request_xml = requests.get("http://www.dublincity.ie/dublintraffic/cpdata.xml?")
    xml = ET.fromstring(dublinparking_data_request_xml.content)
    xml_to_json = json.dumps(xmljson.badgerfish.data(xml))
    json_responce = json.loads(xml_to_json)
    return json_responce
