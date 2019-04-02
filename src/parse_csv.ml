#use "scheduler.ml"

let parse_to_list delim line =
    Str.split (Str.regexp delim) line

let get_line ic =
  try
    Some (input_line ic)
  with
  | End_of_file -> None

(* returns all lines from the file as a list of strings, arranged in the reverse order *)
let read_all filename =
  let ic = open_in filename in
  let rec read acc =
    match get_line ic with
    | Some line ->  let ls = (parse_to_list "," line) in
    								read ((make_employee_from_list ls) :: acc)
    | None ->
        close_in ic; (* close input channel *)
        acc (* return accumulator *)
  in
  read []