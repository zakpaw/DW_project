from faker import Faker # 👾
from collections import defaultdict
from pathlib import Path
import pandas as pd
import random
import datetime as dt
import os

HOME_DIR = Path(os.getcwd()).parent


class DB_entity(object):
    LENGTH = 1000
    T = 0
    def __init__(self, name:str, data:dict):
        self.name = name
        self.data = data

    def __str__(self):
        # bulk insert
        file_name = "data_"+self.name+str(self.T)+".csv"
        
        df = pd.DataFrame(self.data)

        strCols = df.select_dtypes('object').columns
        fun = lambda x: x.str.replace('\n', '')
        df[strCols] = df[strCols].apply(fun, axis=0)

        mode = "w" if self.T == 0 else "a"
        header = "infer" if self.T == 0 else None
        
        endpath = os.path.join(HOME_DIR, "db", "data", file_name)
        df.to_csv(endpath, index=False, sep='|', mode=mode, header=header, line_terminator='<>')

        write = f"BULK INSERT {self.name}\nFROM '/home/db/data/{file_name}'\nWITH "
        params = "(FIRSTROW = 2,\nFIELDTERMINATOR = '|',\nROWTERMINATOR='<>');\n\n"
        return write + params


    def insert(self)->str:
        write = f"INSERT INTO {self.name} ({' '.join([*self.data.keys()])})\nVALUES\n"
        for i in range(self.LENGTH):
            write += "\t("
            for k in self.data.keys():
                write += str(self.data[k][i]) + ", "

            end = "),\n" if i != self.LENGTH-1 else ");"
            write = write[:-2] + end
        return write
    
    def nextT(self):
        self.T = 1



def hotel(table: dict, fake: object, id: int)->dict:
    table["hotel_ID"].append(id)
    table["name"].append(fake.company())
    table["address"].append(str(fake.address()))
    table["city"].append(fake.city())
    table["country"].append(fake.country())
    h = random.choice([12,13,14,15])
    table["starting_hour"].append(str(h))
    table["ending_hour"].append(str(h-2))
    table["opinion"].append(random.randrange(10)+1)
    table["is_befriended"].append(random.choice(['Yes', 'No']))

def airport(table: dict, fake: object, id: int)->dict:
    city = fake.city()
    table["airport_ID"].append(id)
    table["airport_name"].append(str(city) + 'airport')
    table["city"].append(city)
    table["country"].append(fake.country())

def airportNearHotel(table: dict, fake: object, id: int)->dict:
    table["hotel_ID"].append(id)
    table["airport_ID"].append(id)
    km = random.randrange(500, 9000)
    table["distance"].append(km)
    table["travel_time"].append("{:.2f}".format(km/880)) # 880km/h is average plane speed

def hotelOffer(table: dict, fake: object, id: int)->dict:
    table["offer_ID"].append(id)
    start = fake.date_time()
    table["start_date"].append(start)
    period = dt.timedelta(days=random.choice([3, 7, 14, 21, 28]))
    table["end_date"].append(start+period)
    table["price"].append(period.days * random.randrange(100, 250))
    table["capacity"].append(random.randrange(1,5))
    table["discount"].append("{:.2f}".format(random.random()))
    table["hotel_ID"].append(id)

def flight(table: dict, fake: object, id: int)->dict:
    table["flight_NO"].append(id)
    table["airplane"].append(fake.license_plate())
    table["cost"].append(random.randrange(200,800))
    date = fake.date_between(start_date='-30y', end_date='+10m')
    start = random.randrange(0,11)
    table["date"].append(str(date))
    table["arrival_time"].append(start + random.randrange(1,12))
    table["departure_time"].append(start)
    table["destination"].append(fake.city() + ', ' + fake.country())
    continents = ['Europe', 'Antarctica', 'South America', 'North America',
                  'Asia', 'Africa', 'Australia']
    table["continent"].append(random.choice(continents))
    table["airline_ID"].append(id)
    table["paradise_offer_ID"].append(id)

def travelBetween(table: dict, fake: object, id: int)->dict:
    table["airport_ID"].append(id)
    table["flight_NO"].append(id)

def airline(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["name"].append(fake.company_suffix())
    table["email"].append(fake.email())
    table["telephone_number"].append(fake.msisdn()[:-4])
    table["discount"].append("{:.2f}".format(random.random()))

def travelAgency(table: dict, fake: object, id: int)->dict:
    table["agency_ID"].append(id)
    city = fake.city()
    table["agency_name"].append(city + 'Paradise Agency')
    table["city"].append(city)
    table["country"].append(fake.country())

def employee(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["name"].append(fake.first_name())
    table["surname"].append(fake.last_name())
    table["agency_ID"].append(id)

def paradiseOffer(table: dict, fake: object, id: int)->dict:
    table["offer_ID"].append(id)
    table["costs"].append(random.randrange(800,10000))
    table["OTW"].append(random.randrange(0,10))
    table["creation_date"].append(fake.date_time())
    table["employee_ID"].append(id)
    table["hotel_offer_ID"].append(id)

def client(table: dict, fake: object, id: int)->dict:
    table["client_ID"].append(id)
    table["name"].append(fake.first_name())
    table["surname"].append(fake.last_name())
    table["email"].append(fake.email())
    table["telephone_number"].append(fake.msisdn()[:-4])

def clientOffer(table: dict, fake: object, id: int)->dict:
    table["client_ID"].append(id)
    table["offer_ID"].append(id)

def payment(table: dict, fake: object, id: int)->dict:
    table["transaction_no"].append(id)
    table["amount"].append(random.randrange(1000,11000))
    table["payment_date"].append(fake.date_time())
    methods = ['PayPal', 'BitCoin', 'International Transfer',
               'Visa', 'MasterCard', 'Cash', 'BLIK']
    table["payment_method"].append(random.choice(methods))
    table["offer_ID"].append(id)
    table["client_ID"].append(id)

def opinion(table: dict, fake: object, id: int)->dict:
    table["opinion_ID"].append(id)
    table["overall_reat"].append(random.randint(1,10))
    table["location"].append(random.randint(1,10))
    table["food"].append(random.randint(1,10))
    table["hotel"].append(random.randint(1,10))
    table["time_management"].append(random.randint(1,10))
    table["travelAgent"].append(random.randint(1,10))
    table["client_ID"].append(id)
    table["offer_ID"].append(id)



def main():
    fake = Faker()
    Faker.seed(42)
    
    tables = {'Hotel': hotel, 'Airport': airport, 'AirportNearHotel': airportNearHotel,
              'HotelOffer': hotelOffer, 'Flight': flight, 'Airline': airline,
              'TravelAgency': travelAgency, 'TravelBetween': travelBetween,
              'ParadiseOffer': paradiseOffer, 'Employee': employee, 'Client': client,
              'ClientOffer': clientOffer, 'Payment': payment, 'Opinion': opinion}
    
    lens = {'Hotel': DB_entity.LENGTH, 'Airport': DB_entity.LENGTH, 'AirportNearHotel': DB_entity.LENGTH,
              'HotelOffer': DB_entity.LENGTH, 'Flight': DB_entity.LENGTH, 'Airline': DB_entity.LENGTH,
              'TravelAgency': DB_entity.LENGTH, 'TravelBetween': DB_entity.LENGTH,
              'ParadiseOffer': DB_entity.LENGTH, 'Employee': DB_entity.LENGTH, 'Client': DB_entity.LENGTH,
              'ClientOffer': DB_entity.LENGTH, 'Payment': DB_entity.LENGTH, 'Opinion': DB_entity.LENGTH}
    
    for period in range(1):
        for tab in tables.keys():
            fake_data = defaultdict(list)
            for id in range(int(lens[tab]/2)):
                tables[tab](fake_data, fake, id + DB_entity.LENGTH * period)
                
            path = os.path.join(HOME_DIR, "db", "load_csv.sql")

            if (tab == next(iter(tables))) and (period == 0):
                f = open(path, "w")
                f.write("USE AgencyData;\n\n")
                f.close()
                mode = "a"
            else:
                mode = "a"

            f = open(path, mode)
            entity = DB_entity(tab, fake_data)
            if period == 1:
                entity.nextT()
            f.write(str(entity))
            f.close()

#     🌴🌴 🥥🐒 🌴🌴
if __name__ == "__main__":
    main()
