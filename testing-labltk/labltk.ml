           (* François Thomasset *)
          (* INRIA - Rocquencourt *)
            (* 2007 *)
open Tk ;;
#use "scheduler.ml"
let top = openTk () ;;
let schedule = [];;
let employees = [];;
Wm.title_set top "Canvas 1" ;;
Wm.geometry_set top "500x550";;

let width = 350;;
let height = 350;;

let c = Canvas.create
    ~width:width
    ~height:height
    ~borderwidth:0
    ~relief:`Raised
    top ;;
ignore (Canvas.create_bitmap
    ~x:(width / 2) ~y:(height / 2) ~foreground:(`Color "#000000")
    ~bitmap:(`File "fnyt_logo.XBM")
    c);;
pack [c];;

let open_schedule_csv = Button.create
    ~text:"Open Schedule boop"
    ~command:(fun () ->
      let schedule = (getOpenFile ~initialdir:"." ())
      in (print_endline "schedule set";
    flush stdout))
    top ;;

let open_employee_csv = Button.create
    ~text:"Open Employee CSV"
    ~command:(fun () ->
      let employees = (getOpenFile ~initialdir:"." ())
      in (print_endline "employee set";
    flush stdout))
    top ;;

pack [open_schedule_csv; open_employee_csv] ;;

let run = Button.create
    ~text:"Open Employee CSV"
    ~command:(fun () ->
      let this_schedule = make_schedule employees schedule
    top ;;
pack [run] ;;

let _ = Printexc.print mainLoop ();;
