




type employee = {
  name : string;
  priority : int;
  days_off : string list;
  days_off_times : string list;
  set_schedule : string list;
  max_shifts : string;
  duties : string list; 
  weekly_shift_count : int
}

type schedule = {
  neighborhood : string;
  date : string;
  time : string;
  day_of_week : string
}

val exists_in : 'a -> 'a list -> bool
(* Compares list to item, returns true if item already exists in list *)

val replace : 'a list -> int -> 'a -> 'a list
(* Replaces an item at specified index in a list *)

val make_schedule_from_list : string list -> schedule
(* Parses a string list and outputs a schedule type *)

val make_employee_from_list : string list -> employee
(* Parses a string list and outputs an employee type *)

val date_of_string : string -> CalendarLib.Date.t
(* Takes in an input in format mm/dd/yyyy and turns it into a date *)

val date_of_int_list : CalendarLib.Date.year list -> CalendarLib.Date.t
(* Takes in an input in format [mm; dd; yyyy] and turns it into a date *)

val add_x_days_and_return_date : int -> schedule -> CalendarLib.Date.t
(* Adds a specified number of days to the supplied date *)

val print_schedule_line : out_channel -> employee -> schedule -> unit
(* Prints employee and schedule to specified output channel *)

val print_headers : out_channel -> unit 
(* Prints "Name,Duty,Date,Time,Day of week" to specified output channel *)

val empty_employee : employee
(* Creates an empty employee with name "NONE_AVAILBLE" *)

val compare_emp_priority : employee -> employee -> int
(* Returns -1 if lhs < rhs, 1 if lhs > rhs, 0 if lhs = rhs *)

val employee_has_reached_max_shifts : employee -> bool
(* Returns true if the shift count = max shift count *)

val no_conflict : employee -> schedule -> bool
(* Checks if there are schedule conflicts with all employees and returns true of there are no conflicts *)

val get_next_available_employee_at_head :
  employee list -> schedule -> employee list
(* Uses no_conflict to find the first employee in the list that has no conflict with the current schedule  *)

val set_weekly_shift_count_to_zero : employee list -> employee list
(* Reverts the employees shift count to zero *)

val create_employee_hash : employee list -> (string, employee) Hashtbl.t
(* Creates a hashtable sorted by employee name *)

val employee_sort : ('a -> 'a -> int) -> 'a list -> 'a list
(* Sorts employees based on their priority *)

val employees : string -> employee list
(* Parses a string in the format "Stephen,2,1/21/19,ALL,Saturday-1100;Tuesday-1200,2,Greenwich;Nolita" *)

val get_next_days_schedule : schedule list -> schedule list
(* Loops to gather all shifts in the next available day. *)

val get_rest_of_schedule : schedule list -> schedule list
(* Loops until after the next days shifts and collects the rest of the schedule *)

val make_daily_schedule :
  out_channel -> employee list -> schedule list -> employee list
(* Prints the employee and their schedule to a specified output channel, returns 
   employee list with updated shift count *)

val schedule : string -> schedule list
(* Parses a string in the format "Duty,mm/dd/yyy,1100,Monday" *)

val make_and_save_schedule_to_file : employee list -> schedule list -> unit
(* Creates and saves schedule to specified ouput channel *)