(* -------------------------------------------------------------------- *)
#light "off"

module Microsoft.FStar.Backends.OCaml

open System
open System.Text

open Microsoft.FStar
open Microsoft.FStar.Util
open Microsoft.FStar.Absyn.Syntax
open Microsoft.FStar.Absyn.Util
open Microsoft.FStar.Backends.NameEnv

open FSharp.Format

(* -------------------------------------------------------------------- *)
type mltyname = list<string> * string

type mlty =
    | Ty_var   of string
    | Ty_fun   of string option * mlty * mlty
    | Ty_named of mltyname * mlty list

type mltycons =
    (string option * mlty) list * mlty

(* To be changed for polymorphic types *)
type mldtype = string * mlty list

type mlenv = {
    mle_types : Map<mltyname, mldtype>;
    mle_vals  : unit;
}

(* -------------------------------------------------------------------- *)
let unexpected () =
    failwith "ocaml-backend-unexpected-construction"

(* -------------------------------------------------------------------- *)
let unsupported () =
    failwith "ocaml-backend-unsupported-construction"

(* -------------------------------------------------------------------- *)
let ocaml_u8_codepoint (i : byte) =
  if (int)i = 0 then "" else sprintf "\\x%x" i

(* -------------------------------------------------------------------- *)
let encode_char c =
  if (int)c > 127 then // Use UTF-8 encoding
    let bytes = System.String (c, 1) in
    let bytes = (new UTF8Encoding (false, true)).GetBytes(bytes) in
    bytes
      |> Array.map ocaml_u8_codepoint
      |> String.concat ""
  else
    match c with
    | c when Char.IsLetterOrDigit(c) -> System.String (c, 1)
    | c when Char.IsPunctuation(c)   -> System.String (c, 1)
    | c when c = ' '                 -> " "
    | c when c = '\t'                -> "\\t"
    | c when c = '\r'                -> "\\r"
    | c when c = '\n'                -> "\\n"
    | _                              -> ocaml_u8_codepoint ((byte)c)

(* -------------------------------------------------------------------- *)
let string_of_sconst sctt =
  match sctt with
  | Const_unit         -> "()"
  | Const_char   c     -> sprintf "'%s'" (encode_char c)
  | Const_uint8  c     -> sprintf "'%s'" (ocaml_u8_codepoint c)
  | Const_int32  i     -> sprintf "%d" i // FIXME
  | Const_int64  i     -> sprintf "%d" i // FIXME
  | Const_bool   true  -> "true"
  | Const_bool   false -> "false"
  | Const_float  d     -> sprintf "%f" d

  | Const_bytearray (bytes, _) ->
      let bytes = bytes |> Array.map ocaml_u8_codepoint in
      sprintf "\"%s\"" (bytes |> String.concat "")

  | Const_string (bytes, _) ->
      let chars = (new UTF8Encoding (false, true)).GetString(bytes) in
      let chars = chars |> String.collect encode_char in
      sprintf "\"%s\"" chars

(* -------------------------------------------------------------------- *)
let is_prim_ns (ns : list<ident>) =
    match ns with
    | [{ idText = "Prims" }] -> true
    | _ -> false

(* -------------------------------------------------------------------- *)
let name_of_let_ident (x : either<bvvdef,lident>) =
    match x with
    | Inl x -> x.realname.idText
    | Inr x -> x.ident.idText

(* -------------------------------------------------------------------- *)
let string_of_primop (_env : env) (x : string) =
    x

(* -------------------------------------------------------------------- *)
type assoc  = ILeft | IRight | Left | Right | NonAssoc
type fixity = Prefix | Postfix | Infix of assoc
type opprec = int * fixity

let t_prio_fun  = (10, Infix Right)
let t_prio_tpl  = (20, Infix NonAssoc)
let t_prio_name = (30, Postfix)

let e_bin_prio_lambda = ( 5, Prefix)
let e_bin_prio_if     = (15, Prefix)
let e_bin_prio_letin  = (19, Prefix)
let e_bin_prio_or     = (20, Infix Left)
let e_bin_prio_and    = (25, Infix Left)
let e_bin_prio_eq     = (27, Infix NonAssoc)
let e_bin_prio_order  = (29, Infix NonAssoc)
let e_bin_prio_op1    = (30, Infix Left)
let e_bin_prio_op2    = (40, Infix Left)
let e_bin_prio_op3    = (50, Infix Left)
let e_bin_prio_op4    = (60, Infix Left)
let e_bin_prio_seq    = (100, Infix Left)
let e_app_prio        = (10000, Infix Left)

let min_op_prec = (-1, Infix NonAssoc)
let max_op_prec = (System.Int32.MaxValue, Infix NonAssoc)

(* -------------------------------------------------------------------- *)
let infix_prim_ops = [
    ("op_Addition"       , e_bin_prio_op1   , "+" );
    ("op_Subtraction"    , e_bin_prio_op1   , "-" );
    ("op_Equality"       , e_bin_prio_eq    , "=" );
    ("op_AmpAmp"         , e_bin_prio_and   , "&&");
    ("op_BarBar"         , e_bin_prio_or    , "||");
    ("op_LessThanOrEqual", e_bin_prio_order , "<=");
]

(* -------------------------------------------------------------------- *)
let maybe_paren (outer, side) inner doc =
  let noparens ((pi, fi) as _inner) ((po, fo) as _outer) side =
    (pi > po) ||
      match fi, side with
      | Postfix    , Left     -> true
      | Prefix     , Right    -> true
      | Infix Left , Left     -> (pi = po) && (fo = Infix Left )
      | Infix Right, Right    -> (pi = po) && (fo = Infix Right)
      | Infix Left , ILeft    -> (pi = po) && (fo = Infix Left )
      | Infix Right, IRight   -> (pi = po) && (fo = Infix Right)
      | _          , NonAssoc -> (pi = po) && (fi = fo)
      | _          , _        -> false
  in

  if noparens inner outer side then doc else parens doc

(* -------------------------------------------------------------------- *)
let mltyname_of_lident (ns, x) =
    (List.map (fun x -> x.idText) ns, x.idText)

(* -------------------------------------------------------------------- *)
let rec mlty_of_ty (ty : typ) =
    let ty = Absyn.Util.compress_typ ty in

    match maybe_mltynamed_of_ty [] ty with
    | None -> begin
        match ty.t with
        | Typ_btvar x ->
            Ty_var x.v.realname.idText

        | Typ_refine (_, ty, _) ->
            mlty_of_ty ty

        | Typ_ascribed (ty, _) ->
            mlty_of_ty ty

        | Typ_meta (Meta_pos (ty, _)) ->
            mlty_of_ty ty

        | Typ_fun (x, t1, t2, _) ->
            let mlt1 = mlty_of_ty t1 in
            let mlt2 = mlty_of_ty t2 in
            Ty_fun (Option.map (fun x -> x.ppname.idText) x, mlt1, mlt2)

        | Typ_const   _ -> unexpected  ()
        | Typ_app     _ -> unsupported ()
        | Typ_dep     _ -> unsupported ()
        | Typ_lam     _ -> unsupported ()
        | Typ_tlam    _ -> unsupported ()
        | Typ_univ    _ -> unsupported ()
        | Typ_meta    _ -> unexpected  ()
        | Typ_uvar    _ -> unexpected  ()
        | Typ_unknown   -> unexpected  ()
    end

    | Some (c, tys) -> Ty_named (c, tys)

and maybe_mltynamed_of_ty acc ty =
    match (Absyn.Util.compress_typ ty).t with
    | Typ_const c ->
        Some (mltyname_of_lident (c.v.ns, c.v.ident), List.rev acc)

    | Typ_app (t1, t2, _) ->
        maybe_mltynamed_of_ty (mlty_of_ty t2 :: acc) t1

    | Typ_refine (_, ty, _) ->
        maybe_mltynamed_of_ty acc ty

    | Typ_ascribed (ty, _) ->
        maybe_mltynamed_of_ty acc ty

    | Typ_btvar   _ -> None
    | Typ_fun     _ -> None
    | Typ_dep     _ -> unsupported ()
    | Typ_lam     _ -> unsupported ()
    | Typ_tlam    _ -> unsupported ()
    | Typ_univ    _ -> unsupported ()
    | Typ_meta    _ -> unexpected  ()
    | Typ_uvar    _ -> unexpected  ()
    | Typ_unknown   -> unexpected  ()

(* -------------------------------------------------------------------- *)
let mltycons_of_mlty (ty : mlty) =
    let rec aux acc ty =
        match ty with
        | Ty_fun (x, dom, codom) ->
            aux ((x, dom) :: acc) codom
        | _ ->
            (List.rev acc, ty)
    in aux [] ty

(* -------------------------------------------------------------------- *)
let rec doc_of_mltype_r outer mlty =
    match mlty with
    | Ty_var x ->
        %x

    | Ty_named ((_, name), args) -> begin
        let doc =
            match args with
            | [] ->
                %name

            | [arg] ->
                (doc_of_mltype (t_prio_name, Left) arg) +. %name

            | _ ->
                let docs = List.map (doc_of_mltype (min_op_prec, NonAssoc)) args in
                parens (join ", " docs) +. %name

        in maybe_paren outer t_prio_name doc
    end

    | Ty_fun (_, t1, t2) ->
        let d1 = doc_of_mltype (t_prio_fun, Left ) t1 in
        let d2 = doc_of_mltype (t_prio_fun, Right) t2 in

        maybe_paren outer t_prio_fun (d1 +. %"->" +. d2)

(* -------------------------------------------------------------------- *)
and doc_of_mltype outer ty =
    group (doc_of_mltype_r outer ty)

(* -------------------------------------------------------------------- *)
let doc_of_mltypes_bundle bundle =
    let for1 (name, _) = %name in
    let docs = List.map for1 bundle in
    %"type" +. (join "and" docs)

(* -------------------------------------------------------------------- *)
let rec doc_of_exp outer (env : env) (e : exp) =
    let doc =
        match maybe_doc_of_primexp_r outer env e with
        | None   -> doc_of_exp_r outer env e
        | Some d -> d

    in group doc

(* -------------------------------------------------------------------- *)
and doc_of_exp_r outer (env : env) (e : exp) =
    match Absyn.Util.destruct_app e with
    | (e, args) when not (List.isEmpty args) ->
        let e    = e    |> doc_of_exp (e_app_prio, ILeft) env in
        let args = args |> List.map (fst >> doc_of_exp (e_app_prio, IRight) env) in
        maybe_paren outer e_app_prio (e +. (joins args))

    | _ -> begin
        match e with
        | Exp_bvar x ->
            %(resolve env x.v.realname.idText)

        | Exp_fvar (x, _) ->
            %(x.v.ident.idText)

        | Exp_constant c ->
            %(string_of_sconst c)

        | Exp_abs (x, _, e) ->
            let lenv = push env x.realname.idText x.ppname.idText in
            let x    = resolve lenv x.realname.idText in
            let d    = doc_of_exp (min_op_prec, NonAssoc) lenv e in
            maybe_paren outer e_bin_prio_lambda (%"fun" +. %x +. %"->" +. d)

        | Exp_match ((Exp_fvar _ | Exp_bvar _), [p, None, e]) when Absyn.Util.is_wild_pat p ->
            doc_of_exp outer env e

        | Exp_match (e, bs) -> begin
            match bs with
            | [(Pat_constant (Const_bool true ), None, e1);
               (Pat_constant (Const_bool false), None, e2)]

            | [(Pat_constant (Const_bool false), None, e1);
               (Pat_constant (Const_bool true ), None, e2)] ->

                let doc = %"if"   +. (doc_of_exp (e_bin_prio_if, Left)     env e ) +.
                          %"then" +. (doc_of_exp (e_bin_prio_if, NonAssoc) env e1) +.
                          %"else" +. (doc_of_exp (e_bin_prio_if, Right   ) env e2) in

                maybe_paren outer e_bin_prio_if doc

            | _ ->
                let de = doc_of_exp (min_op_prec, NonAssoc) env e in
                let bs = bs |> List.map (fun b -> group (%"|" +. doc_of_branch env b)) in
                align ((group (%"match" +. de +. %"with")) :: bs)
        end

        | Exp_let ((rec_, lb), body) ->
            let downct (x, _, e) =
                match x with
                | Inl x -> (x, e)
                | Inr _ -> unexpected () in

            let kw = if rec_ then "let rec" else "let" in
            let lenv, ds = lb |> List.map downct |> Util.fold_map (doc_of_let rec_) env in
            let doc = %kw +. (join " and " (ds |> List.map group)) +. %"in" +.
                      (doc_of_exp (min_op_prec, NonAssoc) lenv body) in

            maybe_paren outer e_bin_prio_letin doc

        | Exp_primop (x, es) ->
            let x = string_of_primop env x.idText in
            if   List.isEmpty es
            then %x
            else %x +. (groups (es |> List.map (doc_of_exp outer env)))

        | Exp_ascribed (e, _) ->
            doc_of_exp outer env e

        | Exp_meta (Meta_info (e, _, _)) ->
            doc_of_exp outer env e

        | Exp_meta (Meta_desugared (e, Data_app)) ->
            let (c, args) =
                match Absyn.Util.destruct_app e with
                | Exp_fvar (c, true), args -> (c, args)
                | _, _ -> unexpected ()
            in
            
            let dargs = args |> List.map (fst >> doc_of_exp (min_op_prec, NonAssoc) env) in

            doc_of_constr env c.v dargs
            
        | Exp_meta (Meta_desugared (e, Sequence)) -> begin
            match e with
            | Exp_let ((false, [Inl _, _, e1]), e2) ->
                let d1 = doc_of_exp (e_bin_prio_seq, Left ) env e1 in
                let d2 = doc_of_exp (e_bin_prio_seq, Right) env e2 in

                maybe_paren outer e_bin_prio_seq (d1 @. %";" +. d2)

            | _ -> unexpected ()
        end

        | Exp_meta (Meta_datainst (e, _)) ->
            doc_of_exp outer env e

        | Exp_tapp (e, _) ->
            (* FIXME: add a type annotation *)
            doc_of_exp outer env e

        | Exp_app  _ -> unexpected  ()
        | Exp_uvar _ -> unexpected  ()
        | Exp_tabs _ -> unsupported ()
    end

(* -------------------------------------------------------------------- *)
and maybe_doc_of_primexp_r outer (env : env) (e : exp) =
    match Absyn.Util.destruct_app e with
    | (Exp_fvar (x, _), [(e1, _); (e2, _)]) when is_prim_ns x.v.ns -> begin
        let test (y, _, _) = x.v.ident.idText = y in

        match List.tryFind test infix_prim_ops with
        | None -> None
        | Some (_, prio, txt) ->
            let d1 = doc_of_exp (prio, Left ) env e1 in
            let d2 = doc_of_exp (prio, Right) env e2 in
            Some (maybe_paren outer prio (d1 +. %txt +. d2))
    end

    | _ -> None

(* -------------------------------------------------------------------- *)
and doc_of_constr (env : env) c args =
    let x = c.ident.idText in

    match args with
    | [] -> %x
    | _  -> %x +. group (parens (join ", " args))

(* -------------------------------------------------------------------- *)
and doc_of_let (rec_ : bool) (env : env) (x, e) =
    let lenv = push env x.realname.idText x.ppname.idText in
    let x    = resolve lenv x.realname.idText in
    let d    = doc_of_exp (min_op_prec, NonAssoc) (if rec_ then lenv else env) e in
    lenv, %x +. %"=" +. d

(* -------------------------------------------------------------------- *)
and doc_of_toplet (rec_ : bool) (env : env) (x, e) =
    let lenv = push env x.idText x.idText in
    let x    = resolve lenv x.idText in

    let bds, e = destruct_fun e in
    let benv, args =
        Util.fold_map
            (fun lenv (x, _) ->
                let lenv = push lenv x.realname.idText x.ppname.idText in
                let x    = resolve lenv x.realname.idText in
                (lenv, %x))
            (if rec_ then lenv else env) bds in
    let d = doc_of_exp (min_op_prec, NonAssoc) benv e in

    lenv, group (%x +. (group (joins args)) +. %"=") +. d

(* -------------------------------------------------------------------- *)
and doc_of_pattern env p : env * doc =
    let env, d = doc_of_pattern_r env p in
    (env, group d)

(* -------------------------------------------------------------------- *)
and doc_of_pattern_r env (p : pat) : env * doc =
    match p with
    | Pat_cons (x, ps) ->
        let env, ds = ps |> Util.fold_map doc_of_pattern env in
        (env, doc_of_constr env x ds)

    | Pat_var x ->
        let env = push env x.realname.idText x.ppname.idText in
        (env, %(resolve env x.realname.idText))

    | Pat_constant c ->
        (env, %(string_of_sconst c))

    | Pat_disj ps ->
        let env, ds = ps |> Util.fold_map doc_of_pattern env in
        (env, parens (join "|" ds))

    | Pat_wild ->
        (env, %"_")

    | Pat_withinfo (p, _) ->
        doc_of_pattern env p

    | Pat_tvar  _ -> unsupported ()
    | Pat_twild _ -> unsupported ()

(* -------------------------------------------------------------------- *)
and doc_of_branch (env : env) ((p, cl, body) : pat * exp option * exp) : doc =
    let env, pd = doc_of_pattern env p in
    let dwhen = cl |> Option.map (doc_of_exp (min_op_prec, NonAssoc) env) in
    let dbody = body |> doc_of_exp (min_op_prec, NonAssoc) env in
    let doc =
        match dwhen with
        | None -> pd +. %"->" +. dbody
        | Some dwhen -> pd +. %"when" +. (parens dwhen) +. %"->" +. dbody in

    group doc

(* -------------------------------------------------------------------- *)
let is_kind_for_mldtype (k : kind) =
    match k with
    | Kind_star    -> true
    | Kind_unknown -> true
    | Kind_dcon _  -> false
    | Kind_tcon _  -> false
    | Kind_uvar _  -> unexpected  ()

(* -------------------------------------------------------------------- *)
let mldtype_of_bundle (env : env) (indt : list<sigelt>) =
    let (ts, cs) =
        let fold1 sigelt (types, ctors) =
            match sigelt with
            | Sig_tycon (x, tps, k, ts, cs, _, _) ->
                if not (is_kind_for_mldtype k) then
                    unsupported ()
                else
                    ((x.ident.idText, tps, cs) :: types, ctors)

            | Sig_datacon (x, ty, pr, _) ->
                (types, (x.ident.idText, (ty, pr)) :: ctors)

            | _ -> unsupported ()
        in

        let (ts, cs) = List.foldBack fold1 indt ([], []) in

        (ts, Map.ofList cs)
    in

    let fortype (x, tps, tcs) =
        if not (List.isEmpty tps) then unsupported ();

        let mldcons_of_cons cname =
            let (c, _) = Map.find cname.ident.idText cs in
            let (args, name) = mltycons_of_mlty (mlty_of_ty c) in

            match name with
            | Ty_named (name, []) when name = (root env, x) ->
                (cname.ident.idText, args)
            | _ -> unexpected ()            

        in (x, List.map mldcons_of_cons tcs)

    in List.map fortype ts

(* -------------------------------------------------------------------- *)
let doc_of_indt (env : env) (indt : list<sigelt>) =
    try
        let mltypes = mldtype_of_bundle env indt in

        let for_mltype (name, constrs) =
            let for_constr (name, tys) =
                let docs = List.map (fun (_, ty) -> doc_of_mltype (t_prio_tpl, NonAssoc) ty) tys in
                group (%"|" +. %name +. %"of" +. parens (join "*" docs))

            in group (%name +. %"=" +. group (joins (List.map for_constr constrs)))
        in
        let types = List.map for_mltype mltypes in
        let doc = %"type" +. (join "and" types) in
        (env, Some doc)

    with Failure _ -> (* FIXME *)
        (env, None)

(* -------------------------------------------------------------------- *)
let doc_of_modelt (env : env) (modx : sigelt) : env * doc option =
    match modx with
    | Sig_let ((rec_, lb), _) ->
        let downct (x, _, e) =
            match x with
            | Inr x -> (x.ident, e)
            | Inl _ -> unexpected () in

        let kw = if rec_ then "let rec" else "let" in
        let env, ds = lb |> List.map downct |> Util.fold_map (doc_of_toplet rec_) env in
        env, Some (%kw +. (join "and" (ds |> List.map group)))

    | Sig_main (e, _) ->
        env, Some (%"let" +. %"_" +. %"=" +. (doc_of_exp (min_op_prec, NonAssoc) env e))

    | Sig_tycon _ ->
        env, None

    | Sig_typ_abbrev _ ->
        unsupported ()

    | Sig_bundle (indt, _) ->
        doc_of_indt env indt

    | Sig_assume         _ -> env, None
    | Sig_val_decl       _ -> env, None
    | Sig_logic_function _ -> env, None

    | Sig_datacon _ -> unexpected ()

(* -------------------------------------------------------------------- *)
let pp_module (mod_ : modul) =
    let env = NameEnv.create (path_of_lid mod_.name) in
    let env, parts = mod_.declarations |> Util.choose_map doc_of_modelt env in

    sprintf "module %s = struct\n%s\nend"
        mod_.name.ident.idText
        (parts |> List.map (FSharp.Format.pretty 80) |> String.concat "\n\n")
