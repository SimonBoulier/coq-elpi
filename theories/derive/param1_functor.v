(* Functorial property of params in param1 translation.
      Inductive I A PA : A -> Type := K : forall a b, I A PA a.
    Elpi derive.param1.functor is_I.
      Definition is_I_functor A PA PB (f : forall x, PA x -> PB x) a :
         I A PA a -> I A PB a.

   license: GNU Lesser General Public License Version 2.1 or later           
   ------------------------------------------------------------------------- *)

Require Export elpi.

Elpi Db derive.param1.functor.db "
  type param1-functor-db term -> term -> term -> prop.
".

Elpi Command derive.param1.functor.
Elpi Accumulate Db derive.param1.functor.db.
Elpi Accumulate File "derive/param1_functor.elpi".
Elpi Accumulate " 
  main [str I, str O] :- !, coq.locate I T, derive.map.main T O _.
  main [str I] :- !, coq.locate I T, derive.param1.functor.main T ""_functor"" _.
  main _ :- usage.

  usage :- coq.error ""Usage: derive.param1.functor <inductive type name> [<output suffix>]"".
".  
Elpi Typecheck.
