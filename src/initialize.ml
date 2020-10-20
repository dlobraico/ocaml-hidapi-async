open! Core

let initialized = Set_once.create ()

let initialize () =
  match Set_once.get initialized with
  | Some () -> ()
  | None ->
    Set_once.set_exn initialized [%here] ();
    Hidapi.init ()
;;
