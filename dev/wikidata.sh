#!/bin/bash

test -f globes.jq || bzcat ~/corpora/wikidata-20160229-all.json.bz2 \
        | grep  '^{' \
        | sed 's/,$//'   \
        | jq -c 'if .claims.P625 then { "da":.labels.da.value, "sv":.labels.sv.value, "nn":.labels.nn.value, "no":.labels.no.value, "nb":.labels.nb.value } else null end ' \
        | grep -vFxe null -e '{"da":null,"sv":null,"nn":null,"no":null,"nb":null}' \
               >globes.jq

svnn () { jq -c '[.sv,.nn]'|grep -vFe ',null]' -e '[null,' |jq -r '@tsv' ;  }

# Only include those pairs that actually appear in a Wikipedia:
bzcat ~/corpora/svwiki-20160111-pages-articles.xml.bz2 \
    | tr '[:space:][:punct:]' '\n' \
    | gawk -v dict=<(svnn < globes.jq) '
BEGIN{OFS=FS="\t";
while(getline<dict)d[$1][$2]++} {
  # Make uni, bi, tri, quad, pentagrams:
  bi=p1" "$0;tri=p2" "bi;quad=p3" "tri;pent=p4" "quad;
  # and shift:
  p4=p3;p3=p2;p2=p1;p1=$0;
  for(src in h){delete h[src]}
  h[$0]++;h[bi]++;h[tri]++;h[quad]++;h[pent]++;
  for(src in h)if(src in d)seen[src]++
}
END{for(src in seen)for(trg in d[src])print seen[src],src,trg}' \
    | sort -nr > pairs.tsv
