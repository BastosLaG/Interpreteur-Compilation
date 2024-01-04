open Ast.IR
open Mips

module Env = Map.Make (String)

type cinfo = {
  asm: Mips.instr list;
  env: Mips.loc Env.t;
  fpo: int;
  data_decls: Mips.decl list;
}

let new_label =
  let counter = ref 0 in
  fun () ->
    incr counter;
    "str" ^ string_of_int !counter

let rec compile_expr e env info =
  match e with
  | Int n         -> ([Li (V0, n)], info)
  | Bool b        -> ([Li (V0, if b then 0 else 1)], info)
  | String s      ->
    let label = new_label () in
    let formattedString =
      if String.length s > 2 && s.[0] = '\"' && s.[String.length s - 1] = '\"' then
        String.sub s 1 (String.length s - 2)
      else
        s in
          let new_info = { info with data_decls = info.data_decls @ 
                         [(label, Mips.Asciiz formattedString)] } in
                         ([La (A0, Lbl label)], new_info)

  | Call (f, args) ->
    let new_asm, new_info =
    List.fold_right
    (fun a (acc_asm, acc_info) ->
      let instrs, info = compile_expr a env acc_info in
        (instrs @ [Addi (SP, SP, -4); Sw (V0, Mem (SP, 0))] @ acc_asm, info))
        args ([], info) in
          (new_asm @ [Jal f; Addi (SP, SP, 4 * List.length args)], new_info)
  | Void          -> ([], info)

let rec compile_instr instr info =
  match instr with
  | Decl v        ->
      {
        info with
        fpo = info.fpo - 4;
        env = Env.add v (Mem (FP, info.fpo)) info.env;
      }
  | Assign (v, e) ->
      let compiled_expr, new_info = compile_expr e info.env info in{
        new_info with
        asm = new_info.asm @ compiled_expr @ [Sw (V0, Env.find v new_info.env)];
      }
  | Return e      ->
        let compiled_expr, new_info = compile_expr e info.env info in
        { new_info with asm = new_info.asm @ compiled_expr @ [Move (SP, FP); Lw (FP, Mem (SP, 0)); Addi (SP, SP, 4); Jr RA] }
  | Cond (cond,then_block,else_block) ->
        let else_label = new_label() in
        let end_label = new_label()  in
        let compiled_expr, updated_info = compile_expr cond info.env info in
        let new_info = {
          updated_info with asm = info.asm @ compiled_expr @ [Beqz (V0, else_label)];
        } in
          let info_then = compile_block then_block new_info in
          let info_then2 = {
            info_then with asm = info_then.asm @ [Jal end_label;Label else_label];
        } in
            let info_else = compile_block else_block info_then2 in
            let info_else2 = { info_else with asm = info_else.asm @ [Label end_label]} in info_else2
  | Loop (cond, block) ->
        let loop_label = new_label() in
        let end_label =  new_label() in
        let compiled_cond, updated_info = compile_expr cond info.env info in
        let new_info = {
          updated_info with asm = info.asm @ compiled_cond @ [Beqz(V0, end_label)];
        } in
          let info_loop = compile_block block new_info in
          let info_loop2 = {
            info_loop with asm = info_loop.asm @ [B loop_label; Label end_label];
          } in
            {info_loop2 with asm = info.asm @ [Label loop_label]}

and compile_block block info =
  match block with
  | i :: b ->
      let new_info = compile_instr i info in
      compile_block b new_info
  | [] -> info

let compile ir =
  let init_info = {
    asm = Baselib.builtins;
    env = Env.empty;
    fpo = 0;
    data_decls = [];
  } in
  let compiled = compile_block ir init_info in
  { text = Move (FP, SP) :: Addi (FP, SP, compiled.fpo) :: compiled.asm; data = List.rev compiled.data_decls }
