type employee = {
	name : string;
	days_off : string;
	set_schedule : string;
	max_tours : string;
	duties : string; 
}

let make_employee_from_list ls = {
	name = List.nth ls 0;
	days_off = List.nth ls 1;
	set_schedule = List.nth ls 2;
	max_tours = List.nth ls 3;
	duties = List.nth ls 4;
}