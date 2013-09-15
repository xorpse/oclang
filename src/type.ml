
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

let rec int_of_type = function
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
   | FirstBuiltin -> int_of_type Void
   | LastBuiltin  -> int_of_type ObjCSel
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

let type_of_int = function
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
