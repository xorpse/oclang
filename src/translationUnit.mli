
(** Functions for operations on TranslationUnit types
@see <http://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html> Official C API Documentation *)

(** Abstract TranslationUnit type *)
type t

(** Options for parsing
@see <http://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html> enum CXTranslationUnit_Flags *)
type options = NoOptions
             | DetailedPreprocessingRecord (** Used to indicate that the parser should construct a ``detailed'' preprocessing record, including all macro definitions and instantiations. *)
             | Incomplete (** Used to indicate that the translation unit is incomplete. *)
             | PrecompiledPremable (** Used to indicate that the translation unit should be built with an implicit precompiled header for the preamble. *)
             | CacheCompletionResults (** Used to indicate that the translation unit should cache some code-completion results with each reparse of the source file. *)
             | ForSerialization (** This option is typically used when parsing a header with the intent of producing a precompiled header. *)
             | CXXChainedPCH (** Enabled chained precompiled preambles in C++. *)
             | SkipFunctionBodies (** Used to indicate that function/method bodies should be skipped while parsing. *)
             | IncludeBriefCommentsInCodeCompletion (** Used to indicate that brief documentation comments should be included into the set of code completions returned from this translation unit. *)

type save_error = UnknownError
                | TranslationErrors
                | InvalidTranslationUnit

type location = {
   file : string; (** Name of file *)
   row  : int;    (** Row (line) within the file *)
   col  : int;    (** Column within the file *)
   off  : int     (** Offset *)
}

type inclusion = {
   name  : string; (** Name of header file *)
   stack : location list (** Ordered as: ... -> Grandparent -> Parent -> ... *)
}

exception AllocFailure
exception SaveFailure of save_error
exception ReparseFailure
exception NoSuchFile of string

val create             : Index.t -> t
(** @raise AllocFailure if unable to create TranslationUnit *)

val create_from_source : Index.t -> string -> string list -> t
(** [create idx file compiler_options] create a TranslationUnit from a given source file
@raise AllocFailure if unable to create TranslationUnit (the source file could not be found, etc.) *)

val save               : t -> string -> unit
(** [save translation_unit dest_file] save given TranslationUnit to [dest_file]
@raise SaveFailure on error see {!TranslationUnit.save_error} *)

val parse              : Index.t -> string -> string list -> options list -> t
(** [parse idx file compiler_options parse_options] parse [file] with given {!TranslationUnit.options} *)

val reparse            : t -> options list -> unit
(** [reparse idx parse_options] reparse with given {!TranslationUnit.options}
@raise ReparseFailure if reparsing fails *)

val inclusions         : t -> inclusion list
(** [inclusions translation_unit] obtain a list of inclusions ({!TranslationUnit.inclusion}) from the [translation_unit] *)

val is_header_guarded  : t -> string -> bool
(** [is_header_guarded translation_unit header_file]
@raise NoSuchFile with [header_file] if the header is not located in the given [translation_unit] *)
