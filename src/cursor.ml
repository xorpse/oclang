
type t

type kind_tag =
   | UnexposedDecl
   | StructDecl
   | UnionDecl
   | ClassDecl
   | EnumDecl
   | FieldDecl
   | EnumConstantDecl
   | FunctionDecl
   | VarDecl
   | ParmDecl
   | ObjCInterfaceDecl
   | ObjCCategoryDecl
   | ObjCProtocolDecl
   | ObjCPropertyDecl
   | ObjCIvarDecl
   | ObjCInstanceMethodDecl
   | ObjCClassMethodDecl
   | ObjCImplementationDecl
   | ObjCCategoryImplDecl
   | TypedefDecl
   | CXXMethod
   | Namespace
   | LinkageSpec
   | Constructor
   | Destructor
   | ConversionFunction
   | TemplateTypeParameter
   | NonTypeTemplateParameter
   | TemplateTemplateParameter
   | FunctionTemplate
   | ClassTemplate
   | ClassTemplatePartialSpecialization
   | NamespaceAlias
   | UsingDirective
   | UsingDeclaration
   | TypeAliasDecl
   | ObjCSynthesizeDecl
   | ObjCDynamicDecl
   | CXXAccessSpecifier
   | FirstDecl
   | LastDecl
   | FirstRef
   | ObjCSuperClassRef
   | ObjCProtocolRef
   | ObjCClassRef
   | TypeRef
   | CXXBaseSpecifier
   | TemplateRef
   | NamespaceRef
   | MemberRef
   | LabelRef
   | OverloadedDeclRef
   | VariableRef
   | LastRef
   | FirstInvalid
   | InvalidFile
   | NoDeclFound
   | NotImplemented
   | InvalidCode
   | LastInvalid
   | FirstExpr
   | UnexposedExpr
   | DeclRefExpr
   | MemberRefExpr
   | CallExpr
   | ObjCMessageExpr
   | BlockExpr
   | IntegerLiteral
   | FloatingLiteral
   | ImaginaryLiteral
   | StringLiteral
   | CharacterLiteral
   | ParenExpr
   | UnaryOperator
   | ArraySubscriptExpr
   | BinaryOperator
   | CompoundAssignOperator
   | ConditionalOperator
   | CStyleCastExpr
   | CompoundLiteralExpr
   | InitListExpr
   | AddrLabelExpr
   | StmtExpr
   | GenericSelectionExpr
   | GNUNullExpr
   | CXXStaticCastExpr
   | CXXDynamicCastExpr
   | CXXReinterpretCastExpr
   | CXXConstCastExpr
   | CXXFunctionalCastExpr
   | CXXTypeidExpr
   | CXXBoolLiteralExpr
   | CXXNullPtrLiteralExpr
   | CXXThisExpr
   | CXXThrowExpr
   | CXXNewExpr
   | CXXDeleteExpr
   | UnaryExpr
   | ObjCStringLiteral
   | ObjCEncodeExpr
   | ObjCSelectorExpr
   | ObjCProtocolExpr
   | ObjCBridgedCastExpr
   | PackExpansionExpr
   | SizeOfPackExpr
   | LambdaExpr
   | ObjCBoolLiteralExpr
   | ObjCSelfExpr
   | LastExpr
   | FirstStmt
   | UnexposedStmt
   | LabelStmt
   | CompoundStmt
   | CaseStmt
   | DefaultStmt
   | IfStmt
   | SwitchStmt
   | WhileStmt
   | DoStmt
   | ForStmt
   | GotoStmt
   | IndirectGotoStmt
   | ContinueStmt
   | BreakStmt
   | ReturnStmt
   | GCCAsmStmt
   | AsmStmt
   | ObjCAtTryStmt
   | ObjCAtCatchStmt
   | ObjCAtFinallyStmt
   | ObjCAtThrowStmt
   | ObjCAtSynchronizedStmt
   | ObjCAutoreleasePoolStmt
   | ObjCForCollectionStmt
   | CXXCatchStmt
   | CXXTryStmt
   | CXXForRangeStmt
   | SEHTryStmt
   | SEHExceptStmt
   | SEHFinallyStmt
   | MSAsmStmt
   | NullStmt
   | DeclStmt
   | OMPParallelDirective
   | LastStmt
   | TranslationUnit
   | FirstAttr
   | UnexposedAttr
   | IBActionAttr
   | IBOutletAttr
   | IBOutletCollectionAttr
   | CXXFinalAttr
   | CXXOverrideAttr
   | AnnotateAttr
   | AsmLabelAttr
   | LastAttr
   | PreprocessingDirective
   | MacroDefinition
   | MacroExpansion
   | MacroInstantiation
   | InclusionDirective
   | FirstPreprocessing
   | LastPreprocessing
   | ModuleImportDecl
   | FirstExtraDecl
   | LastExtraDecl

type linkage =
   | InvalidLinkage
   | NoLinkage
   | InternalLinkage
   | UniqueExternalLinkage
   | ExternalLinkage

type language =
   | InvalidLanguage
   | CLanguage
   | ObjCLanguage
   | CPlusPlusLanguage

type access =
   | InvalidAccess
   | PublicAccess
   | ProtectedAccess
   | PrivateAccess

type location = {
   file  : string;
   s_row : int;
   s_col : int;
   s_off : int;
   e_row : int;
   e_col : int;
   e_off : int
}

(* type kind = int * kind_tag *)
type kind = kind_tag

exception NoArguments (* ml_libclang_exn_no_args *)

let () = Callback.register_exception "ml_libclang_exn_cursor_no_args" NoArguments

let rec int_of_kind = function
   | UnexposedDecl                      -> 1
   | StructDecl                         -> 2
   | UnionDecl                          -> 3
   | ClassDecl                          -> 4
   | EnumDecl                           -> 5
   | FieldDecl                          -> 6
   | EnumConstantDecl                   -> 7
   | FunctionDecl                       -> 8
   | VarDecl                            -> 9
   | ParmDecl                           -> 10
   | ObjCInterfaceDecl                  -> 11
   | ObjCCategoryDecl                   -> 12
   | ObjCProtocolDecl                   -> 13
   | ObjCPropertyDecl                   -> 14
   | ObjCIvarDecl                       -> 15
   | ObjCInstanceMethodDecl             -> 16
   | ObjCClassMethodDecl                -> 17
   | ObjCImplementationDecl             -> 18
   | ObjCCategoryImplDecl               -> 19
   | TypedefDecl                        -> 20
   | CXXMethod                          -> 21
   | Namespace                          -> 22
   | LinkageSpec                        -> 23
   | Constructor                        -> 24
   | Destructor                         -> 25
   | ConversionFunction                 -> 26
   | TemplateTypeParameter              -> 27
   | NonTypeTemplateParameter           -> 28
   | TemplateTemplateParameter          -> 29
   | FunctionTemplate                   -> 30
   | ClassTemplate                      -> 31
   | ClassTemplatePartialSpecialization -> 32
   | NamespaceAlias                     -> 33
   | UsingDirective                     -> 34
   | UsingDeclaration                   -> 35
   | TypeAliasDecl                      -> 36
   | ObjCSynthesizeDecl                 -> 37
   | ObjCDynamicDecl                    -> 38
   | CXXAccessSpecifier                 -> 39
   | FirstDecl                          -> int_of_kind UnexposedDecl
   | LastDecl                           -> int_of_kind CXXAccessSpecifier
   | FirstRef                           -> 40
   | ObjCSuperClassRef                  -> 40
   | ObjCProtocolRef                    -> 41
   | ObjCClassRef                       -> 42
   | TypeRef                            -> 43
   | CXXBaseSpecifier                   -> 44
   | TemplateRef                        -> 45
   | NamespaceRef                       -> 46
   | MemberRef                          -> 47
   | LabelRef                           -> 48
   | OverloadedDeclRef                  -> 49
   | VariableRef                        -> 50
   | LastRef                            -> int_of_kind VariableRef
   | FirstInvalid                       -> 70
   | InvalidFile                        -> 70
   | NoDeclFound                        -> 71
   | NotImplemented                     -> 72
   | InvalidCode                        -> 73
   | LastInvalid                        -> int_of_kind InvalidCode
   | FirstExpr                          -> 100
   | UnexposedExpr                      -> 100
   | DeclRefExpr                        -> 101
   | MemberRefExpr                      -> 102
   | CallExpr                           -> 103
   | ObjCMessageExpr                    -> 104
   | BlockExpr                          -> 105
   | IntegerLiteral                     -> 106
   | FloatingLiteral                    -> 107
   | ImaginaryLiteral                   -> 108
   | StringLiteral                      -> 109
   | CharacterLiteral                   -> 110
   | ParenExpr                          -> 111
   | UnaryOperator                      -> 112
   | ArraySubscriptExpr                 -> 113
   | BinaryOperator                     -> 114
   | CompoundAssignOperator             -> 115
   | ConditionalOperator                -> 116
   | CStyleCastExpr                     -> 117
   | CompoundLiteralExpr                -> 118
   | InitListExpr                       -> 119
   | AddrLabelExpr                      -> 120
   | StmtExpr                           -> 121
   | GenericSelectionExpr               -> 122
   | GNUNullExpr                        -> 123
   | CXXStaticCastExpr                  -> 124
   | CXXDynamicCastExpr                 -> 125
   | CXXReinterpretCastExpr             -> 126
   | CXXConstCastExpr                   -> 127
   | CXXFunctionalCastExpr              -> 128
   | CXXTypeidExpr                      -> 129
   | CXXBoolLiteralExpr                 -> 130
   | CXXNullPtrLiteralExpr              -> 131
   | CXXThisExpr                        -> 132
   | CXXThrowExpr                       -> 133
   | CXXNewExpr                         -> 134
   | CXXDeleteExpr                      -> 135
   | UnaryExpr                          -> 136
   | ObjCStringLiteral                  -> 137
   | ObjCEncodeExpr                     -> 138
   | ObjCSelectorExpr                   -> 139
   | ObjCProtocolExpr                   -> 140
   | ObjCBridgedCastExpr                -> 141
   | PackExpansionExpr                  -> 142
   | SizeOfPackExpr                     -> 143
   | LambdaExpr                         -> 144
   | ObjCBoolLiteralExpr                -> 145
   | ObjCSelfExpr                       -> 146
   | LastExpr                           -> int_of_kind ObjCSelfExpr
   | FirstStmt                          -> 200
   | UnexposedStmt                      -> 200
   | LabelStmt                          -> 201
   | CompoundStmt                       -> 202
   | CaseStmt                           -> 203
   | DefaultStmt                        -> 204
   | IfStmt                             -> 205
   | SwitchStmt                         -> 206
   | WhileStmt                          -> 207
   | DoStmt                             -> 208
   | ForStmt                            -> 209
   | GotoStmt                           -> 210
   | IndirectGotoStmt                   -> 211
   | ContinueStmt                       -> 212
   | BreakStmt                          -> 213
   | ReturnStmt                         -> 214
   | GCCAsmStmt                         -> 215
   | AsmStmt                            -> int_of_kind GCCAsmStmt
   | ObjCAtTryStmt                      -> 216
   | ObjCAtCatchStmt                    -> 217
   | ObjCAtFinallyStmt                  -> 218
   | ObjCAtThrowStmt                    -> 219
   | ObjCAtSynchronizedStmt             -> 220
   | ObjCAutoreleasePoolStmt            -> 221
   | ObjCForCollectionStmt              -> 222
   | CXXCatchStmt                       -> 223
   | CXXTryStmt                         -> 224
   | CXXForRangeStmt                    -> 225
   | SEHTryStmt                         -> 226
   | SEHExceptStmt                      -> 227
   | SEHFinallyStmt                     -> 228
   | MSAsmStmt                          -> 229
   | NullStmt                           -> 230
   | DeclStmt                           -> 231
   | OMPParallelDirective               -> 232
   | LastStmt                           -> int_of_kind OMPParallelDirective
   | TranslationUnit                    -> 300
   | FirstAttr                          -> 400
   | UnexposedAttr                      -> 400
   | IBActionAttr                       -> 401
   | IBOutletAttr                       -> 402
   | IBOutletCollectionAttr             -> 403
   | CXXFinalAttr                       -> 404
   | CXXOverrideAttr                    -> 405
   | AnnotateAttr                       -> 406
   | AsmLabelAttr                       -> 407
   | LastAttr                           -> int_of_kind AsmLabelAttr
   | PreprocessingDirective             -> 500
   | MacroDefinition                    -> 501
   | MacroExpansion                     -> 502
   | MacroInstantiation                 -> int_of_kind MacroExpansion
   | InclusionDirective                 -> 503
   | FirstPreprocessing                 -> int_of_kind PreprocessingDirective
   | LastPreprocessing                  -> int_of_kind InclusionDirective
   | ModuleImportDecl                   -> 600
   | FirstExtraDecl                     -> int_of_kind ModuleImportDecl
   | LastExtraDecl                      -> int_of_kind ModuleImportDecl

let rec kind_of_int = function
   | 1 -> UnexposedDecl
   | 2 -> StructDecl
   | 3 -> UnionDecl
   | 4 -> ClassDecl
   | 5 -> EnumDecl
   | 6 -> FieldDecl
   | 7 -> EnumConstantDecl
   | 8 -> FunctionDecl
   | 9 -> VarDecl
   | 10 -> ParmDecl
   | 11 -> ObjCInterfaceDecl
   | 12 -> ObjCCategoryDecl
   | 13 -> ObjCProtocolDecl
   | 14 -> ObjCPropertyDecl
   | 15 -> ObjCIvarDecl
   | 16 -> ObjCInstanceMethodDecl
   | 17 -> ObjCClassMethodDecl
   | 18 -> ObjCImplementationDecl
   | 19 -> ObjCCategoryImplDecl
   | 20 -> TypedefDecl
   | 21 -> CXXMethod
   | 22 -> Namespace
   | 23 -> LinkageSpec
   | 24 -> Constructor
   | 25 -> Destructor
   | 26 -> ConversionFunction
   | 27 -> TemplateTypeParameter
   | 28 -> NonTypeTemplateParameter
   | 29 -> TemplateTemplateParameter
   | 30 -> FunctionTemplate
   | 31 -> ClassTemplate
   | 32 -> ClassTemplatePartialSpecialization
   | 33 -> NamespaceAlias
   | 34 -> UsingDirective
   | 35 -> UsingDeclaration
   | 36 -> TypeAliasDecl
   | 37 -> ObjCSynthesizeDecl
   | 38 -> ObjCDynamicDecl
   | 39 -> CXXAccessSpecifier
   | 40 -> FirstRef
   | 41 -> ObjCProtocolRef
   | 42 -> ObjCClassRef
   | 43 -> TypeRef
   | 44 -> CXXBaseSpecifier
   | 45 -> TemplateRef
   | 46 -> NamespaceRef
   | 47 -> MemberRef
   | 48 -> LabelRef
   | 49 -> OverloadedDeclRef
   | 50 -> VariableRef
   | 70 -> FirstInvalid
   | 71 -> NoDeclFound
   | 72 -> NotImplemented
   | 73 -> InvalidCode
   | 100 -> FirstExpr
   | 101 -> DeclRefExpr
   | 102 -> MemberRefExpr
   | 103 -> CallExpr
   | 104 -> ObjCMessageExpr
   | 105 -> BlockExpr
   | 106 -> IntegerLiteral
   | 107 -> FloatingLiteral
   | 108 -> ImaginaryLiteral
   | 109 -> StringLiteral
   | 110 -> CharacterLiteral
   | 111 -> ParenExpr
   | 112 -> UnaryOperator
   | 113 -> ArraySubscriptExpr
   | 114 -> BinaryOperator
   | 115 -> CompoundAssignOperator
   | 116 -> ConditionalOperator
   | 117 -> CStyleCastExpr
   | 118 -> CompoundLiteralExpr
   | 119 -> InitListExpr
   | 120 -> AddrLabelExpr
   | 121 -> StmtExpr
   | 122 -> GenericSelectionExpr
   | 123 -> GNUNullExpr
   | 124 -> CXXStaticCastExpr
   | 125 -> CXXDynamicCastExpr
   | 126 -> CXXReinterpretCastExpr
   | 127 -> CXXConstCastExpr
   | 128 -> CXXFunctionalCastExpr
   | 129 -> CXXTypeidExpr
   | 130 -> CXXBoolLiteralExpr
   | 131 -> CXXNullPtrLiteralExpr
   | 132 -> CXXThisExpr
   | 133 -> CXXThrowExpr
   | 134 -> CXXNewExpr
   | 135 -> CXXDeleteExpr
   | 136 -> UnaryExpr
   | 137 -> ObjCStringLiteral
   | 138 -> ObjCEncodeExpr
   | 139 -> ObjCSelectorExpr
   | 140 -> ObjCProtocolExpr
   | 141 -> ObjCBridgedCastExpr
   | 142 -> PackExpansionExpr
   | 143 -> SizeOfPackExpr
   | 144 -> LambdaExpr
   | 145 -> ObjCBoolLiteralExpr
   | 146 -> ObjCSelfExpr
   | 200 -> FirstStmt
   | 201 -> LabelStmt
   | 202 -> CompoundStmt
   | 203 -> CaseStmt
   | 204 -> DefaultStmt
   | 205 -> IfStmt
   | 206 -> SwitchStmt
   | 207 -> WhileStmt
   | 208 -> DoStmt
   | 209 -> ForStmt
   | 210 -> GotoStmt
   | 211 -> IndirectGotoStmt
   | 212 -> ContinueStmt
   | 213 -> BreakStmt
   | 214 -> ReturnStmt
   | 215 -> GCCAsmStmt
   | 216 -> ObjCAtTryStmt
   | 217 -> ObjCAtCatchStmt
   | 218 -> ObjCAtFinallyStmt
   | 219 -> ObjCAtThrowStmt
   | 220 -> ObjCAtSynchronizedStmt
   | 221 -> ObjCAutoreleasePoolStmt
   | 222 -> ObjCForCollectionStmt
   | 223 -> CXXCatchStmt
   | 224 -> CXXTryStmt
   | 225 -> CXXForRangeStmt
   | 226 -> SEHTryStmt
   | 227 -> SEHExceptStmt
   | 228 -> SEHFinallyStmt
   | 229 -> MSAsmStmt
   | 230 -> NullStmt
   | 231 -> DeclStmt
   | 232 -> OMPParallelDirective
   | 300 -> TranslationUnit
   | 400 -> FirstAttr
   | 401 -> IBActionAttr
   | 402 -> IBOutletAttr
   | 403 -> IBOutletCollectionAttr
   | 404 -> CXXFinalAttr
   | 405 -> CXXOverrideAttr
   | 406 -> AnnotateAttr
   | 407 -> AsmLabelAttr
   | 500 -> PreprocessingDirective
   | 501 -> MacroDefinition
   | 502 -> MacroExpansion
   | 503 -> InclusionDirective
   | 600 -> ModuleImportDecl
   | _ -> assert false

let kind_eq t1 t2 = int_of_kind t1 = int_of_kind t2

external null : unit -> t = "ml_libclang_cxcursor_null"
external is_null : t -> bool = "ml_libclang_cxcursor_is_null"

external of_translation_unit : TranslationUnit.t -> t = "ml_libclang_cxcursor_of_translation_unit"
external to_translation_unit : t -> TranslationUnit.t = "ml_libclang_cxcursor_to_translation_unit"

external kind_val : t -> int = "ml_libclang_cxcursor_kind"
let kind t = kind_of_int (kind_val t)

external is_declaration' : int -> bool = "ml_libclang_cxcursor_is_declaration"
let is_declaration k = is_declaration' (int_of_kind k)

external is_reference' : int -> bool = "ml_libclang_cxcursor_is_reference"
let is_reference k = is_reference' (int_of_kind k)

external is_expression' : int -> bool = "ml_libclang_cxcursor_is_expression"
let is_expression k = is_expression' (int_of_kind k)

external is_statement' : int -> bool = "ml_libclang_cxcursor_is_statement"
let is_statement k = is_statement' (int_of_kind k)

external is_attribute' : int -> bool = "ml_libclang_cxcursor_is_attribute"
let is_attribute k = is_attribute' (int_of_kind k)

external is_invalid' : int -> bool = "ml_libclang_cxcursor_is_invalid"
let is_invalid k = is_invalid' (int_of_kind k)

external is_translation_unit' : int -> bool = "ml_libclang_cxcursor_is_translation_unit"
let is_translation_unit k = is_translation_unit' (int_of_kind k)

external is_preprocessing' : int -> bool = "ml_libclang_cxcursor_is_preprocessing"
let is_preprocessing k = is_preprocessing' (int_of_kind k)

external is_unexposed' : int -> bool = "ml_libclang_cxcursor_is_unexposed"
let is_unexposed k = is_unexposed' (int_of_kind k)

external access : t -> access = "ml_libclang_cxcursor_access"
external linkage : t -> linkage = "ml_libclang_cxcursor_linkage"
external language : t -> language = "ml_libclang_cxcursor_language"

external children' : t -> t list = "ml_libclang_cxcursor_children"
let children t = List.rev (children' t)
external semantic_parent : t -> t = "ml_libclang_cxcursor_semantic_parent"
external lexical_parent : t -> t = "ml_libclang_cxcursor_lexical_parent"
external name : t -> string = "ml_libclang_cxcursor_name"
external display_name : t -> string = "ml_libclang_cxcursor_display_name"
external argument_count : t -> int option = "ml_libclang_cxcursor_argument_count"
external arguments : t -> t list = "ml_libclang_cxcursor_arguments"
external location : t -> location = "ml_libclang_cxcursor_location"
external referenced : t -> t = "ml_libclang_cxcursor_referenced"
external definition : t -> t = "ml_libclang_cxcursor_definition"
external is_definition : t -> bool = "ml_libclang_cxcursor_is_definition"
external is_bitfield : t -> bool = "ml_libclang_cxcursor_is_bit_field"
external is_virtual_base : t -> bool = "ml_libclang_cxcursor_is_virtual_base"

(* external cxx_method_is_pure_virtual : t -> bool = "ml_libclang_cxcursor_cxx_is_pure_virtual" *)
external cxx_method_is_static : t -> bool = "ml_libclang_cxcursor_cxx_is_static"
external cxx_method_is_virtual : t -> bool = "ml_libclang_cxcursor_cxx_is_virtual"
external kind_of_template' : t -> int = "ml_libclang_cxcursor_cxx_kind_of_template"
let kind_of_template t = kind_of_int (kind_of_template' t)
