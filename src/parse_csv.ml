#use "scheduler.ml"

let make_schedule_from_list ls = {
	neighborhood = List.nth ls 0;
	date = List.nth ls 1;
	time = List.nth ls 2;
	day_of_week = List.nth ls 3;
}

let parse_to_list delim line =
    Str.split (Str.regexp delim) line

let get_line ic =
  try
    Some (input_line ic)
  with
  | End_of_file -> None

(* returns all lines from the file as a list of strings, arranged in the reverse order *)
let parse_line_to_list parse_type filename =
  let ic = open_in filename in
  let rec read parse_type acc =
    match get_line ic with
    | Some line ->  let ls = (parse_to_list "," line) in
    								if (parse_type = "employee") then 
    								read parse_type ((make_employee_from_list ls) :: acc) else
    								read parse_type ((make_schedule_from_list ls) :: acc) 
    | None ->
        close_in ic; (* close input channel *)
        acc (* return accumulator *)
  in
  read parse_type []