
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

void ml_libclang_finalize_cxtranslationunit(value tu)
{
   clang_disposeTranslationUnit(CXTranslationUnit_val(tu));
}

static struct custom_operations libclang_cxtranslationunit_ops = {
   "sh.ghost.ml.libclang_cxtranslationunit",
   ml_libclang_finalize_cxtranslationunit,
   custom_compare_default,
   custom_hash_default,
   custom_serialize_default,
   custom_deserialize_default
};

value ml_libclang_alloc_cxtranslationunit(CXTranslationUnit tu)
{
   if (tu) {
      value v = alloc_custom(&libclang_cxtranslationunit_ops, sizeof(CXTranslationUnit), 0, 1);
      CXTranslationUnit_val(v) = tu;
      return(v);
   } else {
      caml_raise_constant(*caml_named_value("ml_libclang_exn_tu_alloc"));
   }
}

CAMLprim value ml_libclang_create_cxtranslationunit(value idx, value ast_fn)
{
   CAMLparam2(idx, ast_fn);
   CAMLreturn(ml_libclang_alloc_cxtranslationunit(clang_createTranslationUnit(CXIndex_val(idx), String_val(ast_fn))));
}

CAMLprim value ml_libclang_create_cxtranslationunit_from_source_file(value idx, value src_fn, value args)
{
   CAMLparam3(idx, src_fn, args);
   CAMLlocal2(xs, v);

   char **c_args = NULL;
   unsigned int n_args = 0;

   xs = args;
   while (xs != Val_emptylist) {
      n_args++;
      xs = Field(xs, 1);
   }
   
   c_args = (char **)malloc(sizeof(char **) * n_args);

   xs = args;
   n_args = 0;
   while (xs != Val_emptylist) {
      c_args[n_args++] = String_val(Field(xs, 0));
      xs = Field(xs, 1);
   }

   v = ml_libclang_alloc_cxtranslationunit(clang_createTranslationUnitFromSourceFile(CXIndex_val(idx), String_val(src_fn), Int_val(n_args), (const char *const *)c_args, 0, NULL));

   free(c_args);

   CAMLreturn(v);
}

CAMLprim value ml_libclang_save_cxtranslationunit(value tu, value fname)
{
   CAMLparam2(tu, fname);

   int ret = clang_saveTranslationUnit(CXTranslationUnit_val(tu), String_val(fname), CXSaveTranslationUnit_None);

   if (ret == CXSaveTranslationUnit_None) {
      CAMLreturn(Val_unit);
   } else {
      caml_raise_with_arg(*caml_named_value("ml_libclang_exn_tu_save"), Val_int(ret - 1)); // Unknown -> 0, TranslationErrors -> 1, etc. 
   }
}

unsigned int process_tu_options(value opts)
{
   value xs = opts;

   unsigned int options = CXTranslationUnit_None;

   while (xs != Val_emptylist) {
      switch (Int_val(Field(xs, 0)))
      {
         case 0:
            options |= CXTranslationUnit_None;
            break;
         case 1:
            options |= CXTranslationUnit_DetailedPreprocessingRecord;
            break;
         case 2:
            options |= CXTranslationUnit_Incomplete;
            break;
         case 3:
            options |= CXTranslationUnit_PrecompiledPreamble;
            break;
         case 4:
            options |= CXTranslationUnit_CacheCompletionResults;
            break;
         case 5:
            options |= CXTranslationUnit_ForSerialization;
            break;
         case 6:
            options |= CXTranslationUnit_CXXChainedPCH;
            break;
         case 7:
            options |= CXTranslationUnit_SkipFunctionBodies;
            break;
         case 8:
            options |= CXTranslationUnit_IncludeBriefCommentsInCodeCompletion;
            break;
         default:
            caml_invalid_argument("TranslationUnit.options");
      }
      xs = Field(xs, 1);
   }

   return(options);
}

CAMLprim value ml_libclang_parse_cxtranslationunit(value idx, value fname, value args, value opts)
{
   CAMLparam4(idx, fname, args, opts);
   CAMLlocal2(xs, v);

   char **c_args = NULL;
   unsigned int n_args = 0;
   unsigned int options = CXTranslationUnit_None;

   xs = args;
   while (xs != Val_emptylist) {
      n_args++;
      xs = Field(xs, 1);
   }
   
   c_args = (char **)malloc(sizeof(char **) * n_args);

   xs = args;
   n_args = 0;
   while (xs != Val_emptylist) {
      c_args[n_args++] = String_val(Field(xs, 0));
      xs = Field(xs, 1);
   }

   v = ml_libclang_alloc_cxtranslationunit(clang_parseTranslationUnit(CXIndex_val(idx), String_val(fname), (const char *const *)c_args, n_args, NULL, 0, process_tu_options(opts)));

   free(c_args);

   CAMLreturn(v);
}

CAMLprim value ml_libclang_reparse_cxtranslationunit(value tu, value opts)
{
   CAMLparam2(tu, opts);
   
   if (clang_reparseTranslationUnit(CXTranslationUnit_val(tu), 0, NULL, process_tu_options(opts))) {
      caml_raise_constant(*caml_named_value("ml_libclang_exn_tu_reparse"));
   } else {
      CAMLreturn(Val_unit);
   }
}
