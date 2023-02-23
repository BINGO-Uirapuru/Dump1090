# CRIANDO UM CONTAINER DUMP1090


Para atualizar os voos do Dump1090 usando informações de bancos de dados da internet, podemos usar um script que faça a atualização periodicamente e injetar esse script no Dockerfile.

A seguir temos o Dockerfile utilizado:

```Dockerfile

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        librtlsdr-dev \
        libusb-1.0-0-dev \
        pkg-config \
        ca-certificates \
        cron

RUN git clone https://github.com/antirez/dump1090.git /opt/dump1090

WORKDIR /opt/dump1090

RUN make

ADD dump1090_cron /etc/cron.d/dump1090_cron

RUN chmod 0644 /etc/cron.d/dump1090_cron

RUN crontab /etc/cron.d/dump1090_cron

CMD ["cron", "-f"]
```

Neste Dockerfile, além das dependências necessárias para compilar o Dump1090, também instalamos o cron, um utilitário do sistema operacional que permite a execução de comandos programados periodicamente.

Adicionamos um arquivo de cron personalizado chamado dump1090_cron que executa um script que atualiza os voos com informações da internet. O script pode ser assim:

```shellscript

#!/bin/bash

# Atualizar as informações do banco de dados dos voos
/usr/bin/wget -q -O /tmp/flightaware.json "http://flightxml.flightaware.com/json/FlightXML2/AllAirports"
/usr/bin/python3 /opt/dump1090/tools/flightaware_to_json.py /tmp/flightaware.json > /run/dump1090-fa/flightaware.json

# Reiniciar o Dump1090 para carregar as informações atualizadas
/usr/bin/systemctl restart dump1090-fa
```
Para atualizar os voos do Dump1090 usando informações de bancos de dados da internet, podemos usar um script que faça a atualização periodicamente e injetar esse script no Dockerfile.

Aqui está um exemplo de Dockerfile para o Dump1090 que usa informações de bancos de dados da internet para atualizar os voos:

bash

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        librtlsdr-dev \
        libusb-1.0-0-dev \
        pkg-config \
        ca-certificates \
        cron

RUN git clone https://github.com/antirez/dump1090.git /opt/dump1090

WORKDIR /opt/dump1090

RUN make

ADD dump1090_cron /etc/cron.d/dump1090_cron

RUN chmod 0644 /etc/cron.d/dump1090_cron

RUN crontab /etc/cron.d/dump1090_cron

CMD ["cron", "-f"]

Neste Dockerfile, além das dependências necessárias para compilar o Dump1090, também instalamos o cron, um utilitário do sistema operacional que permite a execução de comandos programados periodicamente.

Adicionamos um arquivo de cron personalizado chamado dump1090_cron que executa um script que atualiza os voos com informações da internet. O script pode ser assim:

bash

#!/bin/bash

# Atualizar as informações do banco de dados dos voos
/usr/bin/wget -q -O /tmp/flightaware.json "http://flightxml.flightaware.com/json/FlightXML2/AllAirports"
/usr/bin/python3 /opt/dump1090/tools/flightaware_to_json.py /tmp/flightaware.json > /run/dump1090-fa/flightaware.json

# Reiniciar o Dump1090 para carregar as informações atualizadas
/usr/bin/systemctl restart dump1090-fa

Este script usa o wget para baixar as informações do banco de dados de voos do FlightAware em formato JSON e, em seguida, usa um script Python fornecido pelo Dump1090 para converter essas informações em um formato que o Dump1090 possa usar.

Por fim, o script reinicia o Dump1090 para carregar as informações atualizadas.

O arquivo dump1090_cron deve ser colocado na pasta /etc/cron.d/ no contêiner e ter o seguinte conteúdo:

```bash

# Atualizar as informações de voos a cada 5 minutos
*/5 * * * * root /opt/dump1090/tools/update-flightaware.sh >> /var/log/dump1090.log 2>&1
```
Esse arquivo cron define que o script de atualização de voos deve ser executado a cada 5 minutos. O comando de atualização é executado como o usuário root, o que é necessário para reiniciar o Dump1090.

Para construir a imagem Docker a partir deste Dockerfile, execute o seguinte comando no mesmo diretório que o arquivo Dockerfile:

```bash

sudo docker build -t dump1090 .
```
Isso criará uma imagem Docker com o nome "dump1090" que você pode executar com o comando:

```bash

sudo docker run -p 8080:8080 --privileged dump1090
```
Este comando iniciará um contêiner Docker com o Dump1090 em execução e exporá a porta HTTP padrão 8080 para a porta 8080 do host.

Podemos acessar a interface do do dump1090  a partir do URL: [http://127.0.0.1:8080](http://127.0.0.1:8080)

-------------------

# COMFIGURANDO O DUMP1090

Para configurar o dump1090 para uma região específica siga os passos abaixo:

para acessar o arquivo de configuração do container use o comando a seguir:
 
 ```Dockerfile
 
 sudo docker exec -it <name_container>
 ```
 e navegue no container até o arquivo.

 Abra o arquivo de configuração do dump1090 (geralmente chamado de "dump1090.conf") e adicione as seguintes linhas:
 
 ```Shellscript
 
 --lat <latitude> --lon <longitude> --max-range <distância>
 ```
 Substitua <latitude> e <longitude> pelas coordenadas geográficas do local em que você deseja rastrear os aviões. Substitua <distância> pela distância máxima (em quilômetros) a partir do local especificado que você deseja rastrear.

Substitua <latitude> e <longitude> pelas coordenadas geográficas do local em que você deseja rastrear os aviões. Substitua <distância> pela distância máxima (em quilômetros) a partir do local especificado que você deseja rastrear.

Para o bingo uirapuru temos as seguintes coordenadas: 7°12’41.9″S 35°54’29.5″W 

latitude = -7,69833
longitude = -35,49167
distancia = 1 km

- Salve o arquivo de configuração e inicie o dump1090.

- Abra um navegador da web e vá para o endereço http://localhost:8080 para ver a interface do dump1090.

- Você deve ver um mapa da região especificada e os aviões que estão voando na área. Se não houver aviões visíveis, verifique se o dump1090 está funcionando corretamente e se os parâmetros de configuração estão corretos.




 
 












