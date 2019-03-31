#use "scheduler.ml"

let get_line ic =
  try
    Some (input_line ic)
  with
  | End_of_file -> None

let parse_text filename =
  (* open input channel *)
  let ic = open_in filename in

  (* read and print the file content line by line *)
  let rec read () =
    match get_line ic with
    | Some line ->
        Printf.printf "%s\n" line;
        read ()
    | None -> ()
  in
  read ();

  (* close input channel *)
  close_in ic