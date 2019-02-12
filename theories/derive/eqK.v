From elpi Require Export elpi derive.bcongr derive.eq ltac.discriminate.

Definition eq_axiom T eqb x :=
  forall (y : T), reflect (x = y) (eqb x y).

Definition eq_axiom_at T eqb (x y : T) :=
  reflect (x = y) (eqb x y).

Elpi Db derive.eqK.db "

type eqK-db term -> term -> prop.

:name ""eqK-db:fail""
eqK-db T _ :-
  coq.say ""derive.eqK: can't find the eq.axiom for constructor""
          {coq.term->string T},
  stop.

".

Elpi Command derive.eqK.
Elpi Accumulate Db derive.isK.db.
Elpi Accumulate File "ltac/discriminate.elpi".
Elpi Accumulate Db derive.bcongr.db.
Elpi Accumulate Db derive.eq.db.
Elpi Accumulate Db derive.eqK.db.
Elpi Accumulate File "derive/eqK.elpi".
Elpi Accumulate "
  main [str I, str Prefix] :- !, coq.locate I T, derive.eqK.main T Prefix _.
  main [str I] :- !, coq.locate I T, derive.eqK.main T ""eq_axiom_"" _.
  main _ :- usage.

  usage :- coq.error ""Usage: derive.eqK <inductive type name> [<prefix>]"".
".
Elpi Typecheck.


