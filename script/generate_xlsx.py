from faker import Faker # 👾
from collections import defaultdict
from pathlib import Path
import pandas as pd
import random
import datetime as dt
import os

HOME_DIR = Path(os.getcwd()).parent


class DB_entity(object):
    LENGTH = 100
    T = 0
    def __init__(self, name:str, data:dict):
        self.name = name
        self.data = data

    def __str__(self):
        # bulk insert
        file_name = "data_"+self.name+str(self.T)+".xlsx"
        
        df = pd.DataFrame(self.data)

        strCols = df.select_dtypes('object').columns

        mode = "w" if self.T == 0 else "a"
        header = "infer" if self.T == 0 else None
        
        endpath = os.path.join(HOME_DIR, "data", file_name)
        df.to_excel(endpath, index=False, header=header)

        write = f"BULK INSERT {self.name}\nFROM '{file_name}'\nWITH "
        params = "(FIRSTROW = 2);\n\n"
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



def agencyExcel(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    city = fake.city()
    table["Name"].append(city + 'Paradise Agency')
    table["Adress"].append(str(fake.address()))
    table["Postal Code"].append(str(random.randint(10,99))+'-'+str(random.randint(100,999)))
    table["City"].append(city)
    table["Telephone Number"].append(fake.msisdn()[:-4])
    table["e-mail"].append(fake.email())


def agencyNetworkExcel(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["employeeID"].append(id)
    table["Emp Name"].append(fake.first_name())
    table["Emp Surname"].append(fake.last_name())
    table["Date of Birth"].append(fake.date_of_birth(minimum_age=18, maximum_age=65))
    edu = ["Middle School", "Highschool", "Collage", "Master", "PhD"]
    table["Education"].append(random.choice(edu))
    table["Seniority"].append(fake.date_of_birth(maximum_age=20))
    table["Trips Sold"].append(random.randint(0,200))



def main():
    fake = Faker()
    Faker.seed(42)
    
    tables = {'Agency_Excel': agencyExcel, 'Agency_Network_Excel': agencyNetworkExcel}

    for period in range(1):
        for tab in tables.keys():
            fake_data = defaultdict(list)
            for id in range(DB_entity.LENGTH):
                tables[tab](fake_data, fake, id + DB_entity.LENGTH * period)
                
            if (tab == next(iter(tables))) and (period == 0):
                mode = "w"
            else:
                mode = "a"
            
            path = os.path.join(HOME_DIR, "db", "load_xlsx.sql")
            f = open(path, mode)
            entity = DB_entity(tab, fake_data)
            if period == 1:
                entity.nextT()
            f.write(str(entity))
            f.close()


#     🌴🌴 🥥🐒 🌴🌴
if __name__ == "__main__":
    main()
