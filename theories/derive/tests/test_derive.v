From elpi Require Import derive.

From elpi Require Import test_derive_stdlib.

Elpi derive Coverage.empty.
Elpi derive Coverage.unit.
Elpi derive Coverage.peano.
Elpi derive Coverage.option.
Elpi derive Coverage.pair.
Elpi derive Coverage.seq.
Elpi derive Coverage.rose.
Elpi derive Coverage.nest.
Elpi derive Coverage.w.
Elpi derive Coverage.vect.
Elpi derive Coverage.dyn.
Elpi derive Coverage.zeta.
Elpi derive Coverage.beta.
Elpi derive Coverage.iota.
(* Elpi derive Coverage.large. search slow *)

Elpi derive nat.

Check nat_eq : nat -> nat -> bool.
Check nat_is_O : nat -> bool.
Check nat_is_S : nat -> bool.
Check nat_map : nat -> nat.
Check nat_get_S1 : nat -> nat -> nat.
Check is_nat : nat -> Type.
Check is_O : is_nat O.
Check is_S : forall x, is_nat x -> is_nat (S x).
Check is_nat_full : forall x, is_nat x.
(*
Check nat.param1.inv.nat : nat -> Type.
Check nat.param1.inv.O : forall i, 0 = i -> nat.param1.inv.nat i.
Check nat.param1.inv.S : forall i, forall y x, y = x -> nat.param1.inv.nat x -> S y = i -> nat.param1.inv.nat i.
*)
Check is_nat_functor : forall x, is_nat x -> is_nat x.
Check nat_induction : forall P, P 0 -> (forall n, P n -> P (S n)) -> forall x, is_nat x -> P x.
(*
Check nat.induction : forall P, P 0 -> (forall n, P n -> P (S n)) -> forall x, P x.
*)

Elpi derive list.

Check list_eq  : forall A, (A -> A -> bool) -> list A -> list A -> bool.
Check list_is_nil  : forall A, list A -> bool.
Check list_is_cons : forall A, list A -> bool.
Check list_map : forall A B, (A -> B) -> list A -> list B.
Check list_get_cons1 : forall A, A -> list A -> list A -> A.
Check list_get_cons2 : forall A, A -> list A -> list A -> list A.
Check is_nil : forall A P, is_list A P (@nil A).
Check is_cons : forall A P x (Px : P x) tl (Ptl : is_list A P tl), is_list A P (cons x tl).
Check is_list_functor : forall A P Q, (forall x, P x -> Q x) -> forall l, is_list A P l -> is_list A Q l.
Check list_induction : forall A PA P, P nil -> (forall x, PA x -> forall xs, P xs -> P (cons x xs)) -> forall l, is_list A PA l -> P l.
(*
Check list.induction : forall A P, P nil -> (forall x xs, P xs -> P (cons x xs)) -> forall l, P l.
*)

Require Vector.
 
Elpi derive Vector.t Vector_.
Check Vector_t_eq : forall A, (A -> A -> bool) -> forall n, Vector.t A n -> Vector.t A n -> bool.
Check Vector_t_is_nil : forall A n, Vector.t A n -> bool.
Check Vector_t_is_cons : forall A n, Vector.t A n -> bool. 
Check Vector_t_map : forall A B, (A -> B) -> forall n, Vector.t A n -> Vector.t B n.
Check Vector_t_get_cons1 : forall A n, A -> forall m, Vector.t A m -> Vector.t A n -> A.
Check Vector_t_get_cons2 : forall A n, A -> forall m, Vector.t A m -> Vector.t A n -> nat.
Check Vector_t_get_cons3 : forall A n, A -> forall m, Vector.t A m -> Vector.t A n -> { k : nat & Vector.t A k}.
Check Vector_is_t : forall A, (A -> Type) -> forall n, is_nat n -> Vector.t A n -> Type.
Check Vector_is_nil : forall A (PA : A -> Type), Vector_is_t A PA 0 is_O (Vector.nil A).
Check Vector_is_cons : forall A (PA : A -> Type) (a : A), PA a -> forall n (Pn : is_nat n) (H : Vector.t A n),
       Vector_is_t A PA n Pn H -> Vector_is_t A PA (S n) (is_S n Pn) (Vector.cons A a n H).
Check Vector_is_t_functor : forall A PA QA (H : forall x, PA x -> QA x), forall n nR v, Vector_is_t A PA n nR v -> Vector_is_t A QA n nR v.
Check Vector_t_induction : forall A PA (P : forall n, is_nat n -> Vector.t A n -> Type), P 0 is_O (Vector.nil A) -> (forall a, PA a -> forall m mR, forall (v : Vector.t A m), P m mR v -> P (S m) (is_S m mR) (Vector.cons A a m v)) -> forall n nR v, Vector_is_t A PA n nR v -> P n nR v.

Inductive W A := B (f : A -> W A).
 
Elpi derive W.
Fail Check W_induction : forall A (P : W A -> Type),
       (forall f, (forall x, UnitPred A x -> P (f x)) -> P (B A f)) ->
       forall x, P x.

Inductive horror A (a : A) : forall T, T -> Type := K W w (k : horror A a W w) : horror A a W w.

Elpi derive horror.
Fail Check horror_induction :
   forall A a (P : forall T t, horror A a T t -> Type), 
    (forall W (_: UnitPred Type W) w (_: UnitPred _ w) (k : horror A a W w), P W w k -> P W w (K A a W w k)) -> forall T t (x : horror A a T t), P T t x.


Inductive rtree A : Type :=
  Leaf (n : A) | Node (l : list (rtree A)).

Elpi derive rtree XXX.

Fail Check XXX_is_rtree_map.
