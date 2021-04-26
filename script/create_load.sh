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
}

createAndLoad || (sleep 5 && createAndLoad)
