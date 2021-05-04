#!/usr/bin/env bash

createAndLoad() {
    echo "Creating AgencyData"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -Q "CREATE DATABASE AgencyData"
    echo "Creating tables in AgencyData"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/db/CREATE.sql
    echo "Creating Agency_DW"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -Q "CREATE DATABASE Agency_DW"
    echo "Creating tables in Agency_DW"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/dw/CREATE.sql
    echo "Loading data to AgencyData"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/db/load_csv.sql
    echo "Loading UNKNOWN"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD__UNKNOWN.sql
    echo "Running ETL"
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_TIME.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_DATE.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_AIRLINE.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_TRAVEL_AGENCY.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_EMPLOYEE.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_HOTEL.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_DESTINATION_AIRPORT.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_LOCAL_AIRPORT.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_AIRPORT_NEAR_HOTEL.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_FLIGHTS.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/ETL/LOAD_SCHEDULE.sql
    echo "=== ALL DONE ==="
}

createAndLoad || (sleep 5 && createAndLoad)
