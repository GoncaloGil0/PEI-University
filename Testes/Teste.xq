declare namespace f = 'http://www.oficina.paiNatal.pt/Family';

let $body :=<visits xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.oficina.paiNatal.pt/Visits" xsi:schemaLocation="http://www.oficina.paiNatal.pt/Visits VisitsType.xsd" xmlns:f="http://www.oficina.paiNatal.pt/Family" xmlns:m="http://www.oficina.paiNatal.pt/Members">

    <family id="f01">
        <f:number_members>2</f:number_members>
        <f:member>
            <m:nome></m:nome>
            <m:data_nascimento>2021-10-03</m:data_nascimento>
        </f:member>
        <f:member>
            <m:nome></m:nome>
            <m:data_nascimento>2021-10-03</m:data_nascimento>
        </f:member>
        <f:pais></f:pais>
        <f:cidade></f:cidade>
        <f:dias_preferencia>
            <f:day>2021-12-24</f:day>
            <f:day>2021-12-23</f:day>
            <f:day>2021-12-22</f:day>
            <f:day>2021-12-21</f:day>
        </f:dias_preferencia>
    </family>
</visits>
  let $rand := random:uuid()
  return (    
      copy $change := $body
      modify (replace value of node $change//@id with "art")
      return $change )