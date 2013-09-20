
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

val of_cursor : Cursor.t -> t
val name : t -> string

val resolve_typedef : t -> t

val int_type_of_enum : t -> t
val int64_of_enum_const_decl : t -> int64
val uint64_of_enum_const_decl : t -> Uint64.t

val bit_width : t -> int option

val canonical : t -> t

val is_const_qualified : t -> bool
val is_volatile_qualified : t -> bool
val is_restrict_qualified : t -> bool

val of_pointee : t -> t

val declaration : t -> t

val objc_type_encoding : t -> string

val kind_to_string : kind -> string

val calling_convention : t -> calling_conv

val result_type : t -> t

val argument_count : t -> int option
val arguments : t -> t list

val is_variadic : t -> bool
val is_plain_old_data : t -> bool

val of_element : t -> t
val element_count : t -> int option
val of_array_element : t -> t
val array_size : t -> int option

val align_of : t -> int64
val size_of : t -> int64
val offset_of : t -> string -> int64
