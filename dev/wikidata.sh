#!/bin/bash

# Scratch functions; see
# https://meta.wikimedia.org/wiki/Grants:Learning_patterns/Using_Wikidata_to_make_Machine_Translation_dictionary_entries
# for more readable code

test -f globes.jq || bzcat ~/corpora/wikidata-20160229-all.json.bz2 \
        | grep  '^{' \
        | sed 's/,$//'   \
        | jq -c 'if .claims.P625 then { "da":.labels.da.value, "sv":.labels.sv.value, "nn":.labels.nn.value, "no":.labels.no.value, "nb":.labels.nb.value } else null end ' \
        | grep -vFxe null -e '{"da":null,"sv":null,"nn":null,"no":null,"nb":null}' \
               >globes.jq

svnn () { jq -c '[.sv,.nn]'|grep -vFe ',null]' -e '[null,' |jq -r '@tsv' ;  }

# Only include those pairs that actually appear in a Wikipedia:
test -f pairs.tsv || bzcat ~/corpora/svwiki-20160111-pages-articles.xml.bz2 \
    | tr '[:space:][:punct:]' '\n' \
    | gawk -v dict=<(svnn < globes.jq) '
BEGIN{OFS=FS="\t";
while(getline<dict)d[$1][$2]++}
{
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


<pairs.tsv gawk '
BEGIN{OFS=FS="\t"}

# http://awk.freeshell.org/LevenshteinEditDistance
function levdist(str1, str2,    l1, l2, tog, arr, i, j, a, b, c) {
        if (str1 == str2) {
                return 0
        } else if (str1 == "" || str2 == "") {
                return length(str1 str2)
        } else if (substr(str1, 1, 1) == substr(str2, 1, 1)) {
                a = 2
                while (substr(str1, a, 1) == substr(str2, a, 1)) a++
                return levdist(substr(str1, a), substr(str2, a))
        } else if (substr(str1, l1=length(str1), 1) == substr(str2, l2=length(str2), 1)) {
                b = 1
                while (substr(str1, l1-b, 1) == substr(str2, l2-b, 1)) b++
                return levdist(substr(str1, 1, l1-b), substr(str2, 1, l2-b))
        }
        for (i = 0; i <= l2; i++) arr[0, i] = i
        for (i = 1; i <= l1; i++) {
                arr[tog = ! tog, 0] = i
                for (j = 1; j <= l2; j++) {
                        a = arr[! tog, j  ] + 1
                        b = arr[  tog, j-1] + 1
                        c = arr[! tog, j-1] + (substr(str1, i, 1) != substr(str2, j, 1))
                        arr[tog, j] = (((a<=b)&&(a<=c)) ? a : ((b<=a)&&(b<=c)) ? b : c)
                }
        }
        return arr[tog, j-1]
}

$1 > 1 && $2!~/^[0-9]*$/ && $3!~/^[0-9]*$/ { print levdist($2,$3),$0}
' | sort -nr > lev.tsv


svnnnb () { jq -r 'select(.sv and .nn and .nb)|[.sv,.nn,.nb]|@tsv' ; }
svnnnb <globes.jq|sed $'s/\( i \| (\|,\)[^\t]*//'

<lev.tsv.checked gawk -v dict=<(svnnnb <globes.jq|sed $'s/\( i \| (\|,\)[^\t]*//g') '
BEGIN{OFS=FS="\t";
while(getline<dict)d[$1][$2][$3]++}
$2 in d && $3 in d[$2]{for(t in d[$2][$3])print $0,t; next}
{print}'  >with-nb.tsv

<apertium-swe-nor.swe-nor.dix gawk '
BEGIN{OFS=FS="\t";
        while(getline<"with-nb.tsv")if(/^[+]/){
                        if($4) s[$2][$3][$4]++
                        else s[$2][$3]["_"]++
                }
}

/<s n="np"/ {
        l=gensub(/.*<l>(.*)<\/l>.*/,"\\1","1")
        sub(/<s .*/,"",l)
        gsub(/<b\/>/," ",l)
        r=gensub(/.*<r>(.*)<\/r>.*/,"\\1","1")
        sub(/<s .*/,"",r)
        gsub(/<b\/>/," ",r)
        if(/vr="nno"/)seen["nno"][l][r]++
        else if(/vr="nob"/)seen["nob"][l][r]++
        else {
                seen["nno"][l][r]++
                seen["nob"][l][r]++
        }
}

END {
        for(sv in s)for(nn in s[sv]) {
                        bsv=gensub(/ /,"<b/>","g",sv)
                        bnn=gensub(/ /,"<b/>","g",nn)
                        if("_" in s[sv][nn]) {
                                if(!(sv in seen["nno"]&&nn in seen["nno"][sv]))
                                        printf "<e vr=\"nno\"><p><l>%s<s n=\"np\"/><s n=\"top\"/></l>   <r>%s<s n=\"np\"/><s n=\"top\"/></r></p></e>\n", bsv, bnn
                        }
                        else for(nb in s[sv][nn]) {
                                        bnb=gensub(/ /,"<b/>","g",nb)
                                        if(nn == nb && !(sv in seen["nno"]&&nn in seen["nno"][sv])) {
                                                printf "<e>         <p><l>%s<s n=\"np\"/><s n=\"top\"/></l>     <r>%s<s n=\"np\"/><s n=\"top\"/></r></p></e>\n", bsv, bnn

                                        }
                                        else {
                                                if(!(sv in seen["nno"]&&nn in seen["nno"][sv]))
                                                        printf "<e vr=\"nno\"><p><l>%s<s n=\"np\"/><s n=\"top\"/></l>   <r>%s<s n=\"np\"/><s n=\"top\"/></r></p></e>\n", bsv, bnn
                                                if(!(sv in seen["nob"]&&nb in seen["nob"][sv]))
                                                        printf "<e vr=\"nob\"><p><l>%s<s n=\"np\"/><s n=\"top\"/></l>   <r>%s<s n=\"np\"/><s n=\"top\"/></r></p></e>\n", bsv, bnb
                                        }

                                }
                }
}
' >new-bidix-entries.dix
