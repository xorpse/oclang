
(** Functions for operations on Index types
@see <http://clang.llvm.org/doxygen/group__CINDEX.html> Official C API Documentation *)

(** Abstract Index type *)
type t

val create : bool -> bool -> t
(** [create exclude_decls_from_pch display_diagnostics] provides a shared
context for creating translation units
@see <http://clang.llvm.org/doxygen/group__CINDEX.html> clang_CreateIndex *) 
