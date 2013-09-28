
(** Functions for operations on Cursor types
@see <http://clang.llvm.org/doxygen/group__CINDEX__CURSOR__TRAVERSAL.html> Official C API Documentation *)

(** Abstract Cursor type *)
type t

(** Kind pointed to by cursor {b will become [kind]} *)
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
   file  : string; (** File name *)
   s_row : int; (** Range start row (line) *)
   s_col : int; (** Range start column *)
   s_off : int; (** Range start offset *)
   e_row : int; (** Range end row (line) *)
   e_col : int; (** Range end column *)
   e_off : int  (** Range end offset *)
}

type kind = kind_tag

exception NoArguments

val null : unit -> t
(** Create a null cursor *)

val is_null : t -> bool
(** [is_null cursor] checks if given cursor is null *)

val of_translation_unit : TranslationUnit.t -> t
(** [of_translation_unit translation_unit] creates a cursor from the given [translation_unit] *)

val to_translation_unit : t -> TranslationUnit.t
(** [to_translation_unit cursor] returns translation unit corresponding to the given [cursor] *)

val kind : t -> kind
(** [kind cursor] returns the kind ({!Cursor.kind_tag}) of value the cursor points to *)

val kind_eq : kind -> kind -> bool
(** [kind_eq k1 k2] tests if [k1] is equal to [k2] *)

(** {2 Predicates on kind of cursor } *)

val is_declaration : kind -> bool
val is_reference : kind -> bool
val is_expression : kind -> bool
val is_statement : kind -> bool
val is_attribute : kind -> bool
val is_invalid : kind -> bool
val is_translation_unit : kind -> bool
val is_preprocessing : kind -> bool
val is_unexposed : kind -> bool

(** {2 Operations on cursors } *)

val access : t -> access
val linkage : t -> linkage
val language : t -> language

val children : t -> t list
(** [children cursor] produces a list of direct children *)

val semantic_parent : t -> t
(** @see <http://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html> Official Documentation (clang_getCursorSemanticParent) *)

val lexical_parent : t -> t
(** @see <http://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html> Official Documentation (clang_getCursorLexicalParent) *)

val name : t -> string
(** [name cursor] produces the 'spelling' of the given [cursor] *)

val display_name : t -> string

val argument_count : t -> int option
(** [argument_count cursor] produces the number of (non-variadic) arguments to a call/declaration of a function or method, produces [None] for other cursors *)

val arguments : t -> t list
(** [arguments cursor] produces a list of cursors representing the arguments to a call/declaration of a function or method
@raise NoArguments when the cursor is not a call/declaration of a function or method *)

val location : t -> location
val referenced : t -> t
val definition : t -> t
val is_definition : t -> bool
val is_bitfield : t -> bool
val is_virtual_base : t -> bool

(* val cxx_method_is_pure_virtual : t -> bool *)
val cxx_method_is_static : t -> bool
val cxx_method_is_virtual : t -> bool

val kind_of_template : t -> kind

(** {2 Miscellaneous functions} *)

val includes_of   : TranslationUnit.t -> string -> t list
(** [includes_of translation_unit file_name] produces the includes of the given file ([file_name]) withing the given [translation_unit]
@raise NoSuchFile [file_name] when the named file doesn't exist within the given [translation_unit] *)

val references_to : t -> string -> t list
(** [references_to cursor file_name] produces the references to the given [cursor] within the file ([file_name]) which resides in the same translation unit as the given [cursor]
@raise NoSuchFile [file_name] when the named file doesn't exist within the translation unit containing the given [cursor] *)
