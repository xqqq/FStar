
open Prims
type verify_mode =
| VerifyAll
| VerifyUserList
| VerifyFigureItOut


let uu___is_VerifyAll : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyAll -> begin
true
end
| uu____4 -> begin
false
end))


let uu___is_VerifyUserList : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyUserList -> begin
true
end
| uu____8 -> begin
false
end))


let uu___is_VerifyFigureItOut : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyFigureItOut -> begin
true
end
| uu____12 -> begin
false
end))


type map =
(Prims.string Prims.option * Prims.string Prims.option) FStar_Util.smap

type color =
| White
| Gray
| Black


let uu___is_White : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| White -> begin
true
end
| uu____21 -> begin
false
end))


let uu___is_Gray : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Gray -> begin
true
end
| uu____25 -> begin
false
end))


let uu___is_Black : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Black -> begin
true
end
| uu____29 -> begin
false
end))


let check_and_strip_suffix : Prims.string  ->  Prims.string Prims.option = (fun f -> (

let suffixes = (".fsti")::(".fst")::(".fsi")::(".fs")::[]
in (

let matches = (FStar_List.map (fun ext -> (

let lext = (FStar_String.length ext)
in (

let l = (FStar_String.length f)
in (

let uu____46 = ((l > lext) && (let _0_802 = (FStar_String.substring f (l - lext) lext)
in (_0_802 = ext)))
in (match (uu____46) with
| true -> begin
Some ((FStar_String.substring f (Prims.parse_int "0") (l - lext)))
end
| uu____65 -> begin
None
end))))) suffixes)
in (

let uu____66 = (FStar_List.filter FStar_Util.is_some matches)
in (match (uu____66) with
| (Some (m))::uu____72 -> begin
Some (m)
end
| uu____76 -> begin
None
end)))))


let is_interface : Prims.string  ->  Prims.bool = (fun f -> (let _0_803 = (FStar_String.get f ((FStar_String.length f) - (Prims.parse_int "1")))
in (_0_803 = 'i')))


let is_implementation : Prims.string  ->  Prims.bool = (fun f -> (not ((is_interface f))))


let list_of_option = (fun uu___129_96 -> (match (uu___129_96) with
| Some (x) -> begin
(x)::[]
end
| None -> begin
[]
end))


let list_of_pair = (fun uu____110 -> (match (uu____110) with
| (intf, impl) -> begin
(FStar_List.append (list_of_option intf) (list_of_option impl))
end))


let lowercase_module_name : Prims.string  ->  Prims.string = (fun f -> (

let uu____124 = (check_and_strip_suffix (FStar_Util.basename f))
in (match (uu____124) with
| Some (longname) -> begin
(FStar_String.lowercase longname)
end
| None -> begin
(Prims.raise (FStar_Errors.Err ((FStar_Util.format1 "not a valid FStar file: %s\n" f))))
end)))


let try_convert_file_name_to_windows : Prims.string  ->  Prims.string = (fun s -> try
(match (()) with
| () -> begin
(

let uu____131 = (FStar_Util.run_proc "which" "cygpath" "")
in (match (uu____131) with
| (uu____135, t_out, uu____137) -> begin
(match ((not (((FStar_Util.trim_string t_out) = "/usr/bin/cygpath")))) with
| true -> begin
s
end
| uu____138 -> begin
(

let uu____139 = (FStar_Util.run_proc "cygpath" (Prims.strcat "-m " s) "")
in (match (uu____139) with
| (uu____143, t_out, uu____145) -> begin
(FStar_Util.trim_string t_out)
end))
end)
end))
end)
with
| uu____147 -> begin
s
end)


let build_map : Prims.string Prims.list  ->  map = (fun filenames -> (

let include_directories = (FStar_Options.include_path ())
in (

let include_directories = (FStar_List.map try_convert_file_name_to_windows include_directories)
in (

let include_directories = (FStar_List.map FStar_Util.normalize_file_path include_directories)
in (

let include_directories = (FStar_List.unique include_directories)
in (

let cwd = (FStar_Util.normalize_file_path (FStar_Util.getcwd ()))
in (

let map = (FStar_Util.smap_create (Prims.parse_int "41"))
in (

let add_entry = (fun key full_path -> (

let uu____179 = (FStar_Util.smap_try_find map key)
in (match (uu____179) with
| Some (intf, impl) -> begin
(

let uu____199 = (is_interface full_path)
in (match (uu____199) with
| true -> begin
(FStar_Util.smap_add map key ((Some (full_path)), (impl)))
end
| uu____206 -> begin
(FStar_Util.smap_add map key ((intf), (Some (full_path))))
end))
end
| None -> begin
(

let uu____217 = (is_interface full_path)
in (match (uu____217) with
| true -> begin
(FStar_Util.smap_add map key ((Some (full_path)), (None)))
end
| uu____224 -> begin
(FStar_Util.smap_add map key ((None), (Some (full_path))))
end))
end)))
in ((FStar_List.iter (fun d -> (match ((FStar_Util.file_exists d)) with
| true -> begin
(

let files = (FStar_Util.readdir d)
in (FStar_List.iter (fun f -> (

let f = (FStar_Util.basename f)
in (

let uu____237 = (check_and_strip_suffix f)
in (match (uu____237) with
| Some (longname) -> begin
(

let full_path = (match ((d = cwd)) with
| true -> begin
f
end
| uu____241 -> begin
(FStar_Util.join_paths d f)
end)
in (

let key = (FStar_String.lowercase longname)
in (add_entry key full_path)))
end
| None -> begin
()
end)))) files))
end
| uu____243 -> begin
(Prims.raise (FStar_Errors.Err ((FStar_Util.format1 "not a valid include directory: %s\n" d))))
end)) include_directories);
(FStar_List.iter (fun f -> (let _0_804 = (lowercase_module_name f)
in (add_entry _0_804 f))) filenames);
map;
)))))))))


let enter_namespace : map  ->  map  ->  Prims.string  ->  Prims.bool = (fun original_map working_map prefix -> (

let found = (FStar_Util.mk_ref false)
in (

let prefix = (Prims.strcat prefix ".")
in ((let _0_805 = (FStar_List.unique (FStar_Util.smap_keys original_map))
in (FStar_List.iter (fun k -> (match ((FStar_Util.starts_with k prefix)) with
| true -> begin
(

let suffix = (FStar_String.substring k (FStar_String.length prefix) ((FStar_String.length k) - (FStar_String.length prefix)))
in (

let filename = (FStar_Util.must (FStar_Util.smap_try_find original_map k))
in ((FStar_Util.smap_add working_map suffix filename);
(FStar_ST.write found true);
)))
end
| uu____289 -> begin
()
end)) _0_805));
(FStar_ST.read found);
))))


let string_of_lid : FStar_Ident.lident  ->  Prims.bool  ->  Prims.string = (fun l last -> (

let suffix = (match (last) with
| true -> begin
(l.FStar_Ident.ident.FStar_Ident.idText)::[]
end
| uu____305 -> begin
[]
end)
in (

let names = (let _0_806 = (FStar_List.map (fun x -> x.FStar_Ident.idText) l.FStar_Ident.ns)
in (FStar_List.append _0_806 suffix))
in (FStar_String.concat "." names))))


let lowercase_join_longident : FStar_Ident.lident  ->  Prims.bool  ->  Prims.string = (fun l last -> (FStar_String.lowercase (string_of_lid l last)))


let check_module_declaration_against_filename : FStar_Ident.lident  ->  Prims.string  ->  Prims.unit = (fun lid filename -> (

let k' = (lowercase_join_longident lid true)
in (

let uu____322 = (let _0_807 = (FStar_String.lowercase (FStar_Util.must (check_and_strip_suffix (FStar_Util.basename filename))))
in (_0_807 <> k'))
in (match (uu____322) with
| true -> begin
(let _0_809 = (let _0_808 = (string_of_lid lid true)
in (_0_808)::(filename)::[])
in (FStar_Util.fprint FStar_Util.stderr "Warning: the module declaration \"module %s\" found in file %s does not match its filename. Dependencies will be incorrect.\n" _0_809))
end
| uu____323 -> begin
()
end))))

exception Exit


let uu___is_Exit : Prims.exn  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Exit -> begin
true
end
| uu____327 -> begin
false
end))


let collect_one : (Prims.string * Prims.bool FStar_ST.ref) Prims.list  ->  verify_mode  ->  Prims.bool  ->  map  ->  Prims.string  ->  Prims.string Prims.list = (fun verify_flags verify_mode is_user_provided_filename original_map filename -> (

let deps = (FStar_Util.mk_ref [])
in (

let add_dep = (fun d -> (

let uu____362 = (not ((let _0_810 = (FStar_ST.read deps)
in (FStar_List.existsb (fun d' -> (d' = d)) _0_810))))
in (match (uu____362) with
| true -> begin
(let _0_812 = (let _0_811 = (FStar_ST.read deps)
in (d)::_0_811)
in (FStar_ST.write deps _0_812))
end
| uu____373 -> begin
()
end)))
in (

let working_map = (FStar_Util.smap_copy original_map)
in (

let record_open = (fun let_open lid -> (

let key = (lowercase_join_longident lid true)
in (

let uu____392 = (FStar_Util.smap_try_find working_map key)
in (match (uu____392) with
| Some (pair) -> begin
(FStar_List.iter (fun f -> (add_dep (lowercase_module_name f))) (list_of_pair pair))
end
| None -> begin
(

let r = (enter_namespace original_map working_map key)
in (match ((not (r))) with
| true -> begin
(match (let_open) with
| true -> begin
(Prims.raise (FStar_Errors.Err ("let-open only supported for modules, not namespaces")))
end
| uu____417 -> begin
(let _0_814 = (let _0_813 = (string_of_lid lid true)
in (_0_813)::[])
in (FStar_Util.fprint FStar_Util.stderr "Warning: no modules in namespace %s and no file with that name either\n" _0_814))
end)
end
| uu____418 -> begin
()
end))
end))))
in (

let record_module_alias = (fun ident lid -> (

let key = (FStar_String.lowercase (FStar_Ident.text_of_id ident))
in (

let alias = (lowercase_join_longident lid true)
in (

let uu____428 = (FStar_Util.smap_try_find original_map alias)
in (match (uu____428) with
| Some (deps_of_aliased_module) -> begin
(FStar_Util.smap_add working_map key deps_of_aliased_module)
end
| None -> begin
(Prims.raise (FStar_Errors.Err ((FStar_Util.format1 "module not found in search path: %s\n" alias))))
end)))))
in (

let record_lid = (fun lid -> (

let try_key = (fun key -> (

let uu____463 = (FStar_Util.smap_try_find working_map key)
in (match (uu____463) with
| Some (pair) -> begin
(FStar_List.iter (fun f -> (add_dep (lowercase_module_name f))) (list_of_pair pair))
end
| None -> begin
(

let uu____487 = (((FStar_List.length lid.FStar_Ident.ns) > (Prims.parse_int "0")) && (FStar_Options.debug_any ()))
in (match (uu____487) with
| true -> begin
(let _0_816 = (let _0_815 = (string_of_lid lid false)
in (_0_815)::[])
in (FStar_Util.fprint FStar_Util.stderr "Warning: unbound module reference %s\n" _0_816))
end
| uu____491 -> begin
()
end))
end)))
in (try_key (lowercase_join_longident lid false))))
in (

let auto_open = (

let uu____495 = (let _0_817 = (FStar_Util.basename filename)
in (_0_817 = "prims.fst"))
in (match (uu____495) with
| true -> begin
[]
end
| uu____497 -> begin
(FStar_Syntax_Const.fstar_ns_lid)::(FStar_Syntax_Const.prims_lid)::[]
end))
in ((FStar_List.iter (record_open false) auto_open);
(

let num_of_toplevelmods = (FStar_Util.mk_ref (Prims.parse_int "0"))
in (

let rec collect_fragment = (fun uu___130_570 -> (match (uu___130_570) with
| FStar_Util.Inl (file) -> begin
(collect_file file)
end
| FStar_Util.Inr (decls) -> begin
(collect_decls decls)
end))
and collect_file = (fun uu___131_583 -> (match (uu___131_583) with
| (modul)::[] -> begin
(collect_module modul)
end
| modules -> begin
((FStar_Util.fprint FStar_Util.stderr "Warning: file %s does not respect the one module per file convention\n" ((filename)::[]));
(FStar_List.iter collect_module modules);
)
end))
and collect_module = (fun uu___132_589 -> (match (uu___132_589) with
| (FStar_Parser_AST.Module (lid, decls)) | (FStar_Parser_AST.Interface (lid, decls, _)) -> begin
((check_module_declaration_against_filename lid filename);
(match (verify_mode) with
| VerifyAll -> begin
(FStar_Options.add_verify_module (string_of_lid lid true))
end
| VerifyFigureItOut -> begin
(match (is_user_provided_filename) with
| true -> begin
(FStar_Options.add_verify_module (string_of_lid lid true))
end
| uu____599 -> begin
()
end)
end
| VerifyUserList -> begin
(FStar_List.iter (fun uu____603 -> (match (uu____603) with
| (m, r) -> begin
(

let uu____611 = (let _0_818 = (FStar_String.lowercase (string_of_lid lid true))
in ((FStar_String.lowercase m) = _0_818))
in (match (uu____611) with
| true -> begin
(FStar_ST.write r true)
end
| uu____614 -> begin
()
end))
end)) verify_flags)
end);
(collect_decls decls);
)
end))
and collect_decls = (fun decls -> (FStar_List.iter (fun x -> ((collect_decl x.FStar_Parser_AST.d);
(FStar_List.iter collect_term x.FStar_Parser_AST.attrs);
)) decls))
and collect_decl = (fun uu___133_619 -> (match (uu___133_619) with
| (FStar_Parser_AST.Include (lid)) | (FStar_Parser_AST.Open (lid)) -> begin
(record_open false lid)
end
| FStar_Parser_AST.ModuleAbbrev (ident, lid) -> begin
((add_dep (lowercase_join_longident lid true));
(record_module_alias ident lid);
)
end
| FStar_Parser_AST.TopLevelLet (uu____624, patterms) -> begin
(FStar_List.iter (fun uu____634 -> (match (uu____634) with
| (pat, t) -> begin
((collect_pattern pat);
(collect_term t);
)
end)) patterms)
end
| (FStar_Parser_AST.Main (t)) | (FStar_Parser_AST.Assume (_, t)) | (FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = _; FStar_Parser_AST.mdest = _; FStar_Parser_AST.lift_op = FStar_Parser_AST.NonReifiableLift (t)})) | (FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = _; FStar_Parser_AST.mdest = _; FStar_Parser_AST.lift_op = FStar_Parser_AST.LiftForFree (t)})) | (FStar_Parser_AST.Val (_, t)) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____647; FStar_Parser_AST.mdest = uu____648; FStar_Parser_AST.lift_op = FStar_Parser_AST.ReifiableLift (t0, t1)}) -> begin
((collect_term t0);
(collect_term t1);
)
end
| FStar_Parser_AST.Tycon (uu____652, ts) -> begin
(

let ts = (FStar_List.map (fun uu____667 -> (match (uu____667) with
| (x, doc) -> begin
x
end)) ts)
in (FStar_List.iter collect_tycon ts))
end
| FStar_Parser_AST.Exception (uu____675, t) -> begin
(FStar_Util.iter_opt t collect_term)
end
| (FStar_Parser_AST.NewEffectForFree (ed)) | (FStar_Parser_AST.NewEffect (ed)) -> begin
(collect_effect_decl ed)
end
| (FStar_Parser_AST.Fsdoc (_)) | (FStar_Parser_AST.Pragma (_)) -> begin
()
end
| FStar_Parser_AST.TopLevelModule (lid) -> begin
((FStar_Util.incr num_of_toplevelmods);
(

let uu____687 = (let _0_819 = (FStar_ST.read num_of_toplevelmods)
in (_0_819 > (Prims.parse_int "1")))
in (match (uu____687) with
| true -> begin
(Prims.raise (FStar_Errors.Err ((let _0_820 = (string_of_lid lid true)
in (FStar_Util.format1 "Automatic dependency analysis demands one module per file (module %s not supported)" _0_820)))))
end
| uu____690 -> begin
()
end));
)
end))
and collect_tycon = (fun uu___134_691 -> (match (uu___134_691) with
| FStar_Parser_AST.TyconAbstract (uu____692, binders, k) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
)
end
| FStar_Parser_AST.TyconAbbrev (uu____700, binders, k, t) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(collect_term t);
)
end
| FStar_Parser_AST.TyconRecord (uu____710, binders, k, identterms) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(FStar_List.iter (fun uu____734 -> (match (uu____734) with
| (uu____739, t, uu____741) -> begin
(collect_term t)
end)) identterms);
)
end
| FStar_Parser_AST.TyconVariant (uu____744, binders, k, identterms) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(FStar_List.iter (fun uu____774 -> (match (uu____774) with
| (uu____781, t, uu____783, uu____784) -> begin
(FStar_Util.iter_opt t collect_term)
end)) identterms);
)
end))
and collect_effect_decl = (fun uu___135_789 -> (match (uu___135_789) with
| FStar_Parser_AST.DefineEffect (uu____790, binders, t, decls, actions) -> begin
((collect_binders binders);
(collect_term t);
(collect_decls decls);
(collect_decls actions);
)
end
| FStar_Parser_AST.RedefineEffect (uu____804, binders, t) -> begin
((collect_binders binders);
(collect_term t);
)
end))
and collect_binders = (fun binders -> (FStar_List.iter collect_binder binders))
and collect_binder = (fun uu___136_812 -> (match (uu___136_812) with
| ({FStar_Parser_AST.b = FStar_Parser_AST.Annotated (_, t); FStar_Parser_AST.brange = _; FStar_Parser_AST.blevel = _; FStar_Parser_AST.aqual = _}) | ({FStar_Parser_AST.b = FStar_Parser_AST.TAnnotated (_, t); FStar_Parser_AST.brange = _; FStar_Parser_AST.blevel = _; FStar_Parser_AST.aqual = _}) | ({FStar_Parser_AST.b = FStar_Parser_AST.NoName (t); FStar_Parser_AST.brange = _; FStar_Parser_AST.blevel = _; FStar_Parser_AST.aqual = _}) -> begin
(collect_term t)
end
| uu____825 -> begin
()
end))
and collect_term = (fun t -> (collect_term' t.FStar_Parser_AST.tm))
and collect_constant = (fun uu___137_827 -> (match (uu___137_827) with
| FStar_Const.Const_int (uu____828, Some (signedness, width)) -> begin
(

let u = (match (signedness) with
| FStar_Const.Unsigned -> begin
"u"
end
| FStar_Const.Signed -> begin
""
end)
in (

let w = (match (width) with
| FStar_Const.Int8 -> begin
"8"
end
| FStar_Const.Int16 -> begin
"16"
end
| FStar_Const.Int32 -> begin
"32"
end
| FStar_Const.Int64 -> begin
"64"
end)
in (add_dep (FStar_Util.format2 "fstar.%sint%s" u w))))
end
| uu____838 -> begin
()
end))
and collect_term' = (fun uu___138_839 -> (match (uu___138_839) with
| FStar_Parser_AST.Wild -> begin
()
end
| FStar_Parser_AST.Const (c) -> begin
(collect_constant c)
end
| FStar_Parser_AST.Op (s, ts) -> begin
((match ((s = "@")) with
| true -> begin
(collect_term' (FStar_Parser_AST.Name ((FStar_Ident.lid_of_path (FStar_Ident.path_of_text "FStar.List.Tot.Base.append") FStar_Range.dummyRange))))
end
| uu____846 -> begin
()
end);
(FStar_List.iter collect_term ts);
)
end
| (FStar_Parser_AST.Tvar (_)) | (FStar_Parser_AST.Uvar (_)) -> begin
()
end
| (FStar_Parser_AST.Var (lid)) | (FStar_Parser_AST.Projector (lid, _)) | (FStar_Parser_AST.Discrim (lid)) | (FStar_Parser_AST.Name (lid)) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Construct (lid, termimps) -> begin
((match (((FStar_List.length termimps) = (Prims.parse_int "1"))) with
| true -> begin
(record_lid lid)
end
| uu____864 -> begin
()
end);
(FStar_List.iter (fun uu____867 -> (match (uu____867) with
| (t, uu____871) -> begin
(collect_term t)
end)) termimps);
)
end
| FStar_Parser_AST.Abs (pats, t) -> begin
((collect_patterns pats);
(collect_term t);
)
end
| FStar_Parser_AST.App (t1, t2, uu____879) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Let (uu____881, patterms, t) -> begin
((FStar_List.iter (fun uu____893 -> (match (uu____893) with
| (pat, t) -> begin
((collect_pattern pat);
(collect_term t);
)
end)) patterms);
(collect_term t);
)
end
| FStar_Parser_AST.LetOpen (lid, t) -> begin
((record_open true lid);
(collect_term t);
)
end
| FStar_Parser_AST.Seq (t1, t2) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.If (t1, t2, t3) -> begin
((collect_term t1);
(collect_term t2);
(collect_term t3);
)
end
| (FStar_Parser_AST.Match (t, bs)) | (FStar_Parser_AST.TryWith (t, bs)) -> begin
((collect_term t);
(collect_branches bs);
)
end
| FStar_Parser_AST.Ascribed (t1, t2) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Record (t, idterms) -> begin
((FStar_Util.iter_opt t collect_term);
(FStar_List.iter (fun uu____949 -> (match (uu____949) with
| (uu____952, t) -> begin
(collect_term t)
end)) idterms);
)
end
| FStar_Parser_AST.Project (t, uu____955) -> begin
(collect_term t)
end
| (FStar_Parser_AST.Product (binders, t)) | (FStar_Parser_AST.Sum (binders, t)) -> begin
((collect_binders binders);
(collect_term t);
)
end
| (FStar_Parser_AST.QForall (binders, ts, t)) | (FStar_Parser_AST.QExists (binders, ts, t)) -> begin
((collect_binders binders);
(FStar_List.iter (FStar_List.iter collect_term) ts);
(collect_term t);
)
end
| FStar_Parser_AST.Refine (binder, t) -> begin
((collect_binder binder);
(collect_term t);
)
end
| FStar_Parser_AST.NamedTyp (uu____984, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Paren (t) -> begin
(collect_term t)
end
| (FStar_Parser_AST.Assign (_, t)) | (FStar_Parser_AST.Requires (t, _)) | (FStar_Parser_AST.Ensures (t, _)) | (FStar_Parser_AST.Labeled (t, _, _)) -> begin
(collect_term t)
end
| FStar_Parser_AST.Attributes (cattributes) -> begin
(FStar_List.iter collect_term cattributes)
end))
and collect_patterns = (fun ps -> (FStar_List.iter collect_pattern ps))
and collect_pattern = (fun p -> (collect_pattern' p.FStar_Parser_AST.pat))
and collect_pattern' = (fun uu___139_1000 -> (match (uu___139_1000) with
| (FStar_Parser_AST.PatWild) | (FStar_Parser_AST.PatOp (_)) | (FStar_Parser_AST.PatConst (_)) -> begin
()
end
| FStar_Parser_AST.PatApp (p, ps) -> begin
((collect_pattern p);
(collect_patterns ps);
)
end
| (FStar_Parser_AST.PatVar (_)) | (FStar_Parser_AST.PatName (_)) | (FStar_Parser_AST.PatTvar (_)) -> begin
()
end
| (FStar_Parser_AST.PatList (ps)) | (FStar_Parser_AST.PatOr (ps)) | (FStar_Parser_AST.PatTuple (ps, _)) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatRecord (lidpats) -> begin
(FStar_List.iter (fun uu____1023 -> (match (uu____1023) with
| (uu____1026, p) -> begin
(collect_pattern p)
end)) lidpats)
end
| FStar_Parser_AST.PatAscribed (p, t) -> begin
((collect_pattern p);
(collect_term t);
)
end))
and collect_branches = (fun bs -> (FStar_List.iter collect_branch bs))
and collect_branch = (fun uu____1041 -> (match (uu____1041) with
| (pat, t1, t2) -> begin
((collect_pattern pat);
(FStar_Util.iter_opt t1 collect_term);
(collect_term t2);
)
end))
in (

let uu____1053 = (FStar_Parser_Driver.parse_file filename)
in (match (uu____1053) with
| (ast, uu____1061) -> begin
((collect_file ast);
(FStar_ST.read deps);
)
end))));
)))))))))


let print_graph = (fun graph -> ((FStar_Util.print_endline "A DOT-format graph has been dumped in the current directory as dep.graph");
(FStar_Util.print_endline "With GraphViz installed, try: fdp -Tpng -odep.png dep.graph");
(FStar_Util.print_endline "Hint: cat dep.graph | grep -v _ | grep -v prims");
(let _0_825 = (let _0_824 = (let _0_823 = (let _0_822 = (let _0_821 = (FStar_List.unique (FStar_Util.smap_keys graph))
in (FStar_List.collect (fun k -> (

let deps = (Prims.fst (FStar_Util.must (FStar_Util.smap_try_find graph k)))
in (

let r = (fun s -> (FStar_Util.replace_char s '.' '_'))
in (FStar_List.map (fun dep -> (FStar_Util.format2 "  %s -> %s" (r k) (r dep))) deps)))) _0_821))
in (FStar_String.concat "\n" _0_822))
in (Prims.strcat _0_823 "\n}\n"))
in (Prims.strcat "digraph {\n" _0_824))
in (FStar_Util.write_file "dep.graph" _0_825));
))


let collect : verify_mode  ->  Prims.string Prims.list  ->  ((Prims.string * Prims.string Prims.list) Prims.list * Prims.string Prims.list * (Prims.string Prims.list * color) FStar_Util.smap) = (fun verify_mode filenames -> (

let graph = (FStar_Util.smap_create (Prims.parse_int "41"))
in (

let verify_flags = (let _0_827 = (FStar_Options.verify_module ())
in (FStar_List.map (fun f -> (let _0_826 = (FStar_Util.mk_ref false)
in ((f), (_0_826)))) _0_827))
in (

let m = (build_map filenames)
in (

let collect_one = (collect_one verify_flags verify_mode)
in (

let partial_discovery = (not (((FStar_Options.verify_all ()) || (FStar_Options.extract_all ()))))
in (

let rec discover_one = (fun is_user_provided_filename interface_only key -> (

let uu____1180 = (let _0_828 = (FStar_Util.smap_try_find graph key)
in (_0_828 = None))
in (match (uu____1180) with
| true -> begin
(

let uu____1191 = (FStar_Util.must (FStar_Util.smap_try_find m key))
in (match (uu____1191) with
| (intf, impl) -> begin
(

let intf_deps = (match (intf) with
| Some (intf) -> begin
(collect_one is_user_provided_filename m intf)
end
| None -> begin
[]
end)
in (

let impl_deps = (match (((impl), (intf))) with
| (Some (impl), Some (uu____1220)) when interface_only -> begin
[]
end
| (Some (impl), uu____1224) -> begin
(collect_one is_user_provided_filename m impl)
end
| (None, uu____1228) -> begin
[]
end)
in (

let deps = (FStar_List.unique (FStar_List.append impl_deps intf_deps))
in ((FStar_Util.smap_add graph key ((deps), (White)));
(FStar_List.iter (discover_one false partial_discovery) deps);
))))
end))
end
| uu____1239 -> begin
()
end)))
in (

let discover_command_line_argument = (fun f -> (

let m = (lowercase_module_name f)
in (

let uu____1245 = (is_interface f)
in (match (uu____1245) with
| true -> begin
(discover_one true true m)
end
| uu____1246 -> begin
(discover_one true false m)
end))))
in ((FStar_List.iter discover_command_line_argument filenames);
(

let immediate_graph = (FStar_Util.smap_copy graph)
in (

let topologically_sorted = (FStar_Util.mk_ref [])
in (

let rec discover = (fun cycle key -> (

let uu____1271 = (FStar_Util.must (FStar_Util.smap_try_find graph key))
in (match (uu____1271) with
| (direct_deps, color) -> begin
(match (color) with
| Gray -> begin
((FStar_Util.print1 "Warning: recursive dependency on module %s\n" key);
(FStar_Util.print1 "The cycle is: %s \n" (FStar_String.concat " -> " cycle));
(print_graph immediate_graph);
(FStar_Util.print_string "\n");
(FStar_All.exit (Prims.parse_int "1"));
)
end
| Black -> begin
direct_deps
end
| White -> begin
((FStar_Util.smap_add graph key ((direct_deps), (Gray)));
(

let all_deps = (FStar_List.unique (FStar_List.flatten (FStar_List.map (fun dep -> (let _0_829 = (discover ((key)::cycle) dep)
in (dep)::_0_829)) direct_deps)))
in ((FStar_Util.smap_add graph key ((all_deps), (Black)));
(let _0_831 = (let _0_830 = (FStar_ST.read topologically_sorted)
in (key)::_0_830)
in (FStar_ST.write topologically_sorted _0_831));
all_deps;
));
)
end)
end)))
in (

let discover = (discover [])
in (

let must_find = (fun k -> (

let uu____1322 = (FStar_Util.must (FStar_Util.smap_try_find m k))
in (match (uu____1322) with
| (Some (intf), Some (impl)) when ((not (partial_discovery)) && (not ((FStar_List.existsML (fun f -> (let _0_832 = (lowercase_module_name f)
in (_0_832 = k))) filenames)))) -> begin
(intf)::(impl)::[]
end
| (Some (intf), Some (impl)) when (FStar_List.existsML (fun f -> ((is_implementation f) && (let _0_833 = (lowercase_module_name f)
in (_0_833 = k)))) filenames) -> begin
(intf)::(impl)::[]
end
| (Some (intf), uu____1347) -> begin
(intf)::[]
end
| (None, Some (impl)) -> begin
(impl)::[]
end
| (None, None) -> begin
[]
end)))
in (

let must_find_r = (fun f -> (FStar_List.rev (must_find f)))
in (

let by_target = (let _0_835 = (FStar_Util.smap_keys graph)
in (FStar_List.collect (fun k -> (

let as_list = (must_find k)
in (

let is_interleaved = ((FStar_List.length as_list) = (Prims.parse_int "2"))
in (FStar_List.map (fun f -> (

let should_append_fsti = ((is_implementation f) && is_interleaved)
in (

let suffix = (match (should_append_fsti) with
| true -> begin
((Prims.strcat f "i"))::[]
end
| uu____1383 -> begin
[]
end)
in (

let k = (lowercase_module_name f)
in (

let deps = (FStar_List.rev (discover k))
in (

let deps_as_filenames = (let _0_834 = (FStar_List.collect must_find deps)
in (FStar_List.append _0_834 suffix))
in ((f), (deps_as_filenames)))))))) as_list)))) _0_835))
in (

let topologically_sorted = (let _0_836 = (FStar_ST.read topologically_sorted)
in (FStar_List.collect must_find_r _0_836))
in ((FStar_List.iter (fun uu____1402 -> (match (uu____1402) with
| (m, r) -> begin
(

let uu____1410 = ((not ((FStar_ST.read r))) && (not ((FStar_Options.interactive ()))))
in (match (uu____1410) with
| true -> begin
(

let maybe_fst = (

let k = (FStar_String.length m)
in (

let uu____1416 = ((k > (Prims.parse_int "4")) && (let _0_837 = (FStar_String.substring m (k - (Prims.parse_int "4")) (Prims.parse_int "4"))
in (_0_837 = ".fst")))
in (match (uu____1416) with
| true -> begin
(let _0_838 = (FStar_String.substring m (Prims.parse_int "0") (k - (Prims.parse_int "4")))
in (FStar_Util.format1 " Did you mean %s ?" _0_838))
end
| uu____1426 -> begin
""
end)))
in (Prims.raise (FStar_Errors.Err ((FStar_Util.format3 "You passed --verify_module %s but I found no file that contains [module %s] in the dependency graph.%s\n" m m maybe_fst)))))
end
| uu____1427 -> begin
()
end))
end)) verify_flags);
((by_target), (topologically_sorted), (immediate_graph));
)))))))));
)))))))))


let print_make : (Prims.string * Prims.string Prims.list) Prims.list  ->  Prims.unit = (fun deps -> (FStar_List.iter (fun uu____1451 -> (match (uu____1451) with
| (f, deps) -> begin
(

let deps = (FStar_List.map (fun s -> (FStar_Util.replace_string s " " "\\ ")) deps)
in (FStar_Util.print2 "%s: %s\n" f (FStar_String.concat " " deps)))
end)) deps))


let print = (fun uu____1481 -> (match (uu____1481) with
| (make_deps, uu____1494, graph) -> begin
(

let uu____1512 = (FStar_Options.dep ())
in (match (uu____1512) with
| Some ("make") -> begin
(print_make make_deps)
end
| Some ("graph") -> begin
(print_graph graph)
end
| Some (uu____1514) -> begin
(Prims.raise (FStar_Errors.Err ("unknown tool for --dep\n")))
end
| None -> begin
()
end))
end))




