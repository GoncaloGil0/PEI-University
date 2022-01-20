import json, os
from socket import J1939_PGN_REQUEST

cluster_url = 'https://data.mongodb-api.com/app/data-wamrm/endpoint/data/beta/action/insertMany'
api_key = 'RL1WG7TulPTm8No4wA3ye017GWk6HMLii1oyIcHl6X5Zsu5RC8hYCX2sBNs5alDf'

clusterName = "Cluster0"
dbName = "visitsDB"
collectionName = "visits"

def send(path="./data.json"):
    file = open(path, 'r')
    data = json.load(file)
    
    jsonData = data.get("visits").get("family")

    data_raw = """"dataSource": "{}", \
        "database": "{}", \
        "collection": "{}", \
        "documents": {}""".format(clusterName, dbName, collectionName, jsonData)
    
    data_raw = "{" + data_raw.replace("'",'"') + "}"
    
    cmd = """curl --location --request POST {} \
        --header 'Content-Type: application/json' \
        --header 'api-key: {}' \
        --header 'Access-Control-Request-Headers: *' \
        --data-raw '{}'""""".format(cluster_url, api_key, data_raw)
    
    os.system(cmd)
    file.close()

    print(f"\n| JSON --> Atlas \
        \n| Ficheirio enviado com sucesso para: {clusterName}")
