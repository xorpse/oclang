
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
#include "type.h"

int ml_libclang_compare_cxtype(value t1, value t2)
{
	return(!clang_equalTypes(CXType_val(t1), CXType_val(t2)));
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
	value v = alloc_custom(&libclang_cxtype_ops, sizeof(CXType), 0, 1);
	memcpy(Data_custom_val(v), &type, sizeof(CXType));
	return(v);
}

CAMLprim value ml_libclang_cxtype_of_cursor(value cursor)
{
   CAMLparam1(cursor);
   CAMLreturn(ml_libclang_alloc_cxtype(clang_getCursorType(CXCursor_val(cursor))));
}

/* FIXME: > v0.6 */
#if CINDEX_VERSION > CINDEX_VERSION_ENCODE(0, 6)
CAMLprim value ml_libclang_cxtype_name(value type)
{
   CAMLparam1(type);
   CAMLlocal1(name);

   CXString str = clang_getTypeSpelling(CXType_val(type));
   name = caml_copy_string(clang_getCString(str));
   clang_disposeString(str);

   CAMLreturn(name);
}
#endif

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

/* TODO (will require Uint): CAMLprim value ml_libclang_cxtype_int_val_of_enum(value cursor) */

/* FIXME: > 0.6 */
#if CINDEX_VERSION > CINDEX_VERSION_ENCODE(0, 6)
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
#endif

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
      caml_raise(*caml_named_value("ml_libclang_exn_type_not_function")); /* FIXME */
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

/* TODO (requires int64)
02933 enum CXTypeLayoutError {
02935    * \brief Type is of kind CXType_Invalid.
02937   CXTypeLayoutError_Invalid = -1,
02939    * \brief The type is an incomplete Type.
02941   CXTypeLayoutError_Incomplete = -2,
02943    * \brief The type is a dependent Type.
02945   CXTypeLayoutError_Dependent = -3,
02947    * \brief The type is not a constant size type.
02949   CXTypeLayoutError_NotConstantSize = -4,
02951    * \brief The Field name is not valid for this record.
02953   CXTypeLayoutError_InvalidFieldName = -5
02955 
02957  * \brief Return the alignment of a type in bytes as per C++[expr.alignof]
02958  *   standard.
02959  *
02960  * If the type declaration is invalid, CXTypeLayoutError_Invalid is returned.
02961  * If the type declaration is an incomplete type, CXTypeLayoutError_Incomplete
02962  *   is returned.
02963  * If the type declaration is a dependent type, CXTypeLayoutError_Dependent is
02964  *   returned.
02965  * If the type declaration is not a constant size type,
02966  *   CXTypeLayoutError_NotConstantSize is returned.
02968 CINDEX_LINKAGE long long clang_Type_getAlignOf(CXType T);
02969 
02971  * \brief Return the size of a type in bytes as per C++[expr.sizeof] standard.
02972  *
02973  * If the type declaration is invalid, CXTypeLayoutError_Invalid is returned.
02974  * If the type declaration is an incomplete type, CXTypeLayoutError_Incomplete
02975  *   is returned.
02976  * If the type declaration is a dependent type, CXTypeLayoutError_Dependent is
02977  *   returned.
02979 CINDEX_LINKAGE long long clang_Type_getSizeOf(CXType T);
02980 
02982  * \brief Return the offset of a field named S in a record of type T in bits
02983  *   as it would be returned by __offsetof__ as per C++11[18.2p4]
02984  *
02985  * If the cursor is not a record field declaration, CXTypeLayoutError_Invalid
02986  *   is returned.
02987  * If the field's type declaration is an incomplete type,
02988  *   CXTypeLayoutError_Incomplete is returned.
02989  * If the field's type declaration is a dependent type,
02990  *   CXTypeLayoutError_Dependent is returned.
02991  * If the field's name S is not found,
02992  *   CXTypeLayoutError_InvalidFieldName is returned.
02994 CINDEX_LINKAGE long long clang_Type_getOffsetOf(CXType T, const char *S);
02995 
*/
