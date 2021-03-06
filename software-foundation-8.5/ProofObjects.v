Require Export IndProp.

Print ev.
Check ev_SS.

Theorem ev_4 : ev 4.
Proof.
  apply (ev_SS 2 (ev_SS 0 ev_0)).
Qed.

Print ev_4.

Theorem ev_8 : ev 8.
Proof.
  apply (ev_SS 6 (ev_SS 4 ev_4)).
Qed.

Definition ev_8' : ev 8 := ev_8.

Theorem ev_plus4 : forall n, ev n -> ev (4 + n).
Proof.
  intros n H. repeat constructor. assumption.
Qed.

Definition ev_plus4' : forall n, ev n -> ev (4 + n) :=
  fun (n : nat) => fun (H : ev n) =>
                ev_SS (S (S n)) (ev_SS n H).

Definition ev_plus4'' (n : nat) (H : ev n) : ev (4 + n) :=
  ev_SS (S (S n)) (ev_SS n H).

Module Props.
  Module And.

    Inductive and (P Q : Prop) : Prop :=
    | conj : P -> Q -> and P Q.

  End And.

  Print prod.

  Lemma and_comm : forall P Q : Prop, P /\ Q <-> Q /\ P.
  Proof.
    intros P Q. split.
    - intros [Hp Hq]. split.
      + apply Hq.
      + apply Hp.
    - intros [Hq Hp]. split.
      + apply Hp.
      + apply Hq.
  Qed.

  Definition and_comm'_aux P Q (H : P /\ Q) :=
    match H with
    | conj Hp Hq => conj Hq Hp
    end.

  Definition and_comm' P Q : P /\ Q <-> Q /\ P :=
    conj (and_comm'_aux P Q) (and_comm'_aux Q P).


  Definition conj_fact : forall P Q R, P /\ Q -> Q /\ R -> P /\ R :=
    fun (P Q R : Prop) =>
      fun (H1 : P /\ Q) =>
        fun (H2 : Q /\ R) =>
          match H1, H2 with
          | conj Hp Hq, conj _ Hr => conj Hp Hr
          end.

  Module Or.

    Inductive or (P Q : Prop) : Prop :=
    | or_introl : P -> or P Q
    | or_intror : Q -> or P Q.

  End Or.

  Definition or_comm : forall P Q, P \/ Q -> Q \/ P :=
    fun (P Q : Prop) =>
      fun (H : P \/ Q) =>
        match H with
        | or_introl P => or_intror P
        | or_intror Q => or_introl Q
        end.

  Module Ex.

    Inductive ex {A : Type} (P : A -> Prop) : Prop :=
    | ex_intro x : P x -> ex P.

  End Ex.

  Check ex (fun n => ev n).
  Check Ex.ex_intro.
  Check ex_intro.

  Definition some_nat_is_even : ex (fun n => ev n) :=
    ex_intro (fun n => ev n) 0 ev_0.

  Check (ex_intro ev 1).
  Definition ex_ev_Sn : ex (fun n => ev (S n)) :=
    ex_intro (fun n => ev (S n)) 1 (ev_SS 0 ev_0).

  Inductive True : Prop :=
    I : True.

  Inductive False : Prop :=.

End Props.


Definition add1 : nat -> nat.
  intros n.
  Show Proof.
  apply S.
  Show Proof.
  apply n.
  Show Proof.
Defined.

Module MyEquality.

  Inductive eq {X : Type} : X -> X -> Prop :=
  | eq_refl x : eq x x.

  Notation "x = y" := (eq x y) (at level 70, no associativity) : type_scope.

  Lemma leibniz_equality : forall (X : Type) (x y: X),
      x = y -> forall (P : X -> Prop), P x -> P y.
  Proof.
    intros X x y H P Hp. destruct H. assumption.
  Qed.

End MyEquality.

Definition quiz6 : exists x, x + 3 = 4 :=
  ex_intro (fun z => z + 3 = 4) 1 (eq_refl 4).

