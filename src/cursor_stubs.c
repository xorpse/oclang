
/*
Copyright (c) 2013, Sam Thomas All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <string.h>

#include <caml/custom.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include <clang-c/Index.h>
#include "index.h"
#include "translation_unit.h"
#include "cursor.h"

CAMLprim int ml_libclang_compare_cxcursor(value c1, value c2)
{
   CAMLparam2(c1, c2);
	CAMLreturnT(int, !clang_equalCursors(CXCursor_val(c1), CXCursor_val(c2)));
}

CAMLprim long ml_libclang_hash_cxcursor(value cursor)
{
   CAMLparam1(cursor);
	CAMLreturnT(long, clang_hashCursor(CXCursor_val(cursor)));
}

static struct custom_operations libclang_cxcursor_ops = {
   "sh.ghost.ml.libclang_cxcursor",
	custom_finalize_default,
	ml_libclang_compare_cxcursor,
	ml_libclang_hash_cxcursor,
   custom_serialize_default,
   custom_deserialize_default
};


value ml_libclang_alloc_cxcursor(CXCursor cursor)
{
   CAMLparam0();
   CAMLlocal1(v);
	v = alloc_custom(&libclang_cxcursor_ops, sizeof(CXCursor), 0, 1);
	memcpy(Data_custom_val(v), &cursor, sizeof(CXCursor));
	CAMLreturn(v);
}

CAMLprim value ml_libclang_cxcursor_null(value unit)
{
	CAMLparam1(unit);
	CAMLreturn(ml_libclang_alloc_cxcursor(clang_getNullCursor()));
}

CAMLprim value ml_libclang_cxcursor_is_null(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(Val_bool(!!clang_Cursor_isNull(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_of_translation_unit(value tu)
{
	CAMLparam1(tu);
	CAMLreturn(ml_libclang_alloc_cxcursor(clang_getTranslationUnitCursor(CXTranslationUnit_val(tu))));
}

CAMLprim value ml_libclang_cxcursor_to_translation_unit(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(ml_libclang_alloc_cxtranslationunit(clang_Cursor_getTranslationUnit(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_kind(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(Val_int(clang_getCursorKind(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_is_declaration(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isDeclaration(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_is_reference(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isReference(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_is_expression(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isExpression(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_is_statement(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isStatement(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_is_attribute(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isAttribute(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_is_invalid(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isInvalid(Int_val(kind))));
}
CAMLprim value ml_libclang_cxcursor_is_translation_unit(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isTranslationUnit(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_is_preprocessing(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isPreprocessing(Int_val(kind))));
}
CAMLprim value ml_libclang_cxcursor_is_unexposed(value kind)
{
	CAMLparam1(kind);
	CAMLreturn(Val_bool(!!clang_isUnexposed(Int_val(kind))));
}

CAMLprim value ml_libclang_cxcursor_access(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(Val_int(clang_getCXXAccessSpecifier(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_overloaded_decl_count(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Int_val(clang_getNumOverloadedDecls(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_overloaded_decls(value cursor)
{
   CAMLparam1(cursor);
   CAMLlocal2(xs, tmp);

   int count = 0;

   xs = Val_emptylist;
   
   while (count--) {
      tmp = caml_alloc(2, 0);
      Store_field(tmp, 0, ml_libclang_alloc_cxcursor(clang_getOverloadedDecl(CXCursor_val(cursor), count)));
      Store_field(tmp, 1, xs);
      xs = tmp;
   }
   CAMLreturn(xs);
}

CAMLprim value ml_libclang_cxcursor_linkage(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(Val_int(clang_getCursorLinkage(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_language(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(Val_int(clang_getCursorLanguage(CXCursor_val(cursor))));
}

enum CXChildVisitResult ml_libclang_cxcursor_visitor(CXCursor cursor, CXCursor parent, CXClientData client_data)
{
	CAMLparam0();
	CAMLlocal1(xs);

	xs = caml_alloc(2, 0);
	Store_field(xs, 0, ml_libclang_alloc_cxcursor(cursor));
	Store_field(xs, 1, *((value *)client_data));

	*((value *)client_data) = xs;

	CAMLreturnT(enum CXChildVisitResult, CXChildVisit_Continue);
}

CAMLprim value ml_libclang_cxcursor_children(value cursor)
{
	CAMLparam1(cursor);
	CAMLlocal1(xs);

	xs = Val_emptylist;
	clang_visitChildren(CXCursor_val(cursor), ml_libclang_cxcursor_visitor, &xs);

	CAMLreturn(xs);
}

CAMLprim value ml_libclang_cxcursor_semantic_parent(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(ml_libclang_alloc_cxcursor(clang_getCursorSemanticParent(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_lexical_parent(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(ml_libclang_alloc_cxcursor(clang_getCursorLexicalParent(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_name(value cursor)
{
	CAMLparam1(cursor);
	CAMLlocal1(name);

	CXString str = clang_getCursorSpelling(CXCursor_val(cursor));
	name = caml_copy_string(clang_getCString(str));
	clang_disposeString(str);

	CAMLreturn(name);
}

CAMLprim value ml_libclang_cxcursor_display_name(value cursor)
{
	CAMLparam1(cursor);
	CAMLlocal1(display_name);

	CXString str = clang_getCursorDisplayName(CXCursor_val(cursor));
	display_name = caml_copy_string(clang_getCString(str));
	clang_disposeString(str);

	CAMLreturn(display_name);
}

CAMLprim value ml_libclang_cxcursor_argument_count(value cursor)
{
	CAMLparam1(cursor);
	CAMLlocal1(argn);

	int count = 0;

	if ((count = clang_Cursor_getNumArguments(CXCursor_val(cursor))) != -1) {
		argn = caml_alloc(1, 0);
		Store_field(argn, 0, Val_int(argn));
	} else {
		argn = Val_int(0); /* None */
	}

	CAMLreturn(argn);
}

CAMLprim value ml_libclang_cxcursor_arguments(value cursor)
{
	CAMLparam1(cursor);
	CAMLlocal2(xs, tmp);

	int count = 0;
	
	if ((count = clang_Cursor_getNumArguments(CXCursor_val(cursor))) != -1) {
		xs = Val_emptylist;
		while (count--) {
			tmp = caml_alloc(2, 0);
			Store_field(tmp, 0, ml_libclang_alloc_cxcursor(clang_Cursor_getArgument(CXCursor_val(cursor), count)));
			Store_field(tmp, 1, xs);
			xs = tmp;
		}
		CAMLreturn(xs);
	} else {
		caml_raise_constant(*caml_named_value("ml_libclang_exn_cursor_no_args"));
	}
}

CAMLprim value ml_libclang_cxcursor_location(value cursor)
{
	CAMLparam1(cursor);
	CAMLlocal1(v);

	CXFile file;
	CXString fname;
	unsigned int row, col, off;

	v = caml_alloc_tuple(7);

	CXSourceRange range = clang_getCursorExtent(CXCursor_val(cursor));
	CXSourceLocation loc = clang_getRangeStart(range);

	clang_getSpellingLocation(loc, &file, &row, &col, &off);

	fname = clang_getFileName(file);
	Store_field(v, 0, caml_copy_string(clang_getCString(fname)));
	clang_disposeString(fname);

	Store_field(v, 1, Val_int(row));
	Store_field(v, 2, Val_int(col));
	Store_field(v, 3, Val_int(off));

	loc = clang_getRangeEnd(range);
	clang_getSpellingLocation(loc, &file, &row, &col, &off);

	Store_field(v, 4, Val_int(row));
	Store_field(v, 5, Val_int(col));
	Store_field(v, 6, Val_int(off));

	CAMLreturn(v);
}

CAMLprim value ml_libclang_cxcursor_referenced(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(ml_libclang_alloc_cxcursor(clang_getCursorReferenced(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_definition(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(ml_libclang_alloc_cxcursor(clang_getCursorDefinition(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_is_definition(value cursor)
{
	CAMLparam1(cursor);
	CAMLreturn(Val_bool(!!clang_isCursorDefinition(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_is_bit_field(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Val_bool(!!clang_Cursor_isBitField(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_is_virtual_base(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Val_bool(!!clang_isVirtualBase(CXCursor_val(cursor))));
}

/* CXX Specifics */
#if CINDEX_VERSION >= CINDEX_VERSION_ENCODE(0, 20) /* Not present in clang 3.3 (0, 19) (Arch Linux) */
CAMLprim value ml_libclang_cxcursor_cxx_meth_is_pure_virtual(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Val_bool(!!clang_CXXMethod_isPureVirtual(CXCursor_val(cursor))));
}
#endif

CAMLprim value ml_libclang_cxcursor_cxx_meth_is_static(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Val_bool(!!clang_CXXMethod_isStatic(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_cxx_meth_is_virtual(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Val_bool(!!clang_CXXMethod_isVirtual(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_cxx_kind_of_template(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(Int_val(clang_getTemplateCursorKind(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxcursor_cxx_specialized_cursor_template(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(ml_libclang_alloc_cxcursor(clang_getSpecializedCursorTemplate(CXCursor_val(cursor))));
}

enum CXVisitorResult find_visitor(void *ctx, CXCursor cursor, CXSourceRange range) /* range can be obtained with Cursor.location */
{
   CAMLparam0();
   CAMLlocal1(xs);

   xs = caml_alloc(2, 0);
   Store_field(xs, 0, ml_libclang_alloc_cxcursor(cursor));
   Store_field(xs, 1, *((value *)ctx));

   *((value *)ctx) = xs;
   CAMLreturnT(enum CXVisitorResult, CXVisit_Continue);
}

CAMLprim value ml_libclang_cxcursor_find_includes_of(value tu, value file)
{
   CAMLparam2(tu, file);
   CAMLlocal1(includes);

   CXFile f = clang_getFile(CXTranslationUnit_val(tu), String_val(file));

   if (f) {
      includes = Val_emptylist;
      CXCursorAndRangeVisitor visitor = {
         .context = &includes,
         .visit = find_visitor
      };
      clang_findIncludesInFile(CXTranslationUnit_val(tu), f, visitor);
      CAMLreturn(includes);
   } else {
      caml_raise_with_arg(*caml_named_value("ml_libclang_exn_cursor_no_such_file"), file);
   }
}

CAMLprim value ml_libclang_cxcursor_find_references_to(value cursor, value file)
{
   CAMLparam2(cursor, file);
   CAMLlocal1(references);

   CXTranslationUnit tu = clang_Cursor_getTranslationUnit(CXCursor_val(cursor));
   CXFile f = clang_getFile(CXTranslationUnit_val(tu), String_val(file));

   if (f) {
      references = Val_emptylist;
      CXCursorAndRangeVisitor visitor = {
         .context = &references,
         .visit = find_visitor
      };
      clang_findReferencesInFile(CXCursor_val(cursor), f, visitor);
      CAMLreturn(references);
   } else {
      caml_raise_with_arg(*caml_named_value("ml_libclang_exn_cursor_no_such_file"), file);
   }
}

