open! Core
open! Async

module type Hidapi = module type of Hidapi__library_must_be_initialized

module Device_info = struct
  type t = Hidapi.device_info =
    { path : string
    ; vendor_id : int
    ; product_id : int
    ; serial_number : string option
    ; release_number : int
    ; manufacturer_string : string option
    ; product_string : string option
    ; usage_page : int
    ; usage : int
    ; interface_number : int
    }
  [@@deriving sexp, fields]
end

type t = Hidapi__library_must_be_initialized.t

let hidapi =
  lazy
    (Initialize.initialize ();
     (module Hidapi__library_must_be_initialized : Hidapi))
;;

let enumerate =
  let (module Hidapi) = force hidapi in
  Hidapi.enumerate
;;

let open_id =
  let (module Hidapi) = force hidapi in
  Hidapi.open_id
;;

let open_path =
  let (module Hidapi) = force hidapi in
  Hidapi.open_path
;;

let open_id_exn =
  let (module Hidapi) = force hidapi in
  Hidapi.open_id_exn
;;

let open_path_exn =
  let (module Hidapi) = force hidapi in
  Hidapi.open_path_exn
;;

let write =
  let (module Hidapi) = force hidapi in
  Hidapi.write
;;

let read =
  let (module Hidapi) = force hidapi in
  Hidapi.read
;;

let set_nonblocking =
  let (module Hidapi) = force hidapi in
  Hidapi.set_nonblocking
;;

let set_nonblocking_exn =
  let (module Hidapi) = force hidapi in
  Hidapi.set_nonblocking_exn
;;

let send_feature_report =
  let (module Hidapi) = force hidapi in
  Hidapi.send_feature_report
;;

let get_feature_report =
  let (module Hidapi) = force hidapi in
  Hidapi.get_feature_report
;;

let close =
  let (module Hidapi) = force hidapi in
  Hidapi.close
;;
