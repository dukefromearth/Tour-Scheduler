(****************************************************************************** 
		Record
******************************************************************************)

type employee = {
	name : string;
	priority : int;
	days_off : string list;
	set_schedule : string;
	max_tours : string;
	duties : string list; 
}

type schedule = {
	neighborhood : string;
	date : string;
	time : int;
	day_of_week : string
}

(****************************************************************************** 
		Record setting helpers
******************************************************************************)

let make_schedule_from_list ls = {
	neighborhood = List.nth ls 0;
	date = List.nth ls 1;
	time = int_of_string (List.nth ls 2);
	day_of_week = List.nth ls 3;
}

let make_employee_from_list ls = {
	name = List.nth ls 0;
	priority = int_of_string (List.nth ls 1);
	days_off = parse_to_list ";" (List.nth ls 2);
	set_schedule = List.nth ls 3;
	max_tours = List.nth ls 4;
	duties = parse_to_list ";" (List.nth ls 5);
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
	if (exists_in schedule.date emp.days_off) then false else true


