#use "dates.ml"
#require "calendar"
#use "parse_csv.ml"
open CalendarLib;;
open Date;;


(****************************************************************************** 
		Records
******************************************************************************)

type employee = {
	name : string;
	priority : int;
	days_off : string list;
	days_off_times : string list;
	set_schedule : string list;
	max_tours : string;
	duties : string list; 
	weekly_tour_count : int
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
	max_tours = (List.nth ls 5);
	duties = parse_to_list ";" (List.nth ls 6);
	weekly_tour_count = 0
}

(****************************************************************************** 
		Functions
******************************************************************************)

(* stack overflow code *)
let replace l pos a  = List.mapi (fun i x -> if i = pos then a else x) l

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

let empty_employee =
	make_employee_from_list ["NONE AVAILABLE!";"0";"";"";"";"";"";""]

(* Employee Comparator *)
let compare_emp_priority emp1 emp2 =
	if emp1.priority < emp2.priority then -1 else
	if emp1.priority > emp2.priority then 1 else 0

(* Compares list to item, returns true if item already exists in list *)
let rec exists_in x ls =
		match ls with
		| [] -> false
		| h::t -> if h = x then true else exists_in x t

let employee_has_reached_max_tours employee =
	if employee.weekly_tour_count >= (int_of_string (employee.max_tours)) then true else false

let reset_employee_tour_count employees = 
	let employees = List.map (fun x -> 0) employees in 
	employees

(* Checks if there is employee conflict with the given schedule *)
let no_conflict emp schedule =
	if ((exists_in schedule.neighborhood emp.duties) != true) then false else
	if (employee_has_reached_max_tours emp) then false else 
	if (exists_in schedule.date emp.days_off) then
		(if ((exists_in schedule.time emp.days_off_times) ||
				 (List.hd emp.days_off_times = "ALL")) then false else true)
	else if (exists_in schedule.day_of_week emp.days_off) then false else true

let print_schedule_line emp schedule =
	print_endline emp.name;
	print_string schedule.date;
	print_string " - ";
	print_endline schedule.time

let get_next_available_employee_at_head emps date =
	let rec get_next emp dt acc = 
		match emp with
		| [] -> (List.cons empty_employee acc)
		| hd::tl -> if no_conflict hd dt then hd::(List.append (List.rev acc) tl) else get_next tl dt (List.cons hd acc)
	in
	get_next emps date []

let set_to_zero emp = 
	let emp = {emp with weekly_tour_count = 0} in
	emp

let set_weekly_tour_count_to_zero employees = 
	List.map set_to_zero employees

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
let schedule x = parse_line_to_list 1 make_schedule_from_list x

let employees x = parse_line_to_list 1 make_employee_from_list x

let make_daily_schedule employees schedule =
	let rec aux empls sched acc =
		match sched with
		| [] -> employee_sort compare_emp_priority (List.append empls acc)
		| hd::tl ->
			let x = get_next_available_employee_at_head empls hd in
			let emp = {(List.hd x) with weekly_tour_count = (List.hd x).weekly_tour_count + 1} in
			print_schedule_line (List.hd x) hd;
			aux (List.tl x) (List.tl sched) (List.cons emp acc)
	in 
	aux employees schedule []

let make_schedule employees schedule =
	let end_of_week = add_x_days_and_return_date 7 (List.hd schedule) in
	let rec aux emps sched =
		match sched with
		| [] -> print_endline "All set"
		| _ -> 
			let curr_day_sched = get_next_days_schedule sched in
			let rest_of_sched = get_rest_of_schedule sched in
			let curr_day_date = date_of_string (List.hd curr_day_sched).date in
			let emps = make_daily_schedule emps curr_day_sched in
			if (compare curr_day_date end_of_week) > 0 then print_endline "less"
			else print_endline "greater";
			aux emps rest_of_sched
	in 
	aux employees schedule






(* Takes in a single day of events and allocates an employee to them 

					let end_of_week = add end_of_week (Period.day 7);
				let emps = reset_employee_tour_count employees;

	let emp = {emp with weekly_tour_count = emp.weekly_tour_count + 1}
	print_schedule_line emp hd; 

*)

