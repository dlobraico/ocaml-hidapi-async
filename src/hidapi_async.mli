open! Core
open! Async

module Device_info : sig
  type t [@@deriving sexp]

  val path : t -> string
end

type t

val enumerate
  :  ?vendor_id:int
  -> ?product_id:int
  -> unit
  -> Device_info.t list Deferred.Or_error.t

val open_id : vendor_id:int -> product_id:int -> t Deferred.Or_error.t
val open_path : string -> t Deferred.Or_error.t
val open_id_exn : vendor_id:int -> product_id:int -> t Deferred.t
val open_path_exn : string -> t Deferred.t
val write : t -> ?len:int -> Bigstring.t -> [ `Bytes_written of int ] Deferred.Or_error.t

val read
  :  ?timeout:int
  -> t
  -> Bigstring.t
  -> int
  -> [ `Bytes_read of int ] Deferred.Or_error.t

val set_nonblocking : t -> bool -> unit Deferred.Or_error.t
val set_nonblocking_exn : t -> bool -> unit Deferred.t

val send_feature_report
  :  t
  -> ?len:int
  -> Bigstring.t
  -> [ `Bytes_written of int ] Deferred.Or_error.t

val get_feature_report
  :  t
  -> Bigstring.t
  -> int
  -> [ `Bytes_read of int ] Deferred.Or_error.t

val close : t -> unit Deferred.Or_error.t
