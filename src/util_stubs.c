
#include <caml/custom.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include <clang-c/Index.h>

CAMLprim value ml_libclang_util_version(value unit)
{
   CAMLparam1(unit);
   CAMLlocal1(version);

   CXString str = clang_getClangVersion();
   version = caml_copy_string(clang_getCString(str));
   clang_disposeString(str);

   CAMLreturn(version);
}

CAMLprim value ml_libclang_util_enable_crash_recovery(value opt)
{
   CAMLparam1(opt);
   clang_toggleCrashRecovery(Bool_val(opt));
   CAMLreturn(Val_unit);
}
