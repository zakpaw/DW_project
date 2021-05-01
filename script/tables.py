import random
import datetime as dt

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

def flight(table: dict, fake: object, id: int, offerID: int)->dict:
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
    table["paradise_offer_ID"].append(offerID)

def travelBetween(table: dict, fake: object, id: int)->dict:
    table["airport_ID"].append(id)
    table["flight_NO"].append(id)

def airline(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["name"].append(fake.company_suffix())
    table["email"].append(fake.email())
    table["telephone_number"].append(fake.msisdn()[:-4])
    table["discount"].append("{:.2f}".format(random.random()))

def paradiseOffer(table: dict, fake: object, id: int)->dict:
    table["offer_ID"].append(id)
    table["costs"].append(random.randrange(800,10000))
    table["OTW"].append(random.randrange(0,10))
    table["creation_date"].append(fake.date_time())
    table["creation_time"].append(random.randrange(7,19))
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

def employee(table: dict, fake: object, id: int)->dict:
    table["ID"].append(id)
    table["name"].append(fake.first_name())
    table["surname"].append(fake.last_name())
    table["agency_ID"].append(id)

def travelAgency(table: dict, fake: object, id: int)->dict:
    table["agency_ID"].append(id)
    city = fake.city()
    table["agency_name"].append(city + 'Paradise Agency')
    table["city"].append(city)
    table["country"].append(fake.country())

# Excels
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
    table["agencyID"].append(id)
    table["employeeID"].append(id)
    table["PESEL"].append(random.randint(10000000000, 99999999999))
    table["Emp Name"].append(fake.first_name())
    table["Emp Surname"].append(fake.last_name())
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
