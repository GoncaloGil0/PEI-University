module namespace page = 'http://basex.org/examples/web-page';
declare default element namespace 'http://www.oficina.paiNatal.pt/Visits';
declare namespace f = 'http://www.oficina.paiNatal.pt/Family';

declare function page:checkDate($date as xs:string){
for $item in db:open("Visits")//Q{}dias_preferencia
   group by $d:= $item
   where $item = $date 
   return if (count($item) < 50) then (<data>{$date}</data>) else(<message>This day is complete</message>)
};

declare function page:treatArray($body as item()*){
  for $res in $body//f:day
  return $res/text()
};

declare function page:changeValues($body as item()*, $id as xs:string, $newValue as xs:string) {
copy $change := $body
modify (replace value of node $change//@id with concat('f',$id), replace value of node $change//f:dias_preferencia with $newValue)
return $change
};

declare
 %rest:path("/getvisit")
 %rest:query-param("booking_id", "{$booking_id}")
 %rest:GET
function page:getVisitFromDatabase($booking_id as xs:string) {
  for $result in db:open("visits")
  return if ($result//@id = $booking_id) 
  then $result
};

declare
 %rest:path("/getvisits")
 %rest:GET
function page:getAllFromDatabase() {
  for $result in db:open("visits")
  return $result
};


declare %updating
 %rest:path("/addvisit")
 %rest:consumes("application/xml", "text/xml")
 %rest:POST("{$body}")
function page:addToDatabase($body as item()) {
  try {
      let $xsd := "VisitsType.xsd"
      let $dias := $body//f:dias_preferencia/f:day
      let $rand := random:uuid()
      
      return (validate:xsd($body, $xsd),
        let $created := count(db:open("Visits")) 
        for $i in 1 to count($body//f:day)
        return if(count(db:open("Visits"))=$created) then(

          if(page:checkDate(page:treatArray($body)[$i]) != <message>This day is complete</message>) then(
            let $change := page:changeValues($body,$rand,page:checkDate(page:treatArray($body)[$i]))
            return db:add("visits", $change//family, "Visits.xml"), update:output(<message>Your visit id are: {concat('f',data($rand))}</message>))
          
          else if (empty(page:checkDate(page:treatArray($body)[1]))) then(
            let $change := page:changeValues($body,$rand,page:treatArray($body)[1])
            return db:add("visits", $change//family, "Visits.xml"), update:output(<message>Your visit id are: {concat('f',data($rand))}</message>))
          
          else(
            let $warning := concat("O número de visitas máximo para o dia ", page:treatArray($body)[$i], " foi atingido, por favor escolha de novo")
            return web:error(400, $warning )))
      )
  } catch validate:error {
      web:error(400, "O pedido submetido encontra-se mal formatado")
  }
};

declare %updating
 %rest:path("/delvisit")
 %rest:query-param("booking_id", "{$booking_id}")
 %rest:DELETE
function page:deleteFromDatabase($booking_id as xs:string) {   
        for $visits in db:open("Visits")
      return if ($visits//@id = $booking_id) then (
        update:output("Booking canceled"), replace value of node $visits//@status with "cancel" )  
};