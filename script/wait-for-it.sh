#!/usr/bin/env bash

/opt/mssql/bin/sqlservr

sleep 60

echo "Creating database"

createAndLoad() {
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/db/CREATE.sql
    # sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/db/load_csv.sql
    sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/dw/CREATE.sql
    # sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -i /home/dw/INSERT.sql
}

# createAndLoad || (sleep 5 && createAndLoad)
