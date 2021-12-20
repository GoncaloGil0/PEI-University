import json
import xmltodict
import os
 
with open("/home/superadmin/Documentos/Faculdade/PEI/BaseXtoMongoDB/Testes/Exemplo.xml") as xml_file:
     
    data_dict = xmltodict.parse(xml_file.read())
    xml_file.close()
     
     
    json_data = json.dumps(data_dict)
     
    with open("data.json", "w") as json_file:
        json_file.write(json_data)
        json_file.close()


os.system("cat data.json | jq | tee data.json")