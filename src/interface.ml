open Tk ;;
open Scheduler;;
let top = openTk () ;;
Wm.title_set top "Scheduler" ;;
Wm.geometry_set top "330x280";;

let my_schedule = ref [];;
let my_employees = ref [];;
let img_width = 116;;
let img_height = 106;;

(*********************************************************************
  Create and set labels
*********************************************************************)

(* Initiates the label used to store employee information. *)
let emp_lab = Textvariable.create () ;;
Textvariable.set emp_lab "" ;;

(* Initiates the label used to store schedule information. *)
let sched_lab = Textvariable.create () ;;
Textvariable.set sched_lab "" ;;

(* Initiates the label used to store warning information. *)
let warning_lab = Textvariable.create () ;;
Textvariable.set warning_lab "" ;;

(* Updates the employee label with given string *)
let employee_label = Label.create
    ~textvariable:emp_lab top ;;

(* Updates the schedule label with given string *)
let schedule_label = Label.create
    ~textvariable:sched_lab top ;;

(* Updates the warning label with given string *)
let warning_label = Label.create
    ~textvariable:warning_lab top;;


(*********************************************************************
  Create canvas, logo and buttons for input and output. 
*********************************************************************)

(* Loads the logo into a canvas *)
let c = Canvas.create
    ~width:img_width
    ~height:img_height
    ~borderwidth:0
    ~relief:`Raised
    top ;;

ignore (Canvas.create_bitmap
    ~x:(img_width / 2) ~y:(img_height / 2) ~foreground:(`Color "#26ccc0")
    ~bitmap:(`File "calendar-logo.XBM")
    c);;
pack [c];;

(* Create a schedule based on the supplied file, if the file is accepted then updates the schedule label *)
let open_schedule_csv = Button.create
    ~text:"Load Schedule CSV"
    ~command:(fun () ->
      let sfile = (getOpenFile ~initialdir:"." ())
      in (my_schedule := schedule sfile;
        Textvariable.set sched_lab ("Schedule set with " ^ (List.hd !my_schedule).date ^ " at the head.");
          flush stdout))
    top in

(* Create a list of employees based on the supplied file, if the file is accepted then updates the employees label *)
let open_employee_csv = Button.create
    ~text:"Load Employee CSV"
    ~command:(fun () ->
      let efile = (getOpenFile ~initialdir:"." ())
    in (my_employees := employees efile;
        Textvariable.set emp_lab ("Employees set with " ^ (List.hd !my_employees).name ^ " at the head.")))
    top in

(* Runs the scheduler, if schedule and employee list are not supplied it will return a warning *)
let output_schedule_to_file = Button.create
    ~text:"Run Scheduler"
    ~command:(fun () ->
      if ((!my_employees != []) || (!my_schedule != [])) then
        let sched = (make_and_save_schedule_to_file !my_employees !my_schedule)
        in sched;
        Textvariable.set warning_lab ("new-schedule.csv created")
      else (Textvariable.set warning_lab "You must load both employees and schedule!"))
    top in

pack [coe employee_label; coe schedule_label; coe warning_label; coe open_employee_csv; coe open_schedule_csv; coe output_schedule_to_file] ;;

let _ = Printexc.print mainLoop ();;
