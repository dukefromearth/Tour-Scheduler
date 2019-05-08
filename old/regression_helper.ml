(* (1e-06 *. Maths.pow x 4.0) -. (8e-05 *. Maths.pow x 3.0) +. 0.0007 *. (Maths.pow x 2.0) +. (0.0303 *. x) +. 0.2758 *)
#use "scheduler.ml"
#require "owl"
open Maths

let my_trendline x = (Maths.pow (1e-06 *. x) 4.0) -. (Maths.pow (8e-05 *. x) 3.0) +. (Maths.pow (0.0007 *. x) 2.0) +. (0.0303 *. x) +. 0.2758

let schedule_helper formula num_weeks =
	let rec aux formula num_weeks curr_week =
	match num_weeks with
	| 0 -> print_endline "finished"
	| _ -> print_int (int_of_float (1.5 +. (formula curr_week)));
		  print_endline "";
			aux formula (num_weeks - 1) (curr_week +. 1.0)
	in 
	aux formula num_weeks 1.0

let day_helper day month year num_weeks =
	let first_date = (make year month day) in
	let rec aux date num_weeks curr_week =
		match num_weeks with
		| 0 -> print_endline "finished"
		| _ ->
			let date = add date (Period.day 7)
			print_string day_of_month date
	in 
	aux formula num_weeks 1.0