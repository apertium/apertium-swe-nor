#!/bin/bash

bzcat ~/corpora/wikidata-20160229-all.json.bz2 \
    | grep  '^{' \
    | sed 's/,$//'   \
    | jq -c 'if .claims.P625 then { "da":.labels.da.value, "sv":.labels.sv.value, "nn":.labels.nn.value, "no":.labels.no.value, "nb":.labels.nb.value } else null end ' \
    | grep -vFxe null -e '{"da":null,"sv":null,"nn":null,"no":null,"nb":null}' \
           >globes.jq

svnn () { < globes.jq jq -c '[.sv,.nn]'|grep -vFe ',null]' -e '[null,' |jq -r '@tsv' ;  }

# Only include those pairs that actually appear in a Wikipedia:
bzcat ~/corpora/svwiki-20160111-pages-articles.xml.bz2 \
    | tr '[:space:][:punct:]' '\n' \
    | gawk -v svnn=<(svnn) '
BEGIN{OFS=FS="\t";
while(getline<svnn)s[$1][$2]++} {
  bi=p1" "$0;tri=p2" "bi;quad=p3" "tri;pent=p4" "quad;p4=p3;p3=p2;p2=p1;p1=$0;
  for(sv in h){delete h[sv]}
  h[$0]++;h[bi]++;h[tri]++;h[quad]++;h[pent]++;
  for(sv in h)if(sv in s)for(nn in s[sv])print sv,nn
}'
