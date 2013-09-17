AC_INIT([OCLANG], [0.0.1])
AC_CONFIG_SRCDIR([src/oClang.ml])
AC_CONFIG_AUX_DIR([m4])
AM_INIT_AUTOMAKE([-Wno-portability])

AC_PROG_CC

AC_PROG_OCAML
if test "$OCAMLC" = "no"; then
   AC_MSG_ERROR([OCaml compiler not found.])
fi

if test "$OCAMLOPT" = "no"; then
   BUILDTARGETS="byte"
else
   BUILDTARGETS="byte opt"
fi

AC_SUBST([BUILDTARGETS])

AC_PROG_FINDLIB
if test "$OCAMLFIND" = "no"; then
   AC_MSG_ERROR([OCaml findlib not found.])
fi

AC_CHECK_TOOL([LLVM_CONFIG], [llvm-config], [no]) 
if test "$LLVM_CONFIG_FOUND" = "no"; then
   AC_MSG_ERROR([llvm-config binary not found.])
fi

AC_SUBST([LLVM_CONFIG])

CPPFLAGS="${CPPFLAGS} -I ${OCAMLLIB}"

AC_CHECK_HEADERS([string.h])
AC_CHECK_HEADERS([caml/custom.h caml/mlvalues.h caml/alloc.h caml/memory.h caml/fail.h caml/callback.h],
                 [],
                 [AC_MSG_ERROR([required OCaml support headers not found.])])
AC_CHECK_HEADERS([clang-c/Index.h],
                 [],
                 [AC_MSG_ERROR([required libclang support headers not found.])])

AC_OUTPUT([config.make Makefile src/META src/Makefile])
