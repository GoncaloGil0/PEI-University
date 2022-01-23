```bash
$ use visitsDB
#Show info
$ db.visits.find().prety()
#Filter
$ db.visits.find({"family.dias_preferencia.day.__text":"2021-12-24"}).pretty()
#Contagem
$ db.visits.aggregate([{"$match":{"family.dias_preferencia.day.__text":"2021-12-24"}},{"$count":"2021-12-24"}]).pretty()
$ db.visits.aggregate([{"$match":{"family.dias_preferencia.day.__text":"2021-12-24"}},{"$project":{"family.dias_preferencia.day":1}},{"$count":"2021-12-24"}]).pretty()
```


### Apresentar o número total de agendamentos até ao momento
```bash
$ db.visits.find().count()
```
### Apresentar o total de famílias por dia (Done)
```bash
$ db.visits.aggregate([{"$match":{"f:dias_preferencia":"2021-12-24"}},{"$count":"2021-12-24"}]).pretty() 
```
### Apresentar o total de pessoas por dia (Done)
```bash
$ db.visits.aggregate([{"$match":{"f:dias_preferencia":"2021-09-02"}},{ "$group":{"_id":"$f:dias_preferencia", "total_pessoas":{"$sum":{$toInt: "$f:number_members"}}}}])    
```
### A percentagem de ocupação por dia (Done)
```bash
$ db.visits.aggregate([{"$match":{"f:dias_preferencia":"2021-12-24"}},{ "$group":{"_id":"$f:dias_preferencia", "total_pessoas":{"$sum":{$toInt: "$f:number_members"}}}},{"$project":{"_id":0,"total_pessoas": 1, "percentagem_ocup":{$divide:[{ $multiply: [ "$total_pessoas", 100]},50]}}}])
```
### Comparação do número de agendamentos considerando a média de idades das pessoas que visitam a oficina.
db.visits.aggregate([{"$project":{ __id: 1,idadeMax:{"$max": {$toInt: "$f:number_members"}}}}])

### O número de cancelamentos por dia (Done)
```bash
$ db.visits.aggregate([{"$match":{"@status":"cancel","f:dias_preferencia":"2021-12-24"}},{"$count":"cancelados"}])
```
### Por cidade e por país, apresentar o número de agendamentos (Done)
```bash
$ db.visits.aggregate([{"$match":{"f:pais":"Portugal", "f:cidade":"Lisboa"}},{"$count":"family"}]).pretty()
```
### Outras visualizações que considerar relevantes.