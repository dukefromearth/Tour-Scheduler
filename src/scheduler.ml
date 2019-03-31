type employee = {
	first : string;
	last : string;
	days_off : (int*int*int*int) list;
	max_tours : int;
	duties : string list; 
}

type account = {
	first : string;
	last : string;
	dob : (int*int*int);
	id : int
}

let stephen = {
	first = "Stephen"; last = "Duke";
	days_off = [(12,12,1988,10)];
	max_tours = 5;
	duties = ["Greenwich";"Nolita"]
}

let make_employee first last days_off max_tours duties = {
	first = first;
	last = last;
	days_off = days_off;
	max_tours = max_tours;
	duties = duties;
}
let bob = {
	first = "Stephen"; last = "Duke";
	dob= (12,12,1988); id = 1
}

let alice = {
	bob with
	first = "Alice"; id = 2
}

let full_name {first = f; last = l; dob = _; id = _} =
	f ^ " " ^ l

let make_account first l b id = 
	{first;
	last = l;
	dob = b;
	id = id }