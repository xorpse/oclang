
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

type location = {
   file : string;
   row  : int;
   col  : int;
   off  : int
}

type inclusion = {
   name  : string;
   stack : location list
}

exception AllocFailure
exception SaveFailure of save_error
exception ReparseFailure
exception NoSuchFile of string

let () = Callback.register_exception "ml_libclang_exn_tu_alloc" AllocFailure
let () = Callback.register_exception "ml_libclang_exn_tu_save" (SaveFailure UnknownError)
let () = Callback.register_exception "ml_libclang_exn_tu_reparse" ReparseFailure
let () = Callback.register_exception "ml_libclang_exn_tu_no_such_file" (NoSuchFile "")

external create             : Index.t -> t = "ml_libclang_create_cxtranslationunit"
external create_from_source : Index.t -> string -> string list -> t = "ml_libclang_create_cxtranslationunit_from_source_file"
external save               : t -> string -> unit = "ml_libclang_save_cxtranslationunit"
external parse              : Index.t -> string -> string list -> options list -> t = "ml_libclang_parse_cxtranslationunit"
external reparse            : t -> options list -> unit = "ml_libclang_reparse_cxtranslationunit"

external inclusions'        : t -> inclusion list = "ml_libclang_cxtranslationunit_inclusions"
let inclusions t = List.rev (inclusions' t)

external is_header_guarded  : t -> string -> bool = "ml_libclang_cxtranslationunit_is_header_guarded"
