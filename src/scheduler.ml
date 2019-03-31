type employee = {
	first : string;
	last : string;
	days_off : (int*int*int*int) list;
	max_tours : int;
	duties : string list; 
}

let make_employee first last days_off max_tours duties = {
	first = first;
	last = last;
	days_off = days_off;
	max_tours = max_tours;
	duties = duties;
}

