(* Generates inversion lemmas by encoding indexes with equations and non
   uniform parameters.

   license: GNU Lesser General Public License Version 2.1 or later           
   ------------------------------------------------------------------------- *)

From elpi Require Export elpi.

Elpi Db derive.invert.db lp:{{ type invert-db inductive -> inductive -> prop. }}.

Elpi Command derive.invert.
Elpi Accumulate Db derive.invert.db.
Elpi Accumulate File "derive/invert.elpi".
Elpi Accumulate lp:{{
  main [str I, str O] :- !, coq.locate I (indt GR), derive.invert.main GR O _.
  main [str I] :- !, coq.locate I (indt GR), derive.invert.main GR "_inv" _.
  main _ :- usage.

  usage :- coq.error "Usage: derive.invert <inductive type name> [<output name>]".
}}.
Elpi Typecheck.
