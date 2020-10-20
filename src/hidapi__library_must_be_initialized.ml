open Core
open Async

module Device_info = struct
  type t = Hidapi.device_info
end

type t = Hidapi.t

let enumerate ?vendor_id ?product_id () =
  In_thread.run (fun () -> Hidapi.enumerate ?vendor_id ?product_id () |> Or_error.return)
;;

let open_id ~vendor_id ~product_id =
  match%map In_thread.run (fun () -> Hidapi.open_id ~vendor_id ~product_id) with
  | Some t -> Ok t
  | None ->
    Or_error.error_s
      [%message
        "[Hidapi.open_id] didn't find anything" (vendor_id : int) (product_id : int)]
;;

let open_path path =
  match%map In_thread.run (fun () -> Hidapi.open_path path) with
  | Some t -> Ok t
  | None ->
    Or_error.error_s [%message "[Hidapi.open_path] didn't find anything" (path : string)]
;;

let open_id_exn ~vendor_id ~product_id =
  open_id ~vendor_id ~product_id |> Deferred.Or_error.ok_exn
;;

let open_path_exn path = open_path path |> Deferred.Or_error.ok_exn

let write t ?len buf =
  match%map In_thread.run (fun () -> Hidapi.write t ?len buf) with
  | Ok int -> Ok (`Bytes_written int)
  | Error s -> Or_error.tag ~tag:"[Hidapi.write]" (Or_error.error_string s)
;;

let read ?timeout t buf max_num_bytes =
  match%map In_thread.run (fun () -> Hidapi.read ?timeout t buf max_num_bytes) with
  | Ok int -> Ok (`Bytes_read int)
  | Error s -> Or_error.tag ~tag:"[Hidapi.read]" (Or_error.error_string s)
;;

let set_nonblocking t nonblocking =
  let%map result = In_thread.run (fun () -> Hidapi.set_nonblocking t nonblocking) in
  Result.map_error result ~f:Error.of_string
;;

let set_nonblocking_exn t nonblocking =
  set_nonblocking t nonblocking |> Deferred.Or_error.ok_exn
;;

let send_feature_report t ?len buf =
  match%map In_thread.run (fun () -> Hidapi.send_feature_report t ?len buf) with
  | Ok int -> Ok (`Bytes_written int)
  | Error s -> Or_error.tag ~tag:"[Hidapi.send_feature_report]" (Or_error.error_string s)
;;

let get_feature_report t buf max_num_bytes =
  match%map In_thread.run (fun () -> Hidapi.get_feature_report t buf max_num_bytes) with
  | Ok int -> Ok (`Bytes_read int)
  | Error s -> Or_error.tag ~tag:"[Hidapi.get_feature_report]" (Or_error.error_string s)
;;

let close t =
  Deferred.Or_error.try_with (fun () -> In_thread.run (fun () -> Hidapi.close t))
;;
