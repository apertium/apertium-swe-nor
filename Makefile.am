###############################################################################
## Makefile for Swedish--Norwegian
###############################################################################

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

TARGETS_COMMON =                                               \
    $(TARGETS_PREFIX1) $(TARGETS_PREFIX1n) $(TARGETS_PREFIX1b) \
    $(TARGETS_PREFIX2) $(TARGETS_PREFIX2n) $(TARGETS_PREFIX2b)

TARGETS_PREFIX1 =                                                 \
      $(PREFIX1).prob                                             \
      $(PREFIX1).rlx.bin
TARGETS_PREFIX1n =                                                \
      $(PREFIX1n).automorf.bin                                    \
      $(PREFIX1n).autopgen.bin                                    \
      $(PREFIX1n).autobil.bin                                     \
      $(PREFIX1n).autolex.bin                                     \
      $(PREFIX1n).t1x.bin $(PREFIX1n).t2x.bin $(PREFIX1n).t3x.bin \
      $(PREFIX1n).autogen.bin
TARGETS_PREFIX1b =                                                \
      $(PREFIX1b).automorf.bin                                    \
      $(PREFIX1b).autobil.bin                                     \
      $(PREFIX1b).autolex.bin                                     \
      $(PREFIX1b).t1x.bin $(PREFIX1b).t2x.bin $(PREFIX1b).t3x.bin \
      $(PREFIX1b).autogen.bin

TARGETS_PREFIX2 =              \
      $(PREFIX2).autoseq.bin   \
      $(PREFIX2).autobil.bin   \
      $(PREFIX2).autogen.bin   \
      $(PREFIX2).t1x.bin       \
      $(PREFIX2).t2x.bin       \
      $(PREFIX2).t3x.bin
TARGETS_PREFIX2n =             \
      $(PREFIX2n).prob         \
      $(PREFIX2n).automorf.bin \
      $(PREFIX2n).rlx.bin      \
      $(PREFIX2n).autolex.bin
TARGETS_PREFIX2b =             \
      $(PREFIX2b).prob         \
      $(PREFIX2b).automorf.bin \
      $(PREFIX2b).seg.rlx.bin  \
      $(PREFIX2b).rlx.bin      \
      $(PREFIX2b).autolex.bin


# Debug/development goals:
e: modes/$(PREFIX1b).mode	# build just nob-swe
	cd $(AP_SRC1) && ${MAKE} $(LANG1).autogen.bin
	cd $(AP_SRC2b) && ${MAKE} $(LANG2b).automorf.bin  $(LANG2b).seg.rlx.bin $(LANG2b).rlx.bin $(LANG2b).prob
	${MAKE} $(TARGETS_PREFIX2) $(TARGETS_PREFIX2b)
r: modes/$(PREFIX1b).mode $(PREFIX2b).autolex.bin $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin # build just transfer and rlx files for nob-nno(_e)
	cd $(AP_SRC2b) && ${MAKE} $(LANG2b).seg.rlx.bin $(LANG2b).rlx.bin
	${MAKE} $(PREFIX2b).seg.rlx.bin $(PREFIX2b).rlx.bin $(PREFIX2).autoseq.bin


# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Monolingual dictionaries
###############################################################################

# Swedish

$(PREFIX1b).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin $(PREFIX1b).autobil.bin
	lt-trim $^ $@

$(PREFIX1n).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin $(PREFIX1n).autobil.bin
	lt-trim $^ $@

$(PREFIX2).autogen.bin: $(AP_SRC1)/$(LANG1).autogen.bin
	cp $< $@


# Norwegian

$(PREFIX2b).automorf.bin: $(AP_SRC2b)/$(LANG2b).automorf.bin $(PREFIX2).autobil.bin
	lt-trim $(AP_SRC2b)/$(LANG2b).automorf.bin $(PREFIX2).autobil.bin $@

$(PREFIX2n).automorf.bin: $(AP_SRC2n)/$(LANG2n).automorf.bin $(PREFIX2).autobil.bin
	lt-trim $(AP_SRC2n)/$(LANG2n).automorf.bin $(PREFIX2).autobil.bin $@


$(PREFIX1b).autogen.bin: $(AP_SRC2b)/$(LANG2b).autogen.bin
	cp $< $@

$(PREFIX1n).autogen.bin: $(AP_SRC2n)/$(LANG2n).autogen.bin
	cp $< $@

$(PREFIX1n).autopgen.bin: $(AP_SRC2n)/$(LANG2n).autopgen.bin
	cp $< $@


###############################################################################
## Disambiguation models
###############################################################################

$(PREFIX1).prob: $(AP_SRC1)/$(LANG1).prob
	cp $< $@

$(PREFIX2b).prob: $(AP_SRC2b)/$(LANG2b).prob
	cp $< $@

$(PREFIX2n).prob: $(AP_SRC2n)/$(LANG2n).prob
	cp $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(PREFIX1).rlx.bin: $(AP_SRC1)/apertium-$(LANG1).$(LANG1).rlx
	cg-comp $< $@

$(PREFIX2b).seg.rlx.bin: $(AP_SRC2b)/apertium-$(LANG2b).$(LANG2b).seg.rlx
	cg-comp $< $@

$(PREFIX2b).rlx.bin: $(AP_SRC2b)/apertium-$(LANG2b).$(LANG2b).rlx
	cg-comp $< $@

$(PREFIX2n).rlx.bin: $(AP_SRC2n)/apertium-$(LANG2n).$(LANG2n).rlx
	cg-comp $< $@


###############################################################################
## Lexical selection rules
###############################################################################

%.autolex.bin: $(BASENAME).%.lrx
	lrx-comp $< $@

###############################################################################
## Separable / discontiguous multiwords
###############################################################################

$(PREFIX1).autoseq.bin: $(BASENAME).$(PREFIX1).lsx
	lsx-comp lr $< $@

$(PREFIX2).autoseq.bin: $(BASENAME).$(PREFIX2).lsx
	lsx-comp lr $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1b).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp --var-right=nob lr $< $@

$(PREFIX1n).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp --var-right=nno lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@


###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1b).t1x.bin: $(BASENAME).$(PREFIX1b).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1b).t2x.bin: $(BASENAME).$(PREFIX1b).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1b).t3x.bin: $(BASENAME).$(PREFIX1b).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


$(PREFIX1n).t1x.bin: $(BASENAME).$(PREFIX1n).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1n).t2x.bin: $(BASENAME).$(PREFIX1n).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1n).t3x.bin: $(BASENAME).$(PREFIX1n).t3x
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
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(PREFIX1).dix \
	   $(BASENAME).$(PREFIX1b).lrx \
	   $(BASENAME).$(PREFIX1n).lrx \
	   $(BASENAME).$(PREFIX2b).lrx \
	   $(BASENAME).$(PREFIX2n).lrx \
	   $(BASENAME).$(PREFIX1n).t1x \
	   $(BASENAME).$(PREFIX1b).t1x \
	   $(BASENAME).$(PREFIX1n).t2x \
	   $(BASENAME).$(PREFIX1b).t2x \
	   $(BASENAME).$(PREFIX1n).t3x \
	   $(BASENAME).$(PREFIX1b).t3x \
	   $(BASENAME).$(PREFIX2).t1x \
	   $(BASENAME).$(PREFIX2).t2x \
	   $(BASENAME).$(PREFIX2).t3x \
	   modes.xml

###############################################################################
## Installation
###############################################################################

apertium_swe_nordir=$(prefix)/share/apertium/apertium-$(PREFIX1)/

apertium_swe_nor_DATA=$(TARGETS_COMMON) \
	$(BASENAME).$(PREFIX1n).t1x \
	$(BASENAME).$(PREFIX1b).t1x \
	$(BASENAME).$(PREFIX1n).t2x \
	$(BASENAME).$(PREFIX1b).t2x \
	$(BASENAME).$(PREFIX1n).t3x \
	$(BASENAME).$(PREFIX1b).t3x \
	$(BASENAME).$(PREFIX2).t1x \
	$(BASENAME).$(PREFIX2).t2x \
	$(BASENAME).$(PREFIX2).t3x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1b).mode


install-data-local: install-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	apertium-regtest test

# Slow but near-complete test of dictionary consistency:
test-gen-%: all
	! dev/testvoc/generation.sh --hfst $*

test-voc: test-gen-swe-nno \
          test-gen-swe-nob \
          test-gen-nno-swe \
          test-gen-nob-swe

test-progression: all
	t/progression translate
	t/progression diff-expected

update-progression: all
	t/progression translate
	t/progression update
