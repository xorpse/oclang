
(** Miscellaneous utility functions
@see <http://clang.llvm.org/doxygen/group__CINDEX__MISC.html> Official C API Documentation *)

val version               : unit -> string
(** String representation of clang version *)

val enable_crash_recovery : bool -> unit
(** Enable clang crash recovery *)
