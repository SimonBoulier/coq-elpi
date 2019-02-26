From elpi Require Import elpi.
From Coq Require Import Bool.

Elpi Command demo.

(*
  A few type declarations (taken from coq-api.elpi):

    type indt  @gref -> term. % nat, list, ...
    type indc  @gref -> term. % O, S, nil, cons, ...
    type const @gref -> term. % Nat.add, List.append, ...
    
    type lam  @name -> term -> (term -> term) -> term. % fun x : t =>
    type prod @name -> term -> (term -> term) -> term. % forall x : t,
    
    type app   list term -> term.                   % app [hd|args]
    type match term -> term -> list term -> term.   % match t p [branch])
    type fix   @name -> int -> term -> (term -> term) -> term. % fix name rno ty bo

  where @name is a pretty print hint, @gref a global name.
  The former is printed as `name` while the latter as «name».
    
  Note that "x\ ..." is the lambda abstraction of
  Elpi. E.g. the identity function is "x\ x" and
  Coq's identity function is (lam `x` (indt «nat») x\ x).

*)

(* Available at: http://goo.gl/r6Nsja

  The coq.locate predicate is similar to
  the Locate command of Coq.  *)

Elpi Query "
  coq.locate ""nat"" Nat
".

(* Now lets build forall x : nat, 0 <= x *)

Elpi Query "
  coq.locate ""nat"" Nat,
  coq.locate ""le"" Le,
  coq.locate ""O"" Zero,
  T = prod `x` Nat (x \ app [Le, Zero, x])  
".

(* We can use {{ quotations }} and
    lp:antiquotations in order to write
    terms in the concrete syntax of Coq *)

Elpi Query "
  T = {{ forall x : nat, 0 <= x }}
".

Elpi Query "
  T = {{ forall x : nat, lp:Z <= x }},
  coq.locate ""O"" Z
".

(* Let's pull from Coq's environment the
    recursive definition of plus *)

Elpi Query "
  coq.locate ""plus"" (const GR),
  coq.env.const GR Bo Ty
".

(* Let's pull from Coq's environment the
    declaration of nat *)

Elpi Query "
  coq.locate ""nat"" (indt GR),
  coq.env.indt GR Ind? Pno _ Arity KN KTy
".

(* You can also use Coq's pretty-printer, eg
   for user messages *)

Elpi Query "
  coq.locate ""nat"" (indt GR),
  coq.env.indt GR _ _ _ _ _ [OTy, STy],
  coq.term->string STy PP.
".

(* --------------------------------------------- *)

(* Lets define a command generating a comparison
    function given an inductive data type declaration.

    We do it step by step.
 *)

Elpi Command eq1 "

 main [str X] :-
   coq.locate X (indt GR),
   derive-eq (indt GR) Cmp,
   Name is X ^""_cmp1"",
   coq.env.add-const Name Cmp _ _ _.

 derive-eq T R :-
   R = {{ fix f (n m : lp:T) {struct n} : bool :=
            lp:(Bo f n m) }},
   Bo = f\ n\ m\ {{true}}.
".
Elpi Typecheck.

Elpi eq1 nat. Print nat_cmp1.

(* Now let's pattern match on the first argument *)

Elpi Command eq2 "

 main [str X] :-
   coq.locate X (indt GR),
   derive-eq (indt GR) Cmp,
   Name is X ^""_cmp2"",
   coq.env.add-const Name Cmp _ _ _.

 derive-eq T R :-
   R = {{ fix f (n m : lp:T) {struct n} : bool :=
            lp:(Bo f n m) }},
   pi f n m\
     build-match n T
       derive-eq-rty
       derive-eq-bo
       (Bo f n m).

  derive-eq-rty _ _ _ {{ bool }}.

  derive-eq-bo K _ V VT {{ true }}.
 
".
Elpi Typecheck.

Elpi eq2 nat. Print nat_cmp2.

(* Now let's also match on the second one *)

Elpi Command eq3 "

 main [str X] :-
   coq.locate X (indt GR),
   derive-eq (indt GR) Cmp,
   Name is X ^""_cmp3"",
   coq.env.add-const Name Cmp _ _ _.

 derive-eq T R :-
   R = {{ fix f (n m : lp:T) {struct n} : bool :=
            lp:(Bo f n m) }},
   pi f n m\
     build-match n T
       derive-eq-rty
       (derive-eq-bo m T)
       (Bo f n m).

  derive-eq-rty _ _ _ {{ bool }}.

  derive-eq-bo M T  K I V VT  R :-
    build-match M T
      derive-eq-rty
      (derive-eq-body K I V VT)
      R.

  derive-eq-body K _ _ _ K _ _ _ {{ true }}.
  derive-eq-body _ _ _ _ _ _ _ _ {{ false }}.
 
".
Elpi Typecheck.

Elpi eq3 nat. Print nat_cmp3.


Elpi Command eq4 "

 main [str X] :-
   coq.locate X (indt GR),
   derive-eq (indt GR) Cmp,
   Name is X ^""_cmp4"",
   coq.env.add-const Name Cmp _ _ _.

 type eq-db term -> term -> prop.

 derive-eq T R :-
   R = {{ fix f (n m : lp:T) {struct n} : bool :=
            lp:(Bo f n m) }},
   pi f n m\
     eq-db T f =>
     build-match n T
       derive-eq-rty
       (derive-eq-bo m T)
       (Bo f n m).

  derive-eq-rty _ _ _ {{ bool }}.

  derive-eq-bo M T K I V VT R :-
    build-match M T
      derive-eq-rty
      (derive-eq-body K I V VT)
      R.

  derive-eq-body K _ []     _ K _ []     []     {{ true }}.
  derive-eq-body K _ [X|XS] _ K _ [Y|YS] [T|TS] {{ lp:CXY && lp:R }} :-
    eq-db T F, CXY = app [F,X,Y],
    derive-eq-body K _ XS _ K _ YS TS R.

  derive-eq-body _ _ _ _ _ _ _ _ {{ false }}.
 
".
Elpi Typecheck.

Elpi eq4 nat. Print nat_cmp4.

