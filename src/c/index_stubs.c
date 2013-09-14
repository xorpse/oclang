
#include <caml/custom.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include <clang-c/Index.h>
#include "index.h"

void ml_libclang_finalize_cxindex(value idx)
{
   clang_disposeIndex(CXIndex_val(idx));
}

static struct custom_operations libclang_cxindex_ops = {
   "sh.ghost.ml.libclang_cxindex",
   ml_libclang_finalize_cxindex,
   custom_compare_default,
   custom_hash_default,
   custom_serialize_default,
   custom_deserialize_default
};

value ml_libclang_alloc_cxindex(CXIndex idx)
{
   value v = alloc_custom(&libclang_cxindex_ops, sizeof(CXIndex), 0, 1);
   CXIndex_val(v) = idx;
   return(v);
}

CAMLprim value ml_libclang_create_cxindex(value exclude_decls_from_PCH, value display_diagnostics)
{
   CAMLparam2(exclude_decls_from_PCH, display_diagnostics);
   CAMLreturn(ml_libclang_alloc_cxindex(clang_createIndex(Bool_val(exclude_decls_from_PCH), Bool_val(display_diagnostics))));
}
