
(** Functions for operations on Type types
@see <http://clang.llvm.org/doxygen/group__CINDEX__TYPES.html> Official C API Documentation *)

(** Abstract Type type *)
type t

(** Possible kinds of a Type *)
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

(** Possible calling conventions *)
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
(** [of_cursor cursor] produces the type of a given [cursor] *)

val name : t -> string
(** [name cursor] produces a string representation of the name of the given [cursor] *)

val kind : t -> kind

val resolve_typedef : t -> t
(** [resolve_typedef type] produces the underlying type of the given [type] *)

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
(** [argument_count type] produces the number of arguments of the given [type] or [None] if the type is a non-function type *)

val arguments : t -> t list
(** [arguments type] produces the types of the arguments of the given [type]
@raise NotFunction if [type] is a non-function type *)

val is_variadic : t -> bool
val is_plain_old_data : t -> bool

val of_element : t -> t
(** [of_element type] produces the type of the elements within the given array/complex/vector type *)

val element_count : t -> int option
(** [element_count type] produces the number of elements of the given array/vector type, or [None] *)

val of_array_element : t -> t
(** [of_array_element type] produces the element type of the given array [type] *)

val array_size : t -> int option
(** [array_size type] produces the number of elements within the given array [type], or [None] *)

val align_of : t -> int64
val size_of : t -> int64
val offset_of : t -> string -> int64
