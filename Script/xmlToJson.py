#import pandas_read_xml as pdx
#print(pdx.read_xml("Exemplo.xml").to_json())

import json
import xmltodict
 
with open("Testes/Exemplo.xml") as xml_file:
     
    data_dict = xmltodict.parse(xml_file.read())
    xml_file.close()
     
     
    json_data = json.dumps(data_dict)
     
    with open("data.json", "w") as json_file:
        json_file.write(json_data)
        json_file.close()