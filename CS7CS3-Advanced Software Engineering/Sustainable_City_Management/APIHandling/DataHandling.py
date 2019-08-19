import threading
from datetime import datetime
import json
import re
import logging
from django.utils.timezone import make_aware
from django.utils import timezone

from APIHandling import CustomExceptions as ex
from Bike.models import Bike
from BusLuas.models import BusLuas
from CityEvents.models import CityEvents
#from Parking.models import Parking
from Parking.models import carparkData
from WeatherPollution.models import WeatherData
from BusLuas.models import DublinBusStopData

from APIHandling import DublinBikesAPI
from APIHandling import CityEventAPI
from APIHandling import WeatherPollutionAPI
from APIHandling import IrishRailAPI
from APIHandling import ParkingAPI
from APIHandling import DublinBusAPI

############# Defines the methods for starting threads for each of the module###########################################

#Run frequency for each thread
BIKE_THREAD_RUN_FREQUENCY = 300.0
BUSLUAS_THREAD_RUN_FREQUENCY = 1200.0
CITYEVENT_THREAD_RUN_FREQUENCY = 86400.0
PARKING_THREAD_RUN_FREQUENCY = 600.0
WEATHER_THREAD_RUN_FREQUENCY = 3600.0
REALTIMEBUS_THREAD_RUN_FREQUENCY = 3600.0

def start_bike_thread():
    threading.Timer(BIKE_THREAD_RUN_FREQUENCY, start_bike_thread).start()
    data = DublinBikesAPI.getLatestData()
    if check_intigrity(data):
        create_bike_objects(data)
        return "Bike thread started"

def start_busLuas_thread():
    threading.Timer(BUSLUAS_THREAD_RUN_FREQUENCY, start_busLuas_thread).start()
    data = IrishRailAPI.get_trains_at_all_stations()
    if check_intigrity(data):
        create_busLuas_objects(data)
        return "BusLuas Irish Rail thread started"


def start_cityEvent_thread():
    threading.Timer(CITYEVENT_THREAD_RUN_FREQUENCY, start_cityEvent_thread).start()
    data = CityEventAPI.getEventsPerWeek()
    if check_intigrity(data):
        create_cityEvent_objects(data)
        return "CityEvent thread started"

def start_parking_thread():
    threading.Timer(PARKING_THREAD_RUN_FREQUENCY, start_parking_thread).start()
    data = ParkingAPI.get_live_data()
    if check_intigrity(data):
        create_parking_objects(data)
        return "Parking thread started"

def start_BusStop_thread():
    threading.Timer(BUSLUAS_THREAD_RUN_FREQUENCY, start_busLuas_thread).start()
    data = DublinBusAPI.getAllDublinBusStandInfo()
    if check_intigrity(data):
        create_DublinBusStopData_objects(data)
        return "Bus Stop thread started"

def start_RealTimeBusStop_thread():
    threading.Timer(REALTIMEBUS_THREAD_RUN_FREQUENCY, start_busLuas_thread).start()
    data = DublinBusAPI.getRealTimeDublinBusStandData()
    if check_intigrity(data):
        #create_DublinBusRealTimeStopData_objects(data)
        return "Real Time busStop thread started"

def start_weather_thread():
    threading.Timer(WEATHER_THREAD_RUN_FREQUENCY, start_weather_thread).start()
    latest_csv, csv_flag = WeatherPollutionAPI.pull_weather_csv()
    try:
        csv_to_json = WeatherPollutionAPI.csv_to_json(latest_csv)
        data = json.loads(csv_to_json)
        if check_intigrity(data) and csv_flag:
            create_weather_objects(data)
            return "WeatherPollution thread started"
    except IOError as e:
        logging.exception('I/O Error with CSV file ' + str(e))


#######################Method to check intigrity of data before writing it to the database. This needs to be more rovhust################

def check_intigrity(json_data):
    try:
        json_object = json_data
    except json.JSONDecodeError:
        logging.exception('Error when validating JSON')
        return False
    return True


#########################Methods for creating objects of the respective module after data has been validated( inserting them into database#####

#Inserts DublinBike Data int DB
def create_bike_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        for row in data:
            for key in row:
                number = row['number']
                contract_name = row['contract_name']
                name = row['name']
                address = row['address']
                position_lat = row['position']['lat']
                position_lng = row['position']['lng']
                banking = row['banking']
                bonus = row['bonus']
                bike_stands = row['bike_stands']
                available_bike_stands = row['available_bike_stands']
                available_bikes = row['available_bikes']
                status = row['status']
                last_update = make_aware(datetime.fromtimestamp(int(str(row['last_update'])[:10])))
                cm_last_insert_dttm = current_dttm
            b = Bike.objects.create(number=number, contract_name=contract_name, name=name, address=address,
                                    position_lat=position_lat, position_lng=position_lng, banking=banking,
                                    bonus=bonus, bike_stands=bike_stands, available_bike_stands=available_bike_stands,
                                    available_bikes=available_bikes, status=status, last_update=last_update, cm_last_insert_dttm=cm_last_insert_dttm)
            b.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create Bike Object")
        return False


#Inserts IrishRail Data int DB
def create_busLuas_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        for row in data:
            for key in row:
                ServerTime = row['ServerTime']
                TrainCode = row['TrainCode']
                StationFullName = row['StationFullName']
                StationCode = row['StationCode']
                QueryTime = row['QueryTime']
                TrainDate = row['TrainDate']
                Origin = row['Origin']
                Destination = row['Destination']
                OriginTime = row['OriginTime']
                DestinationTime = row['DestinationTime']
                Status = row['Status']
                LastLocation = row['LastLocation']
                DueIn = row['DueIn']
                Late = row['Late']
                ExpArrival = row['ExpArrival']
                ExpDepart = row['ExpDepart']
                SchArrival = row['SchArrival']
                SchDepart = row['SchDepart']
                Direction = row['Direction']
                TrainType = row['TrainType']
                LocationType = row['LocationType']
                cm_last_insert_dttm = current_dttm
                BusLuas_object = BusLuas.objects.create(ServerTime=ServerTime, TrainCode=TrainCode,
                                                       StationFullName=StationFullName, StationCode=StationCode,
                                                       QueryTime=QueryTime, TrainDate=TrainDate, Origin=Origin,
                                                       Destination=Destination, OriginTime=OriginTime,
                                                       DestinationTime=DestinationTime, Status=Status,
                                                       LastLocation=LastLocation, DueIn=DueIn, Late=Late,
                                                       ExpArrival=ExpArrival,
                                                       ExpDepart=ExpDepart, SchArrival=SchArrival, SchDepart=SchDepart,
                                                       TrainType=TrainType, Direction=Direction, LocationType=LocationType,
                                                       cm_last_insert_dttm=cm_last_insert_dttm)
                BusLuas_object.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create BusLuas Object")
        return False

#Inserts CityEvent Data int DB
def create_cityEvent_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        cityEventData = data
        for target_list in cityEventData['events']:
            # status= target_list['status']
            descriptionText = target_list['description']['text']
            nametext = target_list['name']['text']
            organization_id = int(target_list['organization_id'])
            # online_event=target_list['online_event']
            startutc = target_list['start']['utc']
            endutc = target_list['end']['utc']
            listed = target_list['listed']
            is_free = target_list['is_free']
            url = target_list['url']
            # resource_uri=target_list['resource_uri']
            cm_last_insert_dttm = current_dttm

            cityEvent = CityEvents.objects.create(nametext=nametext, organization_id=organization_id, listed=listed,
                                                  is_free=is_free, url=url, startutc=startutc, endutc=endutc,
                                                  cm_last_insert_dttm=cm_last_insert_dttm)
            cityEvent.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create CityEvent Object")
        return False

#Inserts Parking Data int DB
def create_parking_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        non_standard_date_time_stamp = data['carparkData']['Timestamp']['$']
        date_list = re.sub(' on ', ' ', non_standard_date_time_stamp)#removes 'ON'
        datetime_cleaned = datetime.strptime(date_list, '%H:%M:%S %A %d/%m/%Y')
        for key in data['carparkData']['Northwest']['carpark']:
            name = key['@name']
            spaces = 0 if not str(key['@spaces']).strip() else key['@spaces']
            if spaces == "FULL": spaces = 0
            area = 'Northwest'
            Timestamp = datetime_cleaned
            cm_last_insert_dttm = current_dttm

            parking_object = carparkData.objects.create(name=name, spaces=spaces, area=area, Timestamp=Timestamp, cm_last_insert_dttm=cm_last_insert_dttm)
            parking_object.save()

        for key in data['carparkData']['Northeast']['carpark']:
            name = key['@name']
            spaces = 0 if not str(key['@spaces']).strip() else key['@spaces']
            if spaces == "FULL": spaces = 0
            area = 'Northeast'
            Timestamp = datetime_cleaned
            cm_last_insert_dttm = current_dttm

            parking_object = carparkData.objects.create(name=name, spaces=spaces, area=area, Timestamp=Timestamp, cm_last_insert_dttm=cm_last_insert_dttm)
            parking_object.save()

        for key in data['carparkData']['Southwest']['carpark']:
            name = key['@name']
            spaces = 0 if not str(key['@spaces']).strip() else key['@spaces']
            if spaces == "FULL": spaces = 0
            area = 'Southwest'
            Timestamp = datetime_cleaned
            cm_last_insert_dttm = current_dttm

            parking_object = carparkData.objects.create(name=name, spaces=spaces, area=area, Timestamp=Timestamp, cm_last_insert_dttm=cm_last_insert_dttm)
            parking_object.save()

        for key in data['carparkData']['Southeast']['carpark']:
            name = key['@name']
            spaces = 0 if not str(key['@spaces']).strip() else key['@spaces']
            if spaces == "FULL": spaces = 0
            area = 'Southwest'
            Timestamp = datetime_cleaned
            cm_last_insert_dttm = current_dttm

            parking_object = carparkData.objects.create(name=name, spaces=spaces, area=area, Timestamp=Timestamp, cm_last_insert_dttm=cm_last_insert_dttm)
            parking_object.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create Parking Object")
        return False
      
#Inserts Weather Data int DB
def create_weather_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        for row in data:
            Station = row['Station']
            Temperature = int(row['Temperature (ÂºC)'])
            Weather = row['Weather']
            WindSpeed = row['Wind Speed (Kts)']
            WindGust = row['Wind Gust (Kts)']
            WindDirection = row['Wind Direction']
            Humidity = row['Humidity (%)']
            Rainfall = row['Rainfall (mm)']
            Pressure = row['Pressure (hPa)']
            if Temperature == 'n/a' or Temperature == '' or Temperature == '-':
                Temperature = None
            if Weather == '-' or Weather == 'n/a' or Weather == "":
                Weather = None
            if WindSpeed == '-' or WindSpeed == 'n/a' or WindSpeed == "":
                WindSpeed = None
            if WindGust == '-' or WindGust == 'n/a' or WindGust == "":
                WindGust = None
            if WindDirection == '-' or WindDirection == 'n/a' or WindDirection == "":
                WindDirection = None
            if Humidity == '-' or Humidity == 'n/a' or Humidity == "":
                Humidity = None
            if Rainfall == '-' or Rainfall == 'n/a' or Rainfall == "":
                Rainfall = None
            if Pressure == '-' or Pressure == 'n/a' or Pressure == "":
                Pressure = None
            Weather_obj = WeatherData.objects.create(Station=Station,
                                        Temperature=Temperature,
                                        Weather=Weather,
                                        WindSpeed=WindSpeed,
                                        WindGust=WindGust,
                                        WindDirection=WindDirection,
                                        Humidity=Humidity,
                                        Rainfall=Rainfall,
                                        Pressure=Pressure,
                                        cm_last_insert_dttm=current_dttm)
            Weather_obj.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create CityEvent Object")
        return False



def create_DublinBusStopData_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        loaded_json = json.loads(data)

        for row in loaded_json:
            StopNumber = int(row['StopNumber'])
            Longitude = float(row['Longitude'])
            Latitude = row['Latitude']
            Description = row['Description']
            cm_last_insert_dttm = current_dttm
            BusLuas_object = DublinBusStopData.objects.create(BusStopNumber=StopNumber, BusStopLatitude=float(Latitude),
                                                       BusStopLongitude=Longitude, BusStopStationName=Description,BusStopZone='City',
                                                       cm_last_insert_dttm=cm_last_insert_dttm)
            BusLuas_object.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create BusLuas Object")
        return False

def create_DublinBusRealTimeStopData_objects(data):
    try:
        current_dttm = datetime.now(tz=timezone.utc)
        loaded_json = json.loads(data)

        for row in loaded_json:
            StopNumber = int(row['StopNumber'])
            Longitude = float(row['Longitude'])
            Latitude = row['Latitude']
            Description = row['Description']
            cm_last_insert_dttm = current_dttm
            BusLuas_object = DublinBusStopData.objects.create(BusStopNumber=StopNumber, BusStopLatitude=float(Longitude),
                                                       BusStopLongitude=Latitude, BusStopStationName=Description,
                                                       cm_last_insert_dttm=cm_last_insert_dttm)
            BusLuas_object.save()
        return True
    except ex.FailedToCreateObjectException:
        logging.exception("Failed to create BusLuas Object")
        return False
