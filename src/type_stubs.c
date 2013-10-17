
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
#include <clang-c/CXString.h>
#include "index.h"
#include "translation_unit.h"
#include "cursor.h"
#include "type.h"

CAMLprim int ml_libclang_compare_cxtype(value t1, value t2)
{
   CAMLparam2(t1, t2);
	CAMLreturnT(int, !clang_equalTypes(CXType_val(t1), CXType_val(t2)));
}

static struct custom_operations libclang_cxtype_ops = {
   "sh.ghost.ml.libclang_cxtype",
   custom_finalize_default,
   ml_libclang_compare_cxtype,
   custom_hash_default,
   custom_serialize_default,
   custom_deserialize_default
};

value ml_libclang_alloc_cxtype(CXType type)
{
   CAMLparam0();
   CAMLlocal1(v);
	v = alloc_custom(&libclang_cxtype_ops, sizeof(CXType), 0, 1);
	memcpy(Data_custom_val(v), &type, sizeof(CXType));
	CAMLreturn(v);
}

CAMLprim value ml_libclang_cxtype_of_cursor(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getCursorType(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxtype_name(value type)
{
   CAMLparam1(type);
   CAMLlocal1(name);

   CXString str = clang_getTypeSpelling(CXType_val(type));
   name = caml_copy_string(clang_getCString(str));
   clang_disposeString(str);

   CAMLreturn(name);
}

CAMLprim value ml_libclang_cxtype_kind(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_int(CXType_val(type).kind));
}

CAMLprim value ml_libclang_cxtype_resolve_typedef(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getTypedefDeclUnderlyingType(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxtype_int_type_of_enum(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getEnumDeclIntegerType(CXCursor_val(cursor))));
}

int ml_libclang_is_valid_const_enum_decl(CXCursor cursor)
{
   CAMLparam0();
   CAMLreturnT(int, clang_getEnumDeclIntegerType(cursor).kind != CXType_Invalid);
}

CAMLprim value ml_libclang_cxtype_int_type_of_const_enum(value cursor)
{
   CAMLparam1(cursor);

   if (ml_libclang_is_valid_const_enum_decl(CXCursor_val(cursor))) {
      CAMLreturn(caml_copy_int64(clang_getEnumConstantDeclValue(CXCursor_val(cursor))));
   } else {
      caml_raise_constant(*caml_named_value("ml_libclang_exn_type_invalid_enum_decl"));
   }
}

CAMLprim value ml_libclang_cxtype_uint_type_of_const_enum(value cursor)
{
   CAMLparam1(cursor);

   if (ml_libclang_is_valid_const_enum_decl(CXCursor_val(cursor))) {
      /* Recast this back to unsigned on OCaml side using uint64 */
      CAMLreturn(caml_copy_int64((long long)clang_getEnumConstantDeclUnsignedValue(CXCursor_val(cursor))));
   } else {
      caml_raise_constant(*caml_named_value("ml_libclang_exn_type_invalid_enum_decl"));
   }
}

CAMLprim value ml_libclang_cxtype_bit_width(value cursor)
{
   CAMLparam1(cursor);
   CAMLlocal1(v);

   int ret = clang_getFieldDeclBitWidth(CXCursor_val(cursor));
   if (ret != -1) {
      v = caml_alloc(1, 0);
      Store_field(v, 0, Val_int(ret));
   } else {
      v = Val_int(0);
   }

   CAMLreturn(v);
}

CAMLprim value ml_libclang_cxtype_canonical(value type)
{
   CAMLparam1(type);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getCanonicalType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_is_const_qualified(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_bool(!!clang_isConstQualifiedType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_is_volatile_qualified(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_bool(!!clang_isVolatileQualifiedType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_is_restrict_qualified(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_bool(!!clang_isRestrictQualifiedType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_of_pointee(value type)
{
   CAMLparam1(type);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getPointeeType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_declaration(value type)
{
   CAMLparam1(type);
   CAMLreturn(ml_libclang_alloc_cxcursor(clang_getTypeDeclaration(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_objc_type_enc(value cursor)
{
   CAMLparam1(cursor);
   CAMLlocal1(v);

   CXString str = clang_getDeclObjCTypeEncoding(CXCursor_val(cursor));
   v = caml_copy_string(clang_getCString(str));
   clang_disposeString(str);

   CAMLreturn(v);
}
   
CAMLprim value ml_libclang_cxtype_kind_name(value kind)
{
   CAMLparam1(kind);
   CAMLlocal1(v);

   CXString str = clang_getTypeKindSpelling(Int_val(kind));
   v = caml_copy_string(clang_getCString(str));
   clang_disposeString(str);

   CAMLreturn(v);
}

CAMLprim value ml_libclang_cxtype_calling_convention(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_int(clang_getFunctionTypeCallingConv(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_result_type(value type)
{
   CAMLparam1(type);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getResultType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_argument_count(value type)
{
   CAMLparam1(type);
   CAMLlocal1(v);

   int ret = clang_getNumArgTypes(CXType_val(type));
   if (ret != -1) {
      v = caml_alloc(1, 0);
      Store_field(v, 0, Val_int(ret));
   } else {
      v = Val_int(0);
   }

   CAMLreturn(v);
}

CAMLprim value ml_libclang_cxtype_arguments(value type)
{
   CAMLparam1(type);
   CAMLlocal2(xs, tmp);

   int count = 0;

   if ((count = clang_getNumArgTypes(CXType_val(type))) != -1) {
      xs = Val_emptylist;
      
      while (count--) {
         tmp = caml_alloc(2, 0);
         Store_field(tmp, 0, ml_libclang_alloc_cxtype(clang_getArgType(CXType_val(type), count)));
         Store_field(tmp, 1, xs);
         xs = tmp;
      }
      CAMLreturn(xs);
   } else {
      caml_raise_constant(*caml_named_value("ml_libclang_exn_type_not_function")); /* FIXME */
   }
}

CAMLprim value ml_libclang_cxtype_is_variadic(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_bool(!!clang_isFunctionTypeVariadic(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_result_of_cursor(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getCursorResultType(CXCursor_val(cursor))));
}

CAMLprim value ml_libclang_cxtype_is_pod(value type)
{
   CAMLparam1(type);
   CAMLreturn(Val_bool(!!clang_isPODType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_of_element(value type)
{
   CAMLparam1(type);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getElementType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_element_count(value type)
{
   CAMLparam1(type);
   CAMLlocal1(v);

   int ret = clang_getNumElements(CXType_val(type));
   if (ret != -1) {
      v = caml_alloc(1, 0);
      Store_field(v, 0, Val_int(ret));
   } else {
      v = Val_int(0);
   }

   CAMLreturn(v);
}

CAMLprim value ml_libclang_cxtype_of_array_element(value type)
{
   CAMLparam1(type);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getArrayElementType(CXType_val(type))));
}

CAMLprim value ml_libclang_cxtype_array_size(value type)
{
   CAMLparam1(type);
   CAMLlocal1(v);

   int ret = clang_getArraySize(CXType_val(type));
   if (ret != -1) {
      v = caml_alloc(2, 0);
      Store_field(v, 0, Val_int(ret));
   } else {
      v = Val_int(0);
   }

   CAMLreturn(v);
}

long long ml_libclang_map_type_layout_error(long long v)
{
   switch (v)
   {
      case CXTypeLayoutError_Invalid:
         return(0);
         break;
      case CXTypeLayoutError_Incomplete:
         return(1);
         break;
      case CXTypeLayoutError_Dependent:
         return(2);
         break;
      case CXTypeLayoutError_NotConstantSize:
         return(3);
         break;
      case CXTypeLayoutError_InvalidFieldName:
         return(4);
         break;
      default:
         return(v);
   }
}

CAMLprim value ml_libclang_cxtype_alignment_of(value type)
{
   CAMLparam1(type);

   long long v = clang_Type_getAlignOf(CXType_val(type));

   if (v < 0LL) {
      CAMLreturn(caml_copy_int64(ml_libclang_map_type_layout_error(v)));
   } else {
      CAMLreturn(caml_copy_int64(v));
   }
}

CAMLprim value ml_libclang_cxtype_size_of(value type)
{
   CAMLparam1(type);

   long long v = clang_Type_getSizeOf(CXType_val(type));

   if (v < 0LL) {
      CAMLreturn(caml_copy_int64(ml_libclang_map_type_layout_error(v)));
   } else {
      CAMLreturn(caml_copy_int64(v));
   }
}

CAMLprim value ml_libclang_cxtype_offset_of(value type, value field)
{
   CAMLparam2(type, field);

   long long v = clang_Type_getOffsetOf(CXType_val(type), String_val(field));

   if (v < 0LL) {
      CAMLreturn(caml_copy_int64(ml_libclang_map_type_layout_error(v)));
   } else {
      CAMLreturn(caml_copy_int64(v));
   }
}
