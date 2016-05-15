#!/usr/bin/gawk -f

# lt-expand apertium-swe.swe.dix > /tmp/swe.exp

# gawk -v swe_exp=/tmp/swe.exp -f dev/swe-verb-consistency.awk apertium-swe-nor.swe-nor.dix >/tmp/incons

# gawk 'BEGIN{FS=":::"; while(getline<"/tmp/incons"){par[$1]=$2} } {l = gensub(".*<l>(.*)</l>.*","\\1","1")} /<par n="vblex"/&&l in par{print gensub(/(<par n="vblex)"/,"\\1_"par[l]"\"","1");next}{print}' apertium-swe-nor.swe-nor.dix  > new-bidix


BEGIN{
	while(getline<swe_exp) {
		if(!(/<n>/)) {
			continue
		}
		lm = gensub(" ", "<b/>","g",
			    gensub("#(.*)","<g>\\1</g>", "1",
				   gensub(".*:([^<]*)<[^#]*","\\1","1")))
		n[lm]++
		if(/<pl>/)pl[lm]++
		if(/<sg>/)sg[lm]++
		if(/<ut>/)ut[lm]++
		if(/<un>/)un[lm]++
		if(/<nt>/)nt[lm]++
		if(/<def>/)def[lm]++
		if(/<ind>/)ind[lm]++
	}
}

/<s n="n".*<r>/ {
	l = gensub(/<s n="[^"]*"\/>/, "", "g",
		   gensub(".*<l>(.*)</l>.*","\\1","1"))
	if(!(l in n)) {
		print l":::no-n"
		next
	}
	if(!(l in pl) && $0!~/<par n="@sg/) {
		print l":::no-pl"
	}
	if(!(l in sg) && $0!~/<par n="@pl/) {
		print l":::no-sg"
	}
	#
	if(!(l in un) && $0~/<s n="un".*<r>/) {
		x=""
		if(l in ut)x=x":ut"
		if(l in nt)x=x":nt"
		print l":::no-un"x
	}
	if(!(l in ut) && $0~/<s n="ut".*<r>/) {
		x=""
		if(l in un)x=x":un"
		if(l in nt)x=x":nt"
		print l":::no-ut"x
	}
	if(!(l in nt) && $0~/<s n="nt".*<r>/) {
		x=""
		if(l in ut)x=x":ut"
		if(l in un)x=x":un"
		print l":::no-nt"x
	}
}
