
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

#include <caml/custom.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include <clang-c/Index.h>
#include "index.h"

CAMLprim void ml_libclang_finalize_cxindex(value idx)
{
   CAMLparam1(idx);
   clang_disposeIndex(CXIndex_val(idx));
   CAMLreturn0;
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
   CAMLparam0();
   CAMLlocal1(v);
   v = alloc_custom(&libclang_cxindex_ops, sizeof(CXIndex), 0, 1);
   CXIndex_val(v) = idx;
   CAMLreturn(v);
}

CAMLprim value ml_libclang_create_cxindex(value exclude_decls_from_PCH, value display_diagnostics)
{
   CAMLparam2(exclude_decls_from_PCH, display_diagnostics);
   CAMLreturn(ml_libclang_alloc_cxindex(clang_createIndex(Bool_val(exclude_decls_from_PCH), Bool_val(display_diagnostics))));
}
