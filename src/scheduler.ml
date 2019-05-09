(* Stephen Duke
   Hunter College
   www.stephenduke.earth
   2007 *)

open CalendarLib;;
open Date;;
open Printf;;
open Parse_csv;;

(****************************************************************************** 
		Helpers
******************************************************************************)

(* Compares list to item, returns true if item already exists in list *)
let rec exists_in x ls =
		match ls with
		| [] -> false
		| h::t -> if h = x then true else exists_in x t

let replace l pos a = List.mapi (fun i x -> if i = pos then a else x) l

(****************************************************************************** 
		Records
******************************************************************************)

type employee = {
	name : string;
	priority : int;
	days_off : string list;
	days_off_times : string list;
	set_schedule : string list;
	max_shifts : string;
	duties : string list; 
	weekly_shift_count : int
}

type schedule = {
	neighborhood : string;
	date : string;
	time : string;
	day_of_week : string
}

(****************************************************************************** 
		Record setting helpers
******************************************************************************)

let make_schedule_from_list ls = {
	neighborhood = List.nth ls 0;
	date = List.nth ls 1;
	time = (List.nth ls 2);
	day_of_week = List.nth ls 3;
}

let make_employee_from_list ls = {
	name = List.nth ls 0;
	priority = int_of_string (List.nth ls 1);
	days_off = parse_to_list ";" (List.nth ls 2);
	days_off_times = parse_to_list ";" (List.nth ls 3);
	set_schedule = parse_to_list ";" (List.nth ls 4);
	max_shifts = (List.nth ls 5);
	duties = parse_to_list ";" (List.nth ls 6);
	weekly_shift_count = 0
}


(****************************************************************************** 
		Date Handling
******************************************************************************)

let date_of_string dt = 
  let dt = parse_to_list "/" dt in
  let dt = List.map int_of_string dt in
  let dt = (make (List.nth dt 2) (List.nth dt 0) (List.nth dt 1)) in
  dt

let date_of_int_list dt = 
	let yr = List.hd dt in 
  let mo = List.nth dt 1 in 
  let dy = List.nth dt 2 in 
  let dt = make yr mo dy in 
  dt

let add_x_days_and_return_date x sched =
	let end_of_week = parse_to_list "/" sched.date in
	let end_of_week = List.map int_of_string end_of_week in
	let end_of_week = replace end_of_week 1 ((List.nth end_of_week 1) + x) in
	let end_of_week = date_of_int_list end_of_week in
	end_of_week


(****************************************************************************** 
		File output
******************************************************************************)

let print_schedule_line oc emp schedule =
	fprintf oc "%s" emp.name;
	fprintf oc "%s" ",";
	fprintf oc "%s" schedule.neighborhood;
	fprintf oc "%s" ",";
	fprintf oc "%s" schedule.date;
	fprintf oc "%s" ",";
	fprintf oc "%s" schedule.time;
	fprintf oc "%s" ",";
	fprintf oc "%s\n" schedule.day_of_week

let print_headers oc =
	fprintf oc "%s" "Employee Name";
	fprintf oc "%s" ",";
	fprintf oc "%s" "Duty";
	fprintf oc "%s" ",";
	fprintf oc "%s" "Date";
	fprintf oc "%s" ",";
	fprintf oc "%s" "Time";
	fprintf oc "%s" ",";
	fprintf oc "%s\n" "Day of Week"


(****************************************************************************** 
		Employee Handling
******************************************************************************)

let empty_employee =
	make_employee_from_list ["NONE AVAILABLE!";"0";"";"";"";"";"";""]

(* Employee Comparator *)
let compare_emp_priority emp1 emp2 =
	if emp1.priority < emp2.priority then -1 else
	if emp1.priority > emp2.priority then 1 else 0

let employee_has_reached_max_shifts employee =
	if employee.weekly_shift_count >= (int_of_string (employee.max_shifts)) then true else false

(* Checks if there is employee conflict with the given schedule *)
let no_conflict emp schedule =
	if ((exists_in schedule.neighborhood emp.duties) != true) then false else
	if (employee_has_reached_max_shifts emp) then false else 
	if (exists_in schedule.date emp.days_off) then
		(if ((exists_in schedule.time emp.days_off_times) ||
				 (List.hd emp.days_off_times = "ALL")) then false else true)
	else if (exists_in schedule.day_of_week emp.days_off) then false else true

let get_next_available_employee_at_head emps date =
	let rec get_next emp dt acc = 
		match emp with
		| [] -> (List.cons empty_employee acc)
		| hd::tl -> if no_conflict hd dt then hd::(List.append (List.rev acc) tl) else get_next tl dt (List.cons hd acc)
	in
	get_next emps date []

let set_to_zero emp = 
	let emp = {emp with weekly_shift_count = 0} in
	emp

let set_weekly_shift_count_to_zero employees = 
	List.map set_to_zero employees

let create_employee_hash emp = 
	let emp_hash = Hashtbl.create (List.length emp) in
	let rec aux emp hash =
		match emp with
		| [] -> hash
		| hd::tl -> 
			Hashtbl.add hash (hd.name) hd;
			aux tl hash
	in
	aux emp emp_hash

let employee_sort f employees =
	let employees = List.sort f employees in
	employees
(*  *)
let employees x = parse_line_to_list 1 make_employee_from_list x


(****************************************************************************** 
		Schedule Handling
******************************************************************************)

let get_next_days_schedule schedule =
	if schedule = [] then [] else
	let date = (List.hd schedule).date in
	let rec match_days sched acc =
		match sched with
		| [] -> List.rev acc
		| hd::tl -> if hd.date = date then match_days tl (List.cons hd acc) else List.rev acc
	in
	match_days schedule []

let rec get_rest_of_schedule schedule =
	if schedule = [] then [] else
	let date = (List.hd schedule).date in
	let rec match_days sched =
		match sched with
		| [] -> []
		| hd::tl -> if hd.date = date then match_days tl else sched
	in
	match_days schedule

(* Takes in an employee record and schedule record and schedules based on availablility *)
let make_daily_schedule oc employees schedule =
	let rec aux empls sched acc =
		match sched with
		| [] -> employee_sort compare_emp_priority (List.append empls acc)
		| hd::tl ->
			let x = get_next_available_employee_at_head empls hd in
			let emp = {(List.hd x) with weekly_shift_count = (List.hd x).weekly_shift_count + 1} in
			print_schedule_line oc (List.hd x) hd;
			aux (List.tl x) (List.tl sched) (List.cons emp acc)
	in 
	aux employees schedule []

let schedule x = parse_line_to_list 1 make_schedule_from_list x


(****************************************************************************** 
		Main Routine
******************************************************************************)

(* Uses the make daily schedule function to output schedule to a file *)
let make_and_save_schedule_to_file employees schedule =
	let oc = open_out "new_schedule.csv" in
	print_headers oc;
	let end_of_week = add (date_of_string (List.hd schedule).date) (Period.day 7) in
	let rec aux emps sched eow =
		match sched with
		| [] -> print_endline "Schedule ouput in current directory."
		| _ -> 
			let curr_day_sched = get_next_days_schedule sched in
			let rest_of_sched = get_rest_of_schedule sched in
			let curr_day_date = date_of_string (List.hd curr_day_sched).date in
			let emps = make_daily_schedule oc emps curr_day_sched in
			if (compare curr_day_date eow) >= 0 then 
				let eow = add curr_day_date (Period.day 7) in
				let emps = employees in
				aux emps rest_of_sched eow
			else
			aux emps rest_of_sched eow
	in 
	aux employees schedule end_of_week;
	close_out oc

