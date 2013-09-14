
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

(*type kind = int * kind_tag *)
type kind = kind_tag

exception NoArguments (* ml_libclang_exn_no_args *)

val null : unit -> t
val is_null : t -> bool

val of_translation_unit : TranslationUnit.t -> t
val to_translation_unit : t -> TranslationUnit.t

(* Implement equality *)

val kind : t -> kind
val kind_eq : kind -> kind -> bool

val is_declaration : kind -> bool
val is_reference : kind -> bool
val is_expression : kind -> bool
val is_statement : kind -> bool
val is_attribute : kind -> bool
val is_invalid : kind -> bool
val is_translation_unit : kind -> bool
val is_preprocessing : kind -> bool
val is_unexposed : kind -> bool

val access : t -> access
val linkage : t -> linkage
val language : t -> language

val children : t -> t list
val semantic_parent : t -> t
val lexical_parent : t -> t
val name : t -> string
val display_name : t -> string
val argument_count : t -> int option
val arguments : t -> t list
val location : t -> location
val referenced : t -> t
val definition : t -> t
val is_definition : t -> bool

(* Maybe:
   * clang_findIncludesInFile
   * clang_findReferencesInFile
 *)


