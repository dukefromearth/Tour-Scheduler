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
}


(****************************************************************************** 
		Functions
******************************************************************************)

(* Employee Comparator *)
let less_than emp1 emp2 =
	if emp1.priority < emp2.priority then true else false

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

(* Loops through employee list to find first available for specific date *)
let rec get_next_available_employee emps date =
	match emps with
	| [] -> make_employee_from_list ["NONE AVAILABLE!";"";"";"";"";""]
	| hd::tl -> if (no_conflict hd date) then hd else
							get_next_available_employee tl date

(*  *)
let schedule x = parse_line_to_list 1 make_schedule_from_list x

let employees x = parse_line_to_list 1 make_employee_from_list x

let rec make_schedule employees schedule =
	match schedule with
	| [] -> print_endline "Schedule Set!"
	| hd::tl -> 
		print_schedule_line (get_next_available_employee employees hd) hd;
		make_schedule (List.tl employees) tl