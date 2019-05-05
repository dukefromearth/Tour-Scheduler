           (* François Thomasset *)
             (* François Thomasset *)
          (* INRIA - Rocquencourt *)
            (* 2007 *)
open Tk ;;
let top = openTk () ;;
Wm.title_set top "Open file demo 1" ;;
Wm.geometry_set top "270x50"
let open_schedule_csv = Button.create
    ~text:"Open Schedule CSV"
    ~command:(fun () ->
      let f = (getOpenFile ~initialdir:"." ())
      in (print_endline f;
    flush stdout))
    top ;;
pack [open_schedule_csv] ;;

let open_employee_csv = Button.create
    ~text:"Open Employee CSV"
    ~command:(fun () ->
      let f = (getOpenFile ~initialdir:"." ())
      in (print_endline f;
    flush stdout))
    top ;;
pack [open_employee_csv] ;;
let _ = Printexc.print mainLoop ();;