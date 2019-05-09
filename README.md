# Tour-Scheduler
Creates and schedules employees automatically given a schedule.

## To Compile into a UNIX Executible and run the program:
      $ ocamlopt -o Scheduler -linkpkg -package calendar,labltk parse_csv.ml scheduler.mli scheduler.ml interface.ml
      $ ./Scheduler

## Create your own file!

#### Create an employees file in the following format

##### Employee	| Priority Number	| Days Off	| Days Off Time	| Recurring Schedule	| Maximum Shifts	| Duties

<img src="https://github.com/jengajenga/Tour-Scheduler/blob/master/images/employees.png" alt="employees" width="450">


#### Create a schedule file in the following format

##### Shift	| Date	| Time	| Day of Week

<img src="https://github.com/jengajenga/Tour-Scheduler/blob/master/images/schedule.png" alt="schedule" width="350">


### View your output.
<img src="https://github.com/jengajenga/Tour-Scheduler/blob/master/images/schedule_output.png" alt="schedule_output" width="400">
