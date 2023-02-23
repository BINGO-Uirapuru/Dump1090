#!/bin/bash

# Atualizar as informações do banco de dados dos voos
/usr/bin/wget -q -O /tmp/flightaware.json "http://flightxml.flightaware.com/json/FlightXML2/AllAirports"
/usr/bin/python3 /opt/dump1090/tools/flightaware_to_json.py /tmp/flightaware.json > /run/dump1090-fa/flightaware.json

# Reiniciar o Dump1090 para carregar as informações atualizadas
/usr/bin/systemctl restart dump1090-fa
