
type t

type options = NoOptions
             | DetailedPreprocessingRecord
             | Incomplete
             | PrecompiledPremable
             | CacheCompletionResults
             | ForSerialization
             | CXXChainedPCH
             | SkipFunctionBodies
             | IncludeBriefCommentsInCodeCompletion

type save_error = UnknownError
                | TranslationErrors
                | InvalidTranslationUnit

exception AllocFailure
exception SaveFailure of save_error
exception ReparseFailure

val create             : Index.t -> t
val create_from_source : Index.t -> string -> string list -> t
val save               : t -> string -> unit
val parse              : Index.t -> string -> string list -> options list -> t
val reparse            : t -> options list -> unit
