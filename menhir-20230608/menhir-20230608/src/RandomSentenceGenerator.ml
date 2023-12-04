(******************************************************************************)
(*                                                                            *)
(*                                    Menhir                                  *)
(*                                                                            *)
(*   Copyright Inria. All rights reserved. This file is distributed under     *)
(*   the terms of the GNU General Public License version 2, as described in   *)
(*   the file LICENSE.                                                        *)
(*                                                                            *)
(******************************************************************************)

open Grammar

(* -------------------------------------------------------------------------- *)

(* Random choice in a list. *)

let choose (xs : 'a list) : 'a =
  let n = List.length xs in
  assert (n > 0);
  let i = Random.int n in
  List.nth xs i

(* Random choice in a closed integer interval. *)

let pick (i, j) =
  assert (i <= j);
  i + Random.int (j - i + 1)

(* -------------------------------------------------------------------------- *)

(* Computations on closed integer intervals. *)

let infinity =
  max_int

let between i j =
  (i, j)

let at_least i =
  between i infinity

let at_most j =
  between 0 j

let full =
  (0, max_int)

let intersect (i1, j1) (i2, j2) =
  (max i1 i2, min j1 j2)

let intersect intervals =
  List.fold_left intersect full intervals

let nonempty (i, j) =
  i <= j

(* -------------------------------------------------------------------------- *)

(* A buffer is used to emit tokens. *)

let buffer =
  ref []

let emit tok =
  buffer := tok :: !buffer

let reset () =
  let toks = !buffer in
  buffer := [];
  List.rev toks

(* -------------------------------------------------------------------------- *)

(* [nonterminal nt goal k] emits a sentence that is generated by [nt] and
   whose length is at most [goal]. Then, it invokes the continuation [k].
   The use of an explicit continuation allows us to use tail calls and
   avoid stack overflows. *)

let rec nonterminal nt goal k : unit =
  assert (Analysis.minimal nt <= goal);
  assert (goal <= Analysis.maximal nt);

  (* We must choose between the productions that are associated with [nt].

     There does not necessarily a production that is capable of producing a
     word of length [goal] exactly; there does not even necessarily exist a
     production such that [goal] lies in the interval of lengths that this
     production can generate. (E.g., we could have a goal of 3, and two
     productions that generate words of length 2 and 4, respectively.)

     We proceed as follows. First, we attempt to choose among the productions
     such that [goal] lies in the production's length window. If unfortunately
     there is no such production, then we must adjust our goal, by increasing
     or decreasing it. Increasing it is dangerous and can cause
     nontermination. We choose to decrease it; we set it to the minimum value
     [minimal nt] and therefore produce a word of minimal length. *)

  (* Attempt to choose a production whose length window contains [goal]. *)
  let prods =
    Production.foldnt nt (fun prod prods ->
      if Production.error_free prod
      && Analysis.minimal_prod prod 0 <= goal
      && goal <= Analysis.maximal_prod prod 0
      then prod :: prods
      else prods
    ) []
  in
  if prods = [] then
    (* Unsuccessful. Set [goal] to [minimal nt] and retry. *)
    nonterminal nt (Analysis.minimal nt) k
  else
    (* Successful. Pick a production and use it. *)
    production (choose prods) 0 goal k

(* [production prod i goal k] emits a sentence that is generated by the
   production suffix [prod/i] and whose length is at most [goal]. Then,
   it invokes the continuation [k]. *)

and production prod i goal k : unit =
  assert (Analysis.minimal_prod prod i <= goal);
  assert (goal <= Analysis.maximal_prod prod i);
  let n = Production.length prod in
  assert (0 <= i && i <= n);
  if i = n then begin
    assert (goal = 0);
    k()
  end
  else if i < n then begin
    let rhs = Production.rhs prod in
    match rhs.(i) with
    | Symbol.T tok ->
        (* A terminal symbol offers no choice. *)
        emit tok;
        production prod (i + 1) (goal - 1) k
    | Symbol.N nt ->
        (* A nonterminal symbol [nt] offers a choice: we must split the budget
           between this symbol and the rest of the right-hand side. *)
        let min1, max1 =
          Analysis.(minimal nt, maximal nt)
        and min2, max2 =
          Analysis.(minimal_prod prod (i + 1), maximal_prod prod (i + 1))
        in
        (* This is where things get tricky. We have [goal <= max], that is,
           [goal <= max1 + max2], where [max1] and [max2] may be [infinity].
           We wish to split [goal] as [goal1 + goal2], where the constraints
           [min1 <= goal1 <= max1] and [min2 <= goal2 <= max2] must be
           satisfied. *)
        assert (min1 <= max1 && min2 <= max2);
        assert (min1 + min2 <= goal);
        assert (max1 = infinity || max2 = infinity || goal <= max1 + max2);
        (* The constraints bearing on [goal1] are as follows. *)
        let constraints =
          intersect [
            between 0 goal;
            between min1 max1;
            (if max2 = infinity then full else at_least (goal - max2));
            at_most (goal - min2);
          ]
        in
        (* This assertion is not entirely obvious... *)
        assert (nonempty constraints);
        let goal1 = pick constraints in
        let goal2 = goal - goal1 in
        assert (min1 <= goal1);
        assert (goal1 <= max1);
        assert (min2 <= goal2);
        assert (goal2 <= max2);
        nonterminal nt goal1 (fun () ->
        production prod (i + 1) goal2 k)
  end

(* -------------------------------------------------------------------------- *)

(* A wrapper that takes care of resetting the buffer and providing an identity
   continuation. *)

let nonterminal nt goal =
  assert (!buffer = []);
  let k () = () in
  match nonterminal nt goal k with
  | () ->
      reset()
  | exception e ->
      buffer := [];
      raise e

(* A wrapper that takes care of adjusting the initial goal if it lies outside
   the window. *)

let nonterminal nt goal =
  let min, max = Analysis.(minimal nt, maximal nt) in
  let goal =
    if min <= goal && goal <= max then
      goal
    else if goal < min then
      min
    else begin
      assert (max < goal);
      assert (max < infinity);
      max
    end
  in
  nonterminal nt goal
