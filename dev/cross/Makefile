# Assumes full SVN apertium checkout available here:
SVNROOT=../../../..
# also, apertium-dixtools should be installed

all: cross.dix

cross.dix: cross-nno.dix cross-nob.dix cross-nor.dix
	cat $^ | rev|sort|rev > $@

cross-%.dix: cross-% exp-to-dix.awk
	awk -v vr="$*" -f exp-to-dix.awk $< > $@

cross-nno: nno.13 nob.13
	LC_ALL=C comm -23 $^ > $@
cross-nob: nno.13 nob.13
	LC_ALL=C comm -13 $^ > $@
cross-nor: nno.13 nob.13
	LC_ALL=C comm -12 $^ > $@

%.13: swe-nor.exp %/dix/apertium-swe-nor.swe-nor-crossed.exp
	LC_ALL=C comm -13 $^ | LC_ALL=C sort -u > $@

%.dix:: $(SVNROOT)/trunk/apertium-%
	cp $</apertium-$*.$*.dix $@

%.dix:: $(SVNROOT)/languages/apertium-%
	cp $</apertium-$*.$*.dix $@

%.dix:: $(SVNROOT)/nursery/apertium-%
	cp $</apertium-$*.$*.dix $@

%.exp: %.dix
	lt-expand $< $@.tmp
	LC_ALL=C sort -u $@.tmp > $@

%/dix/apertium-swe-nor.swe-nor-crossed.dix: %/swe-dan.dix %/dan-nor.dix %.dix swe.dix cross-model.xml
	(cd $*; apertium-dixtools cross-param ../swe.dix -r swe-dan.dix -n dan-nor.dix ../$*.dix ../cross-model.xml )


nob/%.dix: %.dix ./preproc.sh
	test -d nob || mkdir nob
	grep -v "vr=\"nno\"" $< | ./preproc.sh > $@.tmp
	mv $@.tmp $@

nno/%.dix: %.dix ./preproc.sh
	test -d nno || mkdir nno
	grep -v "vr=\"nob\"" $< | ./preproc.sh > $@.tmp
	mv $@.tmp $@

clean:
	rm -rf nno nob dan-nor.dix swe-dan.dix nno.dix nob.dix swe.dix swe-nor.exp nno.13 nob.13 cross-nno cross-nob cross-nor
