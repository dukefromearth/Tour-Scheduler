#use "parse_csv.ml"

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
	max_tours = List.nth ls 5;
	duties = parse_to_list ";" (List.nth ls 6);
	weekly_tour_count = 0
}

(****************************************************************************** 
		Functions
******************************************************************************)

let empty_employee =
	make_employee_from_list ["NONE AVAILABLE!";"0";"";"";"";"";"";""]

(* Employee Comparator *)
let less_than emp1 emp2 =
	if emp1.priority < emp2.priority then true else false

let less_than_date lhs rhs =
	let dt1 = (List.map int_of_string (parse_to_list "/" lhs)) in
	let dt2 = (List.map int_of_string (parse_to_list "/" rhs)) in
	if (List.nth dt1 2) < (List.nth dt2 2) then true 
	else if (List.nth dt1 2) > (List.nth dt2 2) then false
	else if (List.nth dt1 0) < (List.nth dt2 0) then true 
	else if (List.nth dt1 0) > (List.nth dt2 0) then false
	else if (List.nth dt1 1) < (List.nth dt2 1) then true 
	else false



(* Compares list to item, returns true if item already exists in list *)
let rec exists_in x ls =
		match ls with
		| [] -> false
		| h::t -> if h = x then true else exists_in x t

(* Checks if there is employee conflict with the given schedule *)
let no_conflict emp schedule =
	if ((exists_in schedule.neighborhood emp.duties) != true) then false else
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
		| hd::tl -> if no_conflict hd dt then hd::(List.append tl (List.rev acc)) else get_next tl dt (List.cons hd acc)
	in
	get_next emps date []

let get_next_days_schedule schedule =
	if schedule = [] then [] else
	let day = (List.hd schedule).day_of_week in
	let rec match_days sched acc =
		match schedule with
		| [] -> List.rev acc
		| hd::tl -> if hd.day_of_week = day then match_days tl (List.cons hd acc) else List.rev acc
	in
	match_days schedule []

let rec get_rest_of_schedule schedule =
	let day = (List.hd schedule).day_of_week in
	match schedule with
	| [] -> schedule
	| hd::tl -> if hd.day_of_week = day then get_rest_of_schedule tl else tl


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

(*  *)
let schedule x = parse_line_to_list 1 make_schedule_from_list x

let employees x = parse_line_to_list 1 make_employee_from_list x

let rec make_schedule employees schedule =
	let first_day = (List.hd schedule).date in
	let rec aux emps schedule =
		if schedule = [] then () else
			let employees = get_next_days_schedule schedule in
			let schedule = get_rest_of_schedule in
			if (List.hd schedule).day_of_week = first_day then
		aux employees schedule
	in
	aux employees schedule



let make_daily_schedule employees schedule =
	let rec mk_dly_sched emps sched acc =
		match sched with
		| [] -> (List.rev acc)
		| hd::tl -> 
			let emps = get_next_available_employee_at_head employees hd in
			let emp = List.hd emps in
			let emp = {emp with weekly_tour_count = emp.weekly_tour_count + 1} in
			print_schedule_line (List.hd emps) hd;
			mk_dly_sched (List.tl emps) tl (List.cons emp acc)
	in
	mk_dly_sched employees schedule []


