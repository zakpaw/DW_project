from faker import Faker # 👾
from collections import defaultdict
from pathlib import Path
from tables import *
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
        if self.name not in ['Agency_Network_Excel']:
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


def main():
    fake = Faker()
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
                    offerID = id - 1 if id % 2 == 1 else id
                    tables[tab](fake_data, fake, id + DB_entity.LENGTH * period, offerID)
                else:
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
