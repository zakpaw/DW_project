#!/usr/bin/env bash

echo "Deleting Agency_DW"
sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -Q "DROP DATABASE Agency_DW"
echo "Deleting AgencyData"
sqlcmd -S 127.0.0.1 -U sa -P ${SA_PASSWORD} -Q "DROP DATABASE AgencyData"
