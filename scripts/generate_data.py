from faker import Faker
from collections import defaultdict
from pathlib import Path
from tables import *
import pandas as pd
import random
import datetime as dt
import os

fake = Faker()
HOME_DIR = Path(os.getcwd()).parent


class DB_entity(object):
    LENGTH = 15100
    T = 0
    def __init__(self, name:str, data:dict):
        self.name = name
        self.data = data

    def __str__(self):
        # bulk insert
        file_name = "data_"+self.name+str(self.T)+".csv"
        
        df = pd.DataFrame(self.data)
        if self.name != 'Agency_Network_Excel':
            strCols = df.select_dtypes('object').columns
            fun = lambda x: x.str.replace('\n', '')
            try:
                df[strCols] = df[strCols].apply(fun, axis=0)
            except Exception:
                pass

        mode = "w" if self.T == 0 else "a"
        header = "infer" if self.T == 0 else None
        
        endpath = os.path.join(HOME_DIR, "db", "data", file_name)
        df.to_csv(endpath, index=False, sep='|', mode=mode, header=header, line_terminator='<>')
        if self.name not in ['Agency_Network_Excel', 'Agency_Excel']:
            write = f"BULK INSERT {self.name}\nFROM '/home/db/data/{file_name}'\nWITH "
            params = "(FIRSTROW = 2,\nFIELDTERMINATOR = '|',\nROWTERMINATOR='<>');\n\n"
            return write + params
        else:
            return ''


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

cities = [fake.city() for _ in range(DB_entity.LENGTH*2)]
names = [fake.first_name() for _ in range(DB_entity.LENGTH*2)]
surnames = [fake.last_name() for _ in range(DB_entity.LENGTH*2)]

def employee(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["name"].append(names[id])
    table["surname"].append(surnames[id])
    table["agency_ID"].append(id)

def travelAgency(table: dict, fake: object, id: int)->dict:
    table["agency_ID"].append(id)
    table["agency_name"].append(cities[id] + 'Paradise Agency')
    table["city"].append(cities[id])
    table["country"].append(fake.country())

# Excels
def agencyExcel(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["Name"].append(cities[id] + 'Paradise Agency')
    table["Adress"].append(str(fake.address()))
    table["Postal Code"].append(str(random.randint(10,99))+'-'+str(random.randint(100,999)))
    table["City"].append(cities[id])
    table["Telephone Number"].append(fake.msisdn()[:-4])
    table["e-mail"].append(fake.email())

def agencyNetworkExcel(table: dict, fake: object, id: int)->dict:
    table["agencyID"].append(id)
    table["employeeID"].append(id)
    table["PESEL"].append(str(random.randint(10000000000, 99999999999)))
    table["Emp Name"].append(names[id])
    table["Emp Surname"].append(surnames[id])
    table["Date of Birth"].append(fake.date_of_birth(minimum_age=18, maximum_age=65))
    edu = ["Middle school", "High School", "College", "Master", "PhD"]
    table["Education"].append(random.choice(edu))
    date = fake.date_of_birth(maximum_age=20)
    table["Seniority"].append(date)
    if random.random() < 0.1:
        table["endWorkDate"].append(date + dt.timedelta(days=random.randint(30, 1000)))
    else:
        table["endWorkDate"].append(None)
    table["Trips Sold"].append(random.randint(0,200))

def main():
    Faker.seed(42)
    
    tables = {'Hotel': hotel, 'Airport': airport, 'AirportNearHotel': airportNearHotel,
              'HotelOffer': hotelOffer, 'Flight': flight, 'Airline': airline,
              'TravelAgency': travelAgency, 'TravelBetween': travelBetween,
              'ParadiseOffer': paradiseOffer, 'Employee': employee, 'Client': client,
              'ClientOffer': clientOffer, 'Payment': payment, 'Opinion': opinion,
              'Agency_Excel': agencyExcel, 'Agency_Network_Excel': agencyNetworkExcel}
    
    lens = {'Hotel': DB_entity.LENGTH, 'Airport': DB_entity.LENGTH, 'AirportNearHotel': DB_entity.LENGTH,
              'HotelOffer': DB_entity.LENGTH, 'Flight': DB_entity.LENGTH*2, 'Airline': DB_entity.LENGTH,
              'TravelAgency': DB_entity.LENGTH, 'TravelBetween': DB_entity.LENGTH,
              'ParadiseOffer': DB_entity.LENGTH, 'Employee': DB_entity.LENGTH, 'Client': DB_entity.LENGTH,
              'ClientOffer': DB_entity.LENGTH, 'Payment': DB_entity.LENGTH, 'Opinion': DB_entity.LENGTH,
              'Agency_Excel': DB_entity.LENGTH, 'Agency_Network_Excel': DB_entity.LENGTH}
    
    for period in range(2):
        for tab in tables.keys():
            fake_data = defaultdict(list)
            for id in range(int(lens[tab]/2)):
                if tab == 'Flight':
                    # offerID = int(id % lens[tab] / 2 + (lens[tab]/2 / period))
                    offerID = int((id + (int(lens[tab]/2) * period)) / 2)
                    tables[tab](fake_data, fake, id + (int(lens[tab]/2) * period), offerID)
                else:
                    tables[tab](fake_data, fake, id + (int(lens[tab]/2) * period))
                
            path = os.path.join(HOME_DIR, "db", f"load_csv_{period}.sql")

            if (tab == next(iter(tables))):
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
