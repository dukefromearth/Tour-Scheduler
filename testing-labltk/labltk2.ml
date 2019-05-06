           (* François Thomasset *)
          (* INRIA - Rocquencourt *)
            (* 2007 *)
open Tk ;;
let top = openTk () ;;
Wm.title_set top "Text 1"
let a_frame = Frame.create ~relief:`Groove ~borderwidth:2 top
let scry = Scrollbar.create a_frame
let txt = Text.create ~width:20 ~height:4
    ~yscrollcommand:(Scrollbar.set scry)
    ~background:(`Color "#FFCB60")
    ~foreground:(`Color "#3F2204")
    a_frame ;;
Scrollbar.configure ~command:(Text.yview txt) scry ;;
grid ~column:0 ~row:0 [scry] ;;
grid ~column:1 ~row:0 [txt]  ;;
let bq = Button.create
    ~text:"The end"
    ~command:(fun () ->
      Printf.printf
  "%s\n"
  (Text.get ~start:(`Linechar (0,0),[]) ~stop:(`End,[]) txt);
      flush stdout;
      Printf.printf "Bye.\n" ; closeTk () ; exit 0)
    top ;;
pack [coe a_frame; coe bq]
let _ = Printexc.print mainLoop ()