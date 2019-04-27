		       (* François Thomasset *)
		      (* INRIA - Rocquencourt *)
			      (* 2007 *)

open Tk
let top = openTk () ;;
Wm.title_set top "Menu 1";;
Wm.geometry_set top "240x120";;
let bar = Frame.create ~borderwidth:2 ~relief:`Raised  top ;;
pack ~fill:`Both ~expand:false [bar];;
let meb = Menubutton.create ~text:"Weather" ~width:50 bar 
let men = Menu.create meb
let _ = Menu.add_command
    ~label:"Rain"
    ~command:(fun () ->
      print_endline "Take your umbrella";
      flush stdout)
    men
let _ = Menu.add_command
    ~label:"Sun"
    ~command:(fun () ->
      print_endline "Don't forget your tanning cream";
      flush stdout)
    men;;
let _ = Menu.add_separator men
let _ = Menu.add_command ~label:"Exit"
    ~command:(fun () ->
      closeTk ();
      exit 0)
    men;;
let _ = Menubutton.configure ~menu:men meb
let b = Button.create ~text:"Hey, this is a button..." top ;;
pack [coe meb; coe b];;
let _ = Printexc.print mainLoop ()
