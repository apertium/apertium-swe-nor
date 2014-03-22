###############################################################################
## Makefile for Swedish--Norwegian
###############################################################################

VERSION=1.0.0
LANG1=swe
LANG2=nor
LANG2n=nno
LANG2b=nob

# swe-nor
PREFIX1=$(LANG1)-$(LANG2)
# swe-nob
PREFIX1b=$(LANG1)-$(LANG2b)
# swe-nno
PREFIX1n=$(LANG1)-$(LANG2n)
# nor-swe
PREFIX2=$(LANG2)-$(LANG1)
# nob-swe
PREFIX2b=$(LANG2b)-$(LANG1)
# nno-swe
PREFIX2n=$(LANG2n)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = \
      $(PREFIX1).prob \
      $(PREFIX1b).automorf.bin \
      $(PREFIX1n).automorf.bin \
      $(PREFIX1).rlx.bin \
      $(PREFIX1b).autobil.bin \
      $(PREFIX1n).autobil.bin \
      $(PREFIX1).autolex.bin \
      $(PREFIX1b).autogen.bin \
      $(PREFIX1).t1x.bin \
      $(PREFIX1).t2x.bin \
      $(PREFIX1).t3x.bin \
      $(PREFIX1n).autogen.bin \
      $(PREFIX2n).prob \
      $(PREFIX2b).prob \
      $(PREFIX2b).automorf.bin \
      $(PREFIX2n).automorf.bin \
      $(PREFIX2b).rlx.bin \
      $(PREFIX2n).rlx.bin \
      $(PREFIX2).autobil.bin \
      $(PREFIX2).autolex.bin \
      $(PREFIX2).autogen.bin \
      $(PREFIX2).t1x.bin \
      $(PREFIX2).t2x.bin \
      $(PREFIX2).t3x.bin


# Use this goal for creating .deps, otherwise make -j2 will give problems:
.deps/.d:
	if [ ! -d .deps ]; then mkdir .deps; fi
	touch $@

# Prevent the .d file from being removed automatically:
.PRECIOUS: .deps/.d

###############################################################################
## Monolingual dictionaries
###############################################################################

# Swedish

$(PREFIX1b).automorf.bin: $(AP_LIB1)/$(LANG1).automorf.bin $(PREFIX1b).autobil.bin
	lt-trim $^ $@

$(PREFIX1n).automorf.bin: $(AP_LIB1)/$(LANG1).automorf.bin $(PREFIX1n).autobil.bin
	lt-trim $^ $@

$(PREFIX2).autogen.bin: $(AP_LIB1)/$(LANG1).autogen.bin
	cp $< $@


# Norwegian

$(PREFIX2b).automorf.bin: $(AP_LIB2b)/$(LANG2b).automorf.bin $(PREFIX2).autobil.bin
	lt-trim $(AP_LIB2b)/$(LANG2b).automorf.bin $(PREFIX2).autobil.bin $@

$(PREFIX2n).automorf.bin: $(AP_LIB2n)/$(LANG2n).automorf.bin $(PREFIX2).autobil.bin
	lt-trim $(AP_LIB2n)/$(LANG2n).automorf.bin $(PREFIX2).autobil.bin $@


$(PREFIX1b).autogen.bin: $(AP_LIB2b)/$(LANG2b).autogen.bin
	cp $< $@

$(PREFIX1n).autogen.bin: $(AP_LIB2n)/$(LANG2n).autogen.bin
	cp $< $@



###############################################################################
## Disambiguation models
###############################################################################

$(PREFIX1).prob: $(AP_LIB1)/$(LANG1).prob
	cp $< $@

$(PREFIX2b).prob: $(AP_LIB2b)/$(LANG2b).prob
	cp $< $@

$(PREFIX2n).prob: $(AP_LIB2n)/$(LANG2n).prob
	cp $< $@

###############################################################################
## Disambiguation rules 
###############################################################################

$(PREFIX1).rlx.bin: $(AP_SRC1)/apertium-$(LANG1).$(LANG1).rlx
	cg-comp $< $@ 

$(PREFIX2b).rlx.bin: $(AP_SRC2b)/apertium-$(LANG2b).$(LANG2b).rlx
	cg-comp $< $@

$(PREFIX2n).rlx.bin: $(AP_SRC2n)/apertium-$(LANG2n).$(LANG2n).rlx
	cg-comp $< $@


###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1b).autobil.bin: $(BASENAME).$(PREFIX1).dix
	lt-comp --var-right=nob lr $< $@

$(PREFIX1n).autobil.bin: $(BASENAME).$(PREFIX1).dix
	lt-comp --var-right=nno lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	lt-comp rl $< $@


###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@



###############################################################################
## Translation modes
###############################################################################

modes/$(PREFIX1b).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1b).mode

EXTRA_DIST=$(BASENAME).$(LANG1).dix \
	   $(BASENAME).$(PREFIX1).dix \
	   $(BASENAME).$(LANG1).rlx \
	   $(BASENAME).$(LANG2b).rlx $(BASENAME).$(LANG2n).rlx \
	   $(BASENAME).$(PREFIX1b).lrx \
	   $(BASENAME).$(PREFIX1n).lrx \
	   $(BASENAME).$(PREFIX2b).lrx \
	   $(BASENAME).$(PREFIX2n).lrx \
           $(PREFIX1).prob \
	   $(BASENAME).$(PREFIX1).t1x \
	   $(BASENAME).$(PREFIX1).t2x \
	   $(BASENAME).$(PREFIX1).t3x \
	   $(BASENAME).$(PREFIX2).t1x \
	   $(BASENAME).$(PREFIX2).t2x \
	   $(BASENAME).$(PREFIX2).t3x \
	   $(BASENAME).$(LANG1).acx \
	   $(BASENAME).$(LANG2).acx \
	   modes.xml

apertium_swe_nordir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_modesdir=$(prefix)/share/apertium/modes/

apertium_swe_nor_DATA=$(TARGETS_COMMON) \
    $(PREFIX1).prob \
    modes.xml 


install-data-local:
	mv modes modes.bak
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	rm -rf modes
	mv modes.bak modes
	test -d $(DESTDIR)$(apertium_modesdir) || mkdir $(DESTDIR)$(apertium_modesdir)
	modes=`xmllint --xpath '//mode[@install="yes"]/@name' modes.xml | sed 's/ *name="\([^"]*\)"/\1.mode /g'`; \
		$(INSTALL_DATA) $$modes $(DESTDIR)$(apertium_modesdir); \
		rm $$modes
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_swe_nordir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t2x $(DESTDIR)$(apertium_swe_nordir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t3x $(DESTDIR)$(apertium_swe_nordir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_swe_nordir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(DESTDIR)$(apertium_swe_nordir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t3x $(DESTDIR)$(apertium_swe_nordir)


CLEANFILES = $(TARGETS_COMMON) 
clean-local: 
	-rm -rf .deps modes

