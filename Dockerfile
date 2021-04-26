# dont forget -p 1433:1433
FROM mcr.microsoft.com/mssql/server:2019-latest AS DW

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Passwel1
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=1433
ENV PATH="$PATH:/opt/mssql-tools/bin:/opt/mssql/bin" 

EXPOSE 1433

COPY . /home

WORKDIR /home

CMD ["./script/create_load.sh"]
