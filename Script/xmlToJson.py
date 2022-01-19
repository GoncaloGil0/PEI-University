import xmltodict, json, sys, sendAtlas

def escreverDoc(caminho, savePath="./data.json"):
    with open(caminho, 'r') as xmlFile:
        info = xmlFile.read()

    json_object = json.dumps(json.loads(json.dumps(xmltodict.parse(info))),indent=4)

    with open(savePath, "w") as json_file:
        json_file.write(json_object)
        json_file.close()

    print(f"| XML --> Json \
        \n| Ficheirio guardado com sucesso em: {savePath}")

    sendAtlas.send(savePath)

def help():
    return (f"+ Instruções + \
        \n| {sys.argv[0]} 'docPath' 'savePath' \
        \n|\
        \n| docPath : diretorio do documento xml \
        \n| savePath: diretorio do documento json (valor por defeito {'./data.json'}) ")

if sys.argv[1] == "--help":
    print(help())
elif len(sys.argv) == 3:
    docPath, savePath = sys.argv[1], sys.argv[2]
    escreverDoc(docPath, savePath)
elif len(sys.argv) == 2:
    docPath = sys.argv[1]
    escreverDoc(docPath)
else :
    print(help())