.PHONY: all clean

objdir := obj
distdir := dist
objlist := \
	lz4vram \
	pad \
	rand \
	memfill \
	vram_read \
	vram_unrle \
	oam_meta_spr_clip \
	oam_meta_spr_pal \
	oam_meta_spr \
	oam_spr \
	oam_clear_fast \
	split \
	splitxy

all: $(distdir)/crt0.o $(distdir)/neslib.lib

$(distdir)/neslib.lib: $(foreach o,$(objlist),$(objdir)/$(o).o)
	@mkdir -p $(distdir)
	ar65 a $@ $^

$(distdir)/crt0.o: $(objdir)/crt0.o
	@mkdir -p $(distdir)
	cp $< $@

$(objdir)/%.o: %.s $(wildcard *.s *.sinc)
	@mkdir -p $(objdir)
	cl65 --verbose --listing $(objdir)/$*.lst -o $@ -t nes -Oisr -g -c $*.s

clean:
	rm -f $(objdir)/* $(distdir)/*
