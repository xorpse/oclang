
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

let () = Callback.register_exception "ml_libclang_exn_tu_alloc" AllocFailure
let () = Callback.register_exception "ml_libclang_exn_tu_save" (SaveFailure UnknownError)
let () = Callback.register_exception "ml_libclang_exn_tu_reparse" ReparseFailure

external create             : Index.t -> t = "ml_libclang_create_cxtranslationunit"
external create_from_source : Index.t -> string -> string list -> t = "ml_libclang_create_cxtranslationunit_from_source_file"
external save               : t -> string -> unit = "ml_libclang_save_cxtranslationunit"
external parse              : Index.t -> string -> string list -> options list -> t = "ml_libclang_parse_cxtranslationunit"
external reparse            : t -> options list -> unit = "ml_libclang_reparse_cxtranslationunit"
