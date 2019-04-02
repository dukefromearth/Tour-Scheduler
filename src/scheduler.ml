type employee = {
	name : string;
	days_off : string;
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

let make_schedule_from_list ls = {
	neighborhood = List.nth ls 0;
	date = (List.map int_of_string (parse_to_list "/" (List.nth ls 1)));
	time = int_of_string (List.nth ls 2);
	day_of_week = List.nth ls 3;
}

let make_employee_from_list ls = {
	name = List.nth ls 0;
	days_off = List.nth ls 1;
	set_schedule = List.nth ls 2;
	max_tours = List.nth ls 3;
	duties = List.nth ls 4;
}