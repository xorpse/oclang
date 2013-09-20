ACLOCAL_AMFLAGS = -I ../m4

-include ../config.make

CFLAGS = `${LLVM_CONFIG} --cflags` -fPIC
CPPFLAGS = `${LLVM_CONFIG} --cppflags` -I $(OCAMLLIB)
LDFLAGS = -lclang

oclang_SRC = index.mli index.ml \
				 translationUnit.mli translationUnit.ml \
				 cursor.mli cursor.ml \
				 type.mli type.ml \
				 oClang.ml \
				 index_stubs.c \
				 translation_unit_stubs.c \
				 cursor_stubs.c \
				 type_stubs.c

C_OBJS = $(patsubst %.c, %.o, $(filter %.c,$(oclang_SRC)))
ML_BYTE_OBJS = $(patsubst %.ml, %.cmo, $(filter %.ml,$(oclang_SRC)))
ML_OPT_OBJS = $(patsubst %.ml, %.cmx, $(filter %.ml,$(oclang_SRC)))

EXPORTED_OBJS = oClang
INSTALL_OBJS = $(addsuffix .cmi, $(EXPORTED_OBJS))

EXTRA_DIST = $(oclang_SRC) .depend

TARGETS = @BUILDTARGETS@

all: $(TARGETS)

byte: oclang.cma liboclang.a
opt: oclang.cmxa dlloclang.so oclang.cmxs

oclang.cma liboclang.a : $(ML_BYTE_OBJS) $(C_OBJS)
	$(OCAMLFIND) ocamlmklib -custom -o oclang -oc oclang -linkpkg -package @OCAML_PKG_uint@ $^ $(LDFLAGS)

oclang.cmxa dlloclang.so: $(ML_OPT_OBJS) $(C_OBJS)
	$(OCAMLFIND) ocamlmklib -o oclang -oc oclang -linkpkg -package @OCAML_PKG_uint@ $^ $(LDFLAGS)

oclang.cmxs: oclang.cmxa
	$(OCAMLOPT) -shared $^ -o $@ -I .

install: all
	mkdir -p $(DESTDIR)$(INSTALLDIR) $(DESTDIR)$(OCAMLLIB)/stublibs
	install -m 644 *.mli *.ml $(INSTALL_OBJS) *.cma lib*.a $(DESTDIR)$(INSTALLDIR)
	if test -f dlloclang.so; then \
		install -m 644 *.cmxa *.a *.cmx $(DESTDIR)$(INSTALLDIR); \
		install -m 755 dll*.so $(DESTDIR)$(INSTALLDIR); \
	fi

install-findlib: all
	$(OCAMLFIND) install oclang META *.mli *.ml $(INSTALL_OBJS) *.cma *.a $(wildcard *.cmxs) $(wildcard *.cmxa) $(wildcard *.so)

clean:
	-rm -f *.cm* *.o *.a *.so META

.mli.cmi:
	$(OCAMLFIND) ocamlc -c $< -linkpkg -package @OCAML_PKG_uint@

.ml.cmo:
	$(OCAMLFIND) ocamlc -c $< -linkpkg -package @OCAML_PKG_uint@

.ml.cmx:
	$(OCAMLFIND) ocamlopt -c $< -linkpkg -package @OCAML_PKG_uint@

.c.o:
	$(CC) -c $< $(CPPFLAGS) $(CFLAGS)

-include .depend

.PHONY: oclang all install clean
