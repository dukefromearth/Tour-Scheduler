
(* splits a line by supplied delimiter *)
let parse_to_list delim line =
    Str.split (Str.regexp delim) line

(* returns current line of file *)
let get_line ic =
  try
    Some (input_line ic)
  with
  | End_of_file -> None

(* uses supplied function to  *)
let parse_line_to_list start_from my_fun filename =
  let ic = open_in filename in
  let rec read acc i =
    match get_line ic with
    | Some line -> if i >= start_from then
    	let ls = (parse_to_list "," (String.trim line)) in
    	read ((my_fun ls) :: acc) (succ i)
   	  else read acc (succ i)
    | None ->
        close_in ic; (* close input channel *)
        List.rev acc (* return parsed list *)
  in
  read [] 0