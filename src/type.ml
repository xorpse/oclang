
(*
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
*)

type t

type kind =
   | Invalid
   | Unexposed
   | Void
   | Bool
   | Char_U
   | UChar
   | Char16
   | Char32
   | UShort
   | UInt
   | ULong
   | ULongLong
   | UInt128
   | Char_S
   | SChar
   | WChar
   | Short
   | Int
   | Long
   | LongLong
   | Int128
   | Float
   | Double
   | LongDouble
   | NullPtr
   | Overload
   | Dependent
   | ObjCId
   | ObjCClass
   | ObjCSel
   | FirstBuiltin
   | LastBuiltin
   | Complex
   | Pointer
   | BlockPointer
   | LValueReference
   | RValueReference
   | Record
   | Enum
   | Typedef
   | ObjCInterface
   | ObjCObjectPointer
   | FunctionNoProto
   | FunctionProto
   | ConstantArray
   | Vector
   | IncompleteArray
   | VariableArray
   | DependentSizedArray

type calling_conv =
   | CallingConv_Default
   | CallingConv_C
   | CallingConv_X86StdCall
   | CallingConv_X86FastCall
   | CallingConv_X86ThisCall
   | CallingConv_X86Pascal
   | CallingConv_AAPCS
   | CallingConv_AAPCS_VFP
   | CallingConv_PnaclCall
   | CallingConv_IntelOclBicc
   | CallingConv_X86_64Win64
   | CallingConv_X86_64SysV
   | CallingConv_Invalid
   | CallingConv_Unexposed

type layout_error =
   | InvalidLayout
   | IncompleteLayout
   | DependentLayout
   | NotConstantSize
   | InvalidFieldName

exception InvalidEnumDecl
exception LayoutError of layout_error

let () = Callback.register_exception "ml_libclang_exn_type_invalid_enum_decl" InvalidEnumDecl

let rec int_of_kind = function
   | Invalid -> 0
   | Unexposed -> 1
   | Void -> 2
   | Bool -> 3
   | Char_U -> 4
   | UChar -> 5
   | Char16 -> 6
   | Char32 -> 7
   | UShort -> 8
   | UInt -> 9
   | ULong -> 10
   | ULongLong -> 11
   | UInt128 -> 12
   | Char_S -> 13
   | SChar -> 14
   | WChar -> 15
   | Short -> 16
   | Int -> 17
   | Long -> 18
   | LongLong -> 19
   | Int128 -> 20
   | Float -> 21
   | Double -> 22
   | LongDouble -> 23
   | NullPtr -> 24
   | Overload -> 25
   | Dependent -> 26
   | ObjCId -> 27
   | ObjCClass -> 28
   | ObjCSel -> 29
   | FirstBuiltin -> int_of_kind Void
   | LastBuiltin  -> int_of_kind ObjCSel
   | Complex -> 100
   | Pointer -> 101
   | BlockPointer -> 102
   | LValueReference -> 103
   | RValueReference -> 104
   | Record -> 105
   | Enum -> 106
   | Typedef -> 107
   | ObjCInterface -> 108
   | ObjCObjectPointer -> 109
   | FunctionNoProto -> 110
   | FunctionProto -> 111
   | ConstantArray -> 112
   | Vector -> 113
   | IncompleteArray -> 114
   | VariableArray -> 115
   | DependentSizedArray -> 116

let kind_of_int = function
   | 0 -> Invalid
   | 1 -> Unexposed
   | 2 -> Void
   | 3 -> Bool
   | 4 -> Char_U
   | 5 -> UChar
   | 6 -> Char16
   | 7 -> Char32
   | 8 -> UShort
   | 9 -> UInt
   | 10 -> ULong
   | 11 -> ULongLong
   | 12 -> UInt128
   | 13 -> Char_S
   | 14 -> SChar
   | 15 -> WChar
   | 16 -> Short
   | 17 -> Int
   | 18 -> Long
   | 19 -> LongLong
   | 20 -> Int128
   | 21 -> Float
   | 22 -> Double
   | 23 -> LongDouble
   | 24 -> NullPtr
   | 25 -> Overload
   | 26 -> Dependent
   | 27 -> ObjCId
   | 28 -> ObjCClass
   | 29 -> ObjCSel
   | 100 -> Complex
   | 101 -> Pointer
   | 102 -> BlockPointer
   | 103 -> LValueReference
   | 104 -> RValueReference
   | 105 -> Record
   | 106 -> Enum
   | 107 -> Typedef
   | 108 -> ObjCInterface
   | 109 -> ObjCObjectPointer
   | 110 -> FunctionNoProto
   | 111 -> FunctionProto
   | 112 -> ConstantArray
   | 113 -> Vector
   | 114 -> IncompleteArray
   | 115 -> VariableArray
   | 116 -> DependentSizedArray
   | _ -> assert false

let int_of_calling_conv = function
   | CallingConv_Default -> 0
   | CallingConv_C -> 1
   | CallingConv_X86StdCall -> 2
   | CallingConv_X86FastCall -> 3
   | CallingConv_X86ThisCall -> 4
   | CallingConv_X86Pascal -> 5
   | CallingConv_AAPCS -> 6
   | CallingConv_AAPCS_VFP -> 7
   | CallingConv_PnaclCall -> 8
   | CallingConv_IntelOclBicc -> 9
   | CallingConv_X86_64Win64 -> 10
   | CallingConv_X86_64SysV -> 11
   | CallingConv_Invalid -> 100
   | CallingConv_Unexposed -> 200

let calling_conv_of_int = function
   | 0 -> CallingConv_Default
   | 1 -> CallingConv_C
   | 2 -> CallingConv_X86StdCall
   | 3 -> CallingConv_X86FastCall
   | 4 -> CallingConv_X86ThisCall
   | 5 -> CallingConv_X86Pascal
   | 6 -> CallingConv_AAPCS
   | 7 -> CallingConv_AAPCS_VFP
   | 8 -> CallingConv_PnaclCall
   | 9 -> CallingConv_IntelOclBicc
   | 10 -> CallingConv_X86_64Win64
   | 11 -> CallingConv_X86_64SysV
   | 100 -> CallingConv_Invalid
   | 200 -> CallingConv_Unexposed
   | _ -> assert false

external of_cursor : Cursor.t -> t = "ml_libclang_cxtype_of_cursor"
external name : t -> string = "ml_libclang_cxtype_name"
external kind' : t -> int = "ml_libclang_cxtype_kind"
let kind t = kind_of_int (kind' t)

external resolve_typedef : t -> t = "ml_libclang_cxtype_resolve_typedef"

external int_type_of_enum : t -> t = "ml_libclang_cxtype_int_type_of_enum"
external int64_of_enum_const_decl : t -> int64 = "ml_libclang_cxtype_int_type_of_const_enum"
external uint_of_enum_const_decl' : t -> int64 = "ml_libclang_cxtype_uint_type_of_const_enum"
let uint64_of_enum_const_decl t =
   Uint64.of_int64 (uint_of_enum_const_decl' t)

external bit_width : t -> int option = "ml_libclang_cxtype_bit_width"

external canonical : t -> t = "ml_libclang_cxtype_canonical"

external is_const_qualified : t -> bool = "ml_libclang_cxtype_is_const_qualified"
external is_volatile_qualified : t -> bool = "ml_libclang_cxtype_is_volatile_qualified"
external is_restrict_qualified : t -> bool = "ml_libclang_cxtype_is_restrict_qualified"

external of_pointee : t -> t = "ml_libclang_cxtype_of_pointee"

external declaration : t -> t = "ml_libclang_cxtype_declaration"

external objc_type_encoding : t -> string = "ml_libclang_cxtype_objc_type_enc"

external kind_to_string' : int -> string = "ml_libclang_cxtype_kind_name"
let kind_to_string t = kind_to_string' (int_of_kind t)

external calling_convention' : t -> int = "ml_libclang_cxtype_calling_convention"
let calling_convention t = calling_conv_of_int (calling_convention' t)

external result_type : t -> t = "ml_libclang_cxtype_result_type"

external argument_count : t -> int option = "ml_libclang_cxtype_argument_count"
external arguments : t -> t list = "ml_libclang_cxtype_arguments"

external is_variadic : t -> bool = "ml_libclang_cxtype_is_variadic"
external is_plain_old_data : t -> bool = "ml_libclang_cxtype_is_pod"

external of_element : t -> t = "ml_libclang_cxtype_of_element"
external element_count : t -> int option = "ml_libclang_cxtype_element_count"
external of_array_element : t -> t = "ml_libclang_cxtype_of_array_element"
external array_size : t -> int option = "ml_libclang_cxtype_array_size"

external align_of : t -> int64 = "ml_libclang_cxtype_alignment_of"
external size_of : t -> int64 = "ml_libclang_cxtype_size_of"
external offset_of : t -> string -> int64 = "ml_libclang_cxtype_offset_of"
