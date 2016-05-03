#!/usr/bin/gawk -f

# temporary/scratch

# dev/testvoc/generation.sh --hfst swe-nno | grep 'vblex><inf><actv>' \
#    |grep -o '#[^ ]*vblex' |sed 's/\\.*//;s/^#//'|LC_ALL=C sort -u >/tmp/missing

# lt-expand /l/n/apertium-nno-nob.nno-nob.dix |grep 'vblex.*vblex'|sed 's/<vblex>.*:/   /;s/<vblex.*//' \
#   | awk 'BEGIN{OFS=FS="\t"; }$1!=$2 { print $2,$1 }'| LC_ALL=C sort -u > /tmp/nno-nob-verbs

# LC_ALL=C join -j1 -t$'\t'  /tmp/missing /tmp/nno-nob-verbs >/tmp/tofix

BEGIN{
	OFS=FS="\t";
	while(getline<"/tmp/tofix"){
		gsub(" ","<b/>")
		$0=gensub("#(.*)","<g>\\1</g>","1")
		n[$1][$2]++
	}
}

/vblex/{
	r=gensub(/.*<r>(.*)<\/r>.*/,"\\1","1");
}

/"vblex"/ && r in n && !/vr="/{
	for(b in n[r]){
		e=gensub(/<r>.*<\/r>/,"<r>"b"</r>","1")
		print gensub(/^<e([^>]*)> */,"<e vr=\"nno\"\\1>","1",e)
	}
	print gensub(/^<e([^>]*)> */,"<e vr=\"nob\"\\1>","1");
	next
}

{
	print
}
