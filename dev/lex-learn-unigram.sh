#!/bin/bash

# Extremely simple "choose-the-most-frequent" lex-rule-learner

# Uses target language freqs based on tagged and "stemmed" corpus, ie.
# removes all subtag info (plural/singular etc.) and sums frequencies
# of all forms of a lemma+mainpos.

# LANG1 and LANG2 here refer to the *final* lrx file; this is flipped
# in the command that tags the target language corpus for frequencies.

set -e -u

PAIR=${LANG1}-${LANG2}
RPAIR=${LANG2}-${LANG1}

cleantags () {
    # Only nouns get a single subtag
    sed 's/\(<np*><\(nt\|[mf][mf]*\|ut\)>\)[^:]*/\1/g;
         s/<adj><\(pp\|pprs\)>[^:]*/<vblex>/g
         s/\(<\(adj\|vblex\|adv\|prn\|det\)>\)[^:]*/\1/g'
}

mk () {
    # Because make is such a drag
    local -r goal="$1"
    if [[ -f ${goal} ]]; then
        echo "${goal} exists, not recreating" >&2
    else
        mkcmd >"${goal}".tmp
        mv "${goal}".tmp "${goal}"
    fi
}

TAGGED="${RPAIR}".tagged
mkcmd () { xzcat "${LANG2}".corp.xz | parallel --pipe apertium -d . "${RPAIR}"-tagger | apertium-cleanstream -n; }
mk "${TAGGED}"

mkcmd () { sort "${TAGGED}" | uniq -c | sort -nr | sed $'s/^ *//;s/ /\t/'; }
mk "${TAGGED}".hitparade

# This'll make it non-unique; we simply sum freqs of lemmas in the awk
mkcmd () { < "${TAGGED}".hitparade cleantags |tr -d '^$'; }
mk "${TAGGED}".hitparade.clean

mkcmd () { grep -v "vr=\"${OTHERVR}\"" apertium-swe-nor.swe-nor.dix; }
mk "${PAIR}".dix


if [[ ${LANG1} = swe ]]; then
    flip=0
else
    flip=1
fi

mkcmd () { lt-expand "${PAIR}".dix | cleantags |sort -u; }
mk "${PAIR}".exp.clean


gawk -v flip=${flip} -v fpath="${TAGGED}".hitparade.clean -F':|:[<>]:' '
{
  if(flip) {
    if(/:>:/) { next }
    bi[$2][$1]++
  }
  else {
    if(/:<:/) { next }
    bi[$1][$2]++
  }
}

END {
  FS="\t"
  while(getline<fpath)f[$2]+=$1

  for(src in bi)if(length(bi[src])>1) {
                for(trg in bi[src]) {
                  if(trg in f) {
                    lrx[src][trg]=f[trg]
                  }
                }
              }
  PROCINFO["sorted_in"] = "@val_num_desc"
  for(src in lrx)for(trg in lrx[src]) {
                   slem=gensub("<.*", "", "1", src)
                   tlem=gensub("<.*", "", "1", trg)
                   stag=gensub(">*$", ".*", "1", gensub("><", ".", "g", gensub("[^<]*<", "", "1", src)))
                   ttag=gensub(">*$", ".*", "1", gensub("><", ".", "g", gensub("[^<]*<", "", "1", trg)))
                   printf "<rule weight=\"0.9\"><match lemma=\"%s\" tags=\"%s\"><select lemma=\"%s\" tags=\"%s\"/></match></rule><!-- %d -->\n", slem, stag, tlem, ttag, lrx[src][trg]
                   break
  }

}' "${PAIR}".exp.clean
