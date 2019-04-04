(*
	Types
*)

type employee = {
	name : string;
	priority : int;
	days_off : string list;
	set_schedule : string;
	max_tours : string;
	duties : string; 
}

type schedule = {
	neighborhood : string;
	date : int list;
	time : int;
	day_of_week : string
}

(*
	Type specific functions
*)

let make_schedule_from_list ls = {
	neighborhood = List.nth ls 0;
	date = (List.map int_of_string (parse_to_list "/" (List.nth ls 1)));
	time = int_of_string (List.nth ls 2);
	day_of_week = List.nth ls 3;
}

let make_employee_from_list ls = {
	name = List.nth ls 0;
	priority = int_of_string (List.nth ls 1);
	days_off = parse_to_list ";" (List.nth ls 2);
	set_schedule = List.nth ls 3;
	max_tours = List.nth ls 4;
	duties = List.nth ls 5;
}

let day_off_clear emp date =
	let rec aux ls =
		match ls with
		| [] -> true
		| h::t -> if h = date then false else aux t
	in aux emp.days_off

let less_than emp1 emp2 =
	if emp1.priority < emp2.priority then true else false