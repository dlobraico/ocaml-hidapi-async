open! Core

(** Initialize the [Hidapi] library. Must be called before making any calls into
   [Hidapi__library_must_be_initialized]. Idempotent. *)
val initialize : unit -> unit
