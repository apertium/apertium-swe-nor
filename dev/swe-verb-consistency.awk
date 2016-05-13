#!/usr/bin/gawk -f

# lt-expand apertium-swe.swe.dix > /tmp/swe.exp

# gawk -v swe_exp=/tmp/swe.exp -f dev/swe-verb-consistency.awk apertium-swe-nor.swe-nor.dix >/tmp/incons

# gawk 'BEGIN{FS=":::"; while(getline<"/tmp/incons"){par[$1]=$2} } {l = gensub(".*<l>(.*)</l>.*","\\1","1")} /<par n="vblex"/&&l in par{print gensub(/(<par n="vblex)"/,"\\1_"par[l]"\"","1");next}{print}' apertium-swe-nor.swe-nor.dix  > new-bidix


BEGIN{
	while(getline<swe_exp) {
		if(!(/<vblex>|<adj><pp/)) {
			continue
		}
		lm = gensub(" ", "<b/>","g",
			    gensub("#(.*)","<g>\\1</g>", "1",
				   gensub(".*:([^<]*)<[^#]*","\\1","1")))
		v[lm]++
		if(/<pp>/)pp[lm]++
		if(/<pprs>/)pprs[lm]++
		if(/<pasv>/)pasv[lm]++
		if(/<past><pasv>/)pastpasv[lm]++
		if(/<inf>/)inf[lm]++
		if(/<pres>/)pres[lm]++
		if(/<past>/)past[lm]++
		if(/<actv>/)actv[lm]++
	}
}

/<par n="vblex/ {
	l = gensub(".*<l>(.*)</l>.*","\\1","1")
	if(!(l in pres) && $0!~/<par.*no-pres/) {
		print l":::no-pres"
	}
	if(!(l in past) && $0!~/<par.*no-past/) {
		print l":::no-past"
	}
	if(!(l in actv) && $0!~/<par.*pasv/) {
		print l":::pasv"
	}
	else if(!(l in pp || l in pprs) && $0!~/<par.*(no-adj|pstv)"/) {
		print l":::no-adj"
	}
	else if(!(l in pp || l in acvt) && $0!~/<par.*no-adjpp-pasv"/) {
		print l":::no-adjpp-pasv"
	}
	else if(!(l in pp) && $0!~/<par.*no-adjpp"/) {
		print l":::no-adjpp"
	}
	else if(!(l in pastpasv || l in pp) && $0!~/<par.*no-adjpp-pastpasv"/) {
		print l":::no-adjpp-pastpasv"
	else if(!(l in pastpasv) && $0!~/<par.*no-pastpasv"/) {
		print l":::no-pastpasv"
	}
}
