module namespace page = 'http://basex.org/examples/web-page';
declare default element namespace 'http://www.oficina.paiNatal.pt/Visits';
declare namespace f = 'http://www.oficina.paiNatal.pt/Family';

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
        update:output(<message>Your visit id are: {data(concat('f',$rand))}</message>),
        for $day in $body//f:day
          for $node in db:open("visits")//Q{}day
            group by $name := $node/text()
              where ($node = $day)
                let $num_visits := count($node) div count($body//f:day)
                return if ($num_visits <= 5) then
                  copy $change := $body
                  modify (replace value of node $change//@id with concat('f',$rand))
                  return db:add("visits", $change//family, "Visits.xml") 
                  else
                      let $warning := concat("O número de visitas máximo para o dia ", data($node/text())[1], " foi atingido, por favor escolha de novo")
                      return web:error(400, $warning )
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