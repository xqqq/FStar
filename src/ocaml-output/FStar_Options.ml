open Prims
let (debug_embedding : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
let (eager_embedding : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
type debug_level_t =
  | Low 
  | Medium 
  | High 
  | Extreme 
  | Other of Prims.string 
let (uu___is_Low : debug_level_t -> Prims.bool) =
  fun projectee  -> match projectee with | Low  -> true | uu____71 -> false 
let (uu___is_Medium : debug_level_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Medium  -> true | uu____82 -> false
  
let (uu___is_High : debug_level_t -> Prims.bool) =
  fun projectee  -> match projectee with | High  -> true | uu____93 -> false 
let (uu___is_Extreme : debug_level_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Extreme  -> true | uu____104 -> false
  
let (uu___is_Other : debug_level_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Other _0 -> true | uu____117 -> false
  
let (__proj__Other__item___0 : debug_level_t -> Prims.string) =
  fun projectee  -> match projectee with | Other _0 -> _0 
type option_val =
  | Bool of Prims.bool 
  | String of Prims.string 
  | Path of Prims.string 
  | Int of Prims.int 
  | List of option_val Prims.list 
  | Unset 
let (uu___is_Bool : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Bool _0 -> true | uu____172 -> false
  
let (__proj__Bool__item___0 : option_val -> Prims.bool) =
  fun projectee  -> match projectee with | Bool _0 -> _0 
let (uu___is_String : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | String _0 -> true | uu____196 -> false
  
let (__proj__String__item___0 : option_val -> Prims.string) =
  fun projectee  -> match projectee with | String _0 -> _0 
let (uu___is_Path : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Path _0 -> true | uu____220 -> false
  
let (__proj__Path__item___0 : option_val -> Prims.string) =
  fun projectee  -> match projectee with | Path _0 -> _0 
let (uu___is_Int : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Int _0 -> true | uu____244 -> false
  
let (__proj__Int__item___0 : option_val -> Prims.int) =
  fun projectee  -> match projectee with | Int _0 -> _0 
let (uu___is_List : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | List _0 -> true | uu____269 -> false
  
let (__proj__List__item___0 : option_val -> option_val Prims.list) =
  fun projectee  -> match projectee with | List _0 -> _0 
let (uu___is_Unset : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Unset  -> true | uu____294 -> false
  
let (mk_bool : Prims.bool -> option_val) = fun _0_1  -> Bool _0_1 
let (mk_string : Prims.string -> option_val) = fun _0_2  -> String _0_2 
let (mk_path : Prims.string -> option_val) = fun _0_3  -> Path _0_3 
let (mk_int : Prims.int -> option_val) = fun _0_4  -> Int _0_4 
let (mk_list : option_val Prims.list -> option_val) = fun _0_5  -> List _0_5 
let (__unit_tests__ : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
let (__unit_tests : unit -> Prims.bool) =
  fun uu____350  -> FStar_ST.op_Bang __unit_tests__ 
let (__set_unit_tests : unit -> unit) =
  fun uu____377  -> FStar_ST.op_Colon_Equals __unit_tests__ true 
let (__clear_unit_tests : unit -> unit) =
  fun uu____405  -> FStar_ST.op_Colon_Equals __unit_tests__ false 
let (as_bool : option_val -> Prims.bool) =
  fun uu___80_434  ->
    match uu___80_434 with
    | Bool b -> b
    | uu____438 -> failwith "Impos: expected Bool"
  
let (as_int : option_val -> Prims.int) =
  fun uu___81_447  ->
    match uu___81_447 with
    | Int b -> b
    | uu____451 -> failwith "Impos: expected Int"
  
let (as_string : option_val -> Prims.string) =
  fun uu___82_460  ->
    match uu___82_460 with
    | String b -> b
    | Path b -> FStar_Common.try_convert_file_name_to_mixed b
    | uu____466 -> failwith "Impos: expected String"
  
let (as_list' : option_val -> option_val Prims.list) =
  fun uu___83_476  ->
    match uu___83_476 with
    | List ts -> ts
    | uu____482 -> failwith "Impos: expected List"
  
let as_list :
  'Auu____493 .
    (option_val -> 'Auu____493) -> option_val -> 'Auu____493 Prims.list
  =
  fun as_t  ->
    fun x  ->
      let uu____511 = as_list' x  in
      FStar_All.pipe_right uu____511 (FStar_List.map as_t)
  
let as_option :
  'Auu____525 .
    (option_val -> 'Auu____525) ->
      option_val -> 'Auu____525 FStar_Pervasives_Native.option
  =
  fun as_t  ->
    fun uu___84_540  ->
      match uu___84_540 with
      | Unset  -> FStar_Pervasives_Native.None
      | v1 ->
          let uu____544 = as_t v1  in FStar_Pervasives_Native.Some uu____544
  
let (as_comma_string_list : option_val -> Prims.string Prims.list) =
  fun uu___85_553  ->
    match uu___85_553 with
    | List ls ->
        let uu____560 =
          FStar_List.map
            (fun l  ->
               let uu____572 = as_string l  in FStar_Util.split uu____572 ",")
            ls
           in
        FStar_All.pipe_left FStar_List.flatten uu____560
    | uu____584 -> failwith "Impos: expected String (comma list)"
  
type optionstate = option_val FStar_Util.smap
let (fstar_options : optionstate Prims.list Prims.list FStar_ST.ref) =
  FStar_Util.mk_ref [] 
let (peek : unit -> optionstate) =
  fun uu____620  ->
    let uu____621 =
      let uu____624 = FStar_ST.op_Bang fstar_options  in
      FStar_List.hd uu____624  in
    FStar_List.hd uu____621
  
let (pop : unit -> unit) =
  fun uu____663  ->
    let uu____664 = FStar_ST.op_Bang fstar_options  in
    match uu____664 with
    | [] -> failwith "TOO MANY POPS!"
    | uu____699::[] -> failwith "TOO MANY POPS!"
    | uu____707::tl1 -> FStar_ST.op_Colon_Equals fstar_options tl1
  
let (push : unit -> unit) =
  fun uu____749  ->
    let uu____750 =
      let uu____755 =
        let uu____758 =
          let uu____761 = FStar_ST.op_Bang fstar_options  in
          FStar_List.hd uu____761  in
        FStar_List.map FStar_Util.smap_copy uu____758  in
      let uu____795 = FStar_ST.op_Bang fstar_options  in uu____755 ::
        uu____795
       in
    FStar_ST.op_Colon_Equals fstar_options uu____750
  
let (internal_pop : unit -> Prims.bool) =
  fun uu____862  ->
    let curstack =
      let uu____866 = FStar_ST.op_Bang fstar_options  in
      FStar_List.hd uu____866  in
    match curstack with
    | [] -> failwith "impossible: empty current option stack"
    | uu____903::[] -> false
    | uu____905::tl1 ->
        ((let uu____910 =
            let uu____915 =
              let uu____920 = FStar_ST.op_Bang fstar_options  in
              FStar_List.tl uu____920  in
            tl1 :: uu____915  in
          FStar_ST.op_Colon_Equals fstar_options uu____910);
         true)
  
let (internal_push : unit -> unit) =
  fun uu____989  ->
    let curstack =
      let uu____993 = FStar_ST.op_Bang fstar_options  in
      FStar_List.hd uu____993  in
    let stack' =
      let uu____1030 =
        let uu____1031 = FStar_List.hd curstack  in
        FStar_Util.smap_copy uu____1031  in
      uu____1030 :: curstack  in
    let uu____1034 =
      let uu____1039 =
        let uu____1044 = FStar_ST.op_Bang fstar_options  in
        FStar_List.tl uu____1044  in
      stack' :: uu____1039  in
    FStar_ST.op_Colon_Equals fstar_options uu____1034
  
let (set : optionstate -> unit) =
  fun o  ->
    let uu____1113 = FStar_ST.op_Bang fstar_options  in
    match uu____1113 with
    | [] -> failwith "set on empty option stack"
    | []::uu____1148 -> failwith "set on empty current option stack"
    | (uu____1156::tl1)::os ->
        FStar_ST.op_Colon_Equals fstar_options ((o :: tl1) :: os)
  
let (snapshot : unit -> (Prims.int * unit)) =
  fun uu____1206  -> FStar_Common.snapshot push fstar_options () 
let (rollback : Prims.int FStar_Pervasives_Native.option -> unit) =
  fun depth  -> FStar_Common.rollback pop fstar_options depth 
let (set_option : Prims.string -> option_val -> unit) =
  fun k  ->
    fun v1  ->
      let uu____1236 = peek ()  in FStar_Util.smap_add uu____1236 k v1
  
let (set_option' : (Prims.string * option_val) -> unit) =
  fun uu____1249  -> match uu____1249 with | (k,v1) -> set_option k v1 
let (light_off_files : Prims.string Prims.list FStar_ST.ref) =
  FStar_Util.mk_ref [] 
let (add_light_off_file : Prims.string -> unit) =
  fun filename  ->
    let uu____1288 =
      let uu____1292 = FStar_ST.op_Bang light_off_files  in filename ::
        uu____1292
       in
    FStar_ST.op_Colon_Equals light_off_files uu____1288
  
let (defaults : (Prims.string * option_val) Prims.list) =
  [("__temp_no_proj", (List []));
  ("__temp_fast_implicits", (Bool false));
  ("abort_on", (Int (Prims.parse_int "0")));
  ("admit_smt_queries", (Bool false));
  ("admit_except", Unset);
  ("already_cached", Unset);
  ("cache_checked_modules", (Bool false));
  ("cache_dir", Unset);
  ("cache_off", (Bool false));
  ("cmi", (Bool false));
  ("codegen", Unset);
  ("codegen-lib", (List []));
  ("debug", (List []));
  ("debug_level", (List []));
  ("defensive", (String "no"));
  ("dep", Unset);
  ("detail_errors", (Bool false));
  ("detail_hint_replay", (Bool false));
  ("doc", (Bool false));
  ("dump_module", (List []));
  ("eager_inference", (Bool false));
  ("eager_subtyping", (Bool false));
  ("expose_interfaces", (Bool false));
  ("extract", Unset);
  ("extract_all", (Bool false));
  ("extract_module", (List []));
  ("extract_namespace", (List []));
  ("fs_typ_app", (Bool false));
  ("full_context_dependency", (Bool true));
  ("hide_uvar_nums", (Bool false));
  ("hint_info", (Bool false));
  ("hint_file", Unset);
  ("in", (Bool false));
  ("ide", (Bool false));
  ("include", (List []));
  ("print", (Bool false));
  ("print_in_place", (Bool false));
  ("profile", (Bool false));
  ("protect_top_level_axioms", (Bool false));
  ("initial_fuel", (Int (Prims.parse_int "2")));
  ("initial_ifuel", (Int (Prims.parse_int "1")));
  ("keep_query_captions", (Bool true));
  ("lax", (Bool false));
  ("load", (List []));
  ("log_queries", (Bool false));
  ("log_types", (Bool false));
  ("max_fuel", (Int (Prims.parse_int "8")));
  ("max_ifuel", (Int (Prims.parse_int "2")));
  ("min_fuel", (Int (Prims.parse_int "1")));
  ("MLish", (Bool false));
  ("n_cores", (Int (Prims.parse_int "1")));
  ("no_default_includes", (Bool false));
  ("no_extract", (List []));
  ("no_location_info", (Bool false));
  ("no_smt", (Bool false));
  ("no_plugins", (Bool false));
  ("no_tactics", (Bool false));
  ("normalize_pure_terms_for_extraction", (Bool false));
  ("odir", Unset);
  ("prims", Unset);
  ("pretype", (Bool true));
  ("prims_ref", Unset);
  ("print_bound_var_types", (Bool false));
  ("print_effect_args", (Bool false));
  ("print_full_names", (Bool false));
  ("print_implicits", (Bool false));
  ("print_universes", (Bool false));
  ("print_z3_statistics", (Bool false));
  ("prn", (Bool false));
  ("query_stats", (Bool false));
  ("record_hints", (Bool false));
  ("reuse_hint_for", Unset);
  ("silent", (Bool false));
  ("smt", Unset);
  ("smtencoding.elim_box", (Bool false));
  ("smtencoding.nl_arith_repr", (String "boxwrap"));
  ("smtencoding.l_arith_repr", (String "boxwrap"));
  ("tactics_failhard", (Bool false));
  ("tactics_info", (Bool false));
  ("tactic_raw_binders", (Bool false));
  ("tactic_trace", (Bool false));
  ("tactic_trace_d", (Int (Prims.parse_int "0")));
  ("tcnorm", (Bool true));
  ("timing", (Bool false));
  ("trace_error", (Bool false));
  ("ugly", (Bool false));
  ("unthrottle_inductives", (Bool false));
  ("unsafe_tactic_exec", (Bool false));
  ("use_native_tactics", Unset);
  ("use_eq_at_higher_order", (Bool false));
  ("use_hints", (Bool false));
  ("use_hint_hashes", (Bool false));
  ("using_facts_from", Unset);
  ("vcgen.optimize_bind_as_seq", Unset);
  ("verify_module", (List []));
  ("warn_default_effects", (Bool false));
  ("z3refresh", (Bool false));
  ("z3rlimit", (Int (Prims.parse_int "5")));
  ("z3rlimit_factor", (Int (Prims.parse_int "1")));
  ("z3seed", (Int (Prims.parse_int "0")));
  ("z3cliopt", (List []));
  ("use_two_phase_tc", (Bool true));
  ("__no_positivity", (Bool false));
  ("__ml_no_eta_expand_coertions", (Bool false));
  ("__tactics_nbe", (Bool false));
  ("warn_error", (String ""));
  ("use_extracted_interfaces", (Bool false));
  ("use_nbe", (Bool false))] 
let (init : unit -> unit) =
  fun uu____2202  ->
    let o = peek ()  in
    FStar_Util.smap_clear o;
    FStar_All.pipe_right defaults (FStar_List.iter set_option')
  
let (clear : unit -> unit) =
  fun uu____2222  ->
    let o = FStar_Util.smap_create (Prims.parse_int "50")  in
    FStar_ST.op_Colon_Equals fstar_options [[o]];
    FStar_ST.op_Colon_Equals light_off_files [];
    init ()
  
let (_run : unit) = clear () 
let (get_option : Prims.string -> option_val) =
  fun s  ->
    let uu____2295 =
      let uu____2298 = peek ()  in FStar_Util.smap_try_find uu____2298 s  in
    match uu____2295 with
    | FStar_Pervasives_Native.None  ->
        failwith
          (Prims.strcat "Impossible: option " (Prims.strcat s " not found"))
    | FStar_Pervasives_Native.Some s1 -> s1
  
let lookup_opt :
  'Auu____2311 . Prims.string -> (option_val -> 'Auu____2311) -> 'Auu____2311
  = fun s  -> fun c  -> let uu____2329 = get_option s  in c uu____2329 
let (get_abort_on : unit -> Prims.int) =
  fun uu____2336  -> lookup_opt "abort_on" as_int 
let (get_admit_smt_queries : unit -> Prims.bool) =
  fun uu____2345  -> lookup_opt "admit_smt_queries" as_bool 
let (get_admit_except : unit -> Prims.string FStar_Pervasives_Native.option)
  = fun uu____2356  -> lookup_opt "admit_except" (as_option as_string) 
let (get_already_cached :
  unit -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun uu____2372  ->
    lookup_opt "already_cached" (as_option (as_list as_string))
  
let (get_cache_checked_modules : unit -> Prims.bool) =
  fun uu____2389  -> lookup_opt "cache_checked_modules" as_bool 
let (get_cache_dir : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2400  -> lookup_opt "cache_dir" (as_option as_string) 
let (get_cache_off : unit -> Prims.bool) =
  fun uu____2412  -> lookup_opt "cache_off" as_bool 
let (get_cmi : unit -> Prims.bool) =
  fun uu____2421  -> lookup_opt "cmi" as_bool 
let (get_codegen : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2432  -> lookup_opt "codegen" (as_option as_string) 
let (get_codegen_lib : unit -> Prims.string Prims.list) =
  fun uu____2446  -> lookup_opt "codegen-lib" (as_list as_string) 
let (get_debug : unit -> Prims.string Prims.list) =
  fun uu____2460  -> lookup_opt "debug" (as_list as_string) 
let (get_debug_level : unit -> Prims.string Prims.list) =
  fun uu____2474  -> lookup_opt "debug_level" as_comma_string_list 
let (get_defensive : unit -> Prims.string) =
  fun uu____2485  -> lookup_opt "defensive" as_string 
let (get_dep : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2496  -> lookup_opt "dep" (as_option as_string) 
let (get_detail_errors : unit -> Prims.bool) =
  fun uu____2508  -> lookup_opt "detail_errors" as_bool 
let (get_detail_hint_replay : unit -> Prims.bool) =
  fun uu____2517  -> lookup_opt "detail_hint_replay" as_bool 
let (get_doc : unit -> Prims.bool) =
  fun uu____2526  -> lookup_opt "doc" as_bool 
let (get_dump_module : unit -> Prims.string Prims.list) =
  fun uu____2537  -> lookup_opt "dump_module" (as_list as_string) 
let (get_eager_subtyping : unit -> Prims.bool) =
  fun uu____2549  -> lookup_opt "eager_subtyping" as_bool 
let (get_expose_interfaces : unit -> Prims.bool) =
  fun uu____2558  -> lookup_opt "expose_interfaces" as_bool 
let (get_extract :
  unit -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun uu____2571  -> lookup_opt "extract" (as_option (as_list as_string)) 
let (get_extract_module : unit -> Prims.string Prims.list) =
  fun uu____2590  -> lookup_opt "extract_module" (as_list as_string) 
let (get_extract_namespace : unit -> Prims.string Prims.list) =
  fun uu____2604  -> lookup_opt "extract_namespace" (as_list as_string) 
let (get_fs_typ_app : unit -> Prims.bool) =
  fun uu____2616  -> lookup_opt "fs_typ_app" as_bool 
let (get_hide_uvar_nums : unit -> Prims.bool) =
  fun uu____2625  -> lookup_opt "hide_uvar_nums" as_bool 
let (get_hint_info : unit -> Prims.bool) =
  fun uu____2634  -> lookup_opt "hint_info" as_bool 
let (get_hint_file : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2645  -> lookup_opt "hint_file" (as_option as_string) 
let (get_in : unit -> Prims.bool) =
  fun uu____2657  -> lookup_opt "in" as_bool 
let (get_ide : unit -> Prims.bool) =
  fun uu____2666  -> lookup_opt "ide" as_bool 
let (get_include : unit -> Prims.string Prims.list) =
  fun uu____2677  -> lookup_opt "include" (as_list as_string) 
let (get_print : unit -> Prims.bool) =
  fun uu____2689  -> lookup_opt "print" as_bool 
let (get_print_in_place : unit -> Prims.bool) =
  fun uu____2698  -> lookup_opt "print_in_place" as_bool 
let (get_profile : unit -> Prims.bool) =
  fun uu____2707  -> lookup_opt "profile" as_bool 
let (get_protect_top_level_axioms : unit -> Prims.bool) =
  fun uu____2716  -> lookup_opt "protect_top_level_axioms" as_bool 
let (get_initial_fuel : unit -> Prims.int) =
  fun uu____2725  -> lookup_opt "initial_fuel" as_int 
let (get_initial_ifuel : unit -> Prims.int) =
  fun uu____2734  -> lookup_opt "initial_ifuel" as_int 
let (get_keep_query_captions : unit -> Prims.bool) =
  fun uu____2743  -> lookup_opt "keep_query_captions" as_bool 
let (get_lax : unit -> Prims.bool) =
  fun uu____2752  -> lookup_opt "lax" as_bool 
let (get_load : unit -> Prims.string Prims.list) =
  fun uu____2763  -> lookup_opt "load" (as_list as_string) 
let (get_log_queries : unit -> Prims.bool) =
  fun uu____2775  -> lookup_opt "log_queries" as_bool 
let (get_log_types : unit -> Prims.bool) =
  fun uu____2784  -> lookup_opt "log_types" as_bool 
let (get_max_fuel : unit -> Prims.int) =
  fun uu____2793  -> lookup_opt "max_fuel" as_int 
let (get_max_ifuel : unit -> Prims.int) =
  fun uu____2802  -> lookup_opt "max_ifuel" as_int 
let (get_min_fuel : unit -> Prims.int) =
  fun uu____2811  -> lookup_opt "min_fuel" as_int 
let (get_MLish : unit -> Prims.bool) =
  fun uu____2820  -> lookup_opt "MLish" as_bool 
let (get_n_cores : unit -> Prims.int) =
  fun uu____2829  -> lookup_opt "n_cores" as_int 
let (get_no_default_includes : unit -> Prims.bool) =
  fun uu____2838  -> lookup_opt "no_default_includes" as_bool 
let (get_no_extract : unit -> Prims.string Prims.list) =
  fun uu____2849  -> lookup_opt "no_extract" (as_list as_string) 
let (get_no_location_info : unit -> Prims.bool) =
  fun uu____2861  -> lookup_opt "no_location_info" as_bool 
let (get_no_plugins : unit -> Prims.bool) =
  fun uu____2870  -> lookup_opt "no_plugins" as_bool 
let (get_no_smt : unit -> Prims.bool) =
  fun uu____2879  -> lookup_opt "no_smt" as_bool 
let (get_normalize_pure_terms_for_extraction : unit -> Prims.bool) =
  fun uu____2888  -> lookup_opt "normalize_pure_terms_for_extraction" as_bool 
let (get_odir : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2899  -> lookup_opt "odir" (as_option as_string) 
let (get_ugly : unit -> Prims.bool) =
  fun uu____2911  -> lookup_opt "ugly" as_bool 
let (get_prims : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2922  -> lookup_opt "prims" (as_option as_string) 
let (get_print_bound_var_types : unit -> Prims.bool) =
  fun uu____2934  -> lookup_opt "print_bound_var_types" as_bool 
let (get_print_effect_args : unit -> Prims.bool) =
  fun uu____2943  -> lookup_opt "print_effect_args" as_bool 
let (get_print_full_names : unit -> Prims.bool) =
  fun uu____2952  -> lookup_opt "print_full_names" as_bool 
let (get_print_implicits : unit -> Prims.bool) =
  fun uu____2961  -> lookup_opt "print_implicits" as_bool 
let (get_print_universes : unit -> Prims.bool) =
  fun uu____2970  -> lookup_opt "print_universes" as_bool 
let (get_print_z3_statistics : unit -> Prims.bool) =
  fun uu____2979  -> lookup_opt "print_z3_statistics" as_bool 
let (get_prn : unit -> Prims.bool) =
  fun uu____2988  -> lookup_opt "prn" as_bool 
let (get_query_stats : unit -> Prims.bool) =
  fun uu____2997  -> lookup_opt "query_stats" as_bool 
let (get_record_hints : unit -> Prims.bool) =
  fun uu____3006  -> lookup_opt "record_hints" as_bool 
let (get_reuse_hint_for :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3017  -> lookup_opt "reuse_hint_for" (as_option as_string) 
let (get_silent : unit -> Prims.bool) =
  fun uu____3029  -> lookup_opt "silent" as_bool 
let (get_smt : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3040  -> lookup_opt "smt" (as_option as_string) 
let (get_smtencoding_elim_box : unit -> Prims.bool) =
  fun uu____3052  -> lookup_opt "smtencoding.elim_box" as_bool 
let (get_smtencoding_nl_arith_repr : unit -> Prims.string) =
  fun uu____3061  -> lookup_opt "smtencoding.nl_arith_repr" as_string 
let (get_smtencoding_l_arith_repr : unit -> Prims.string) =
  fun uu____3070  -> lookup_opt "smtencoding.l_arith_repr" as_string 
let (get_tactic_raw_binders : unit -> Prims.bool) =
  fun uu____3079  -> lookup_opt "tactic_raw_binders" as_bool 
let (get_tactics_failhard : unit -> Prims.bool) =
  fun uu____3088  -> lookup_opt "tactics_failhard" as_bool 
let (get_tactics_info : unit -> Prims.bool) =
  fun uu____3097  -> lookup_opt "tactics_info" as_bool 
let (get_tactic_trace : unit -> Prims.bool) =
  fun uu____3106  -> lookup_opt "tactic_trace" as_bool 
let (get_tactic_trace_d : unit -> Prims.int) =
  fun uu____3115  -> lookup_opt "tactic_trace_d" as_int 
let (get_tactics_nbe : unit -> Prims.bool) =
  fun uu____3124  -> lookup_opt "__tactics_nbe" as_bool 
let (get_tcnorm : unit -> Prims.bool) =
  fun uu____3133  -> lookup_opt "tcnorm" as_bool 
let (get_timing : unit -> Prims.bool) =
  fun uu____3142  -> lookup_opt "timing" as_bool 
let (get_trace_error : unit -> Prims.bool) =
  fun uu____3151  -> lookup_opt "trace_error" as_bool 
let (get_unthrottle_inductives : unit -> Prims.bool) =
  fun uu____3160  -> lookup_opt "unthrottle_inductives" as_bool 
let (get_unsafe_tactic_exec : unit -> Prims.bool) =
  fun uu____3169  -> lookup_opt "unsafe_tactic_exec" as_bool 
let (get_use_eq_at_higher_order : unit -> Prims.bool) =
  fun uu____3178  -> lookup_opt "use_eq_at_higher_order" as_bool 
let (get_use_hints : unit -> Prims.bool) =
  fun uu____3187  -> lookup_opt "use_hints" as_bool 
let (get_use_hint_hashes : unit -> Prims.bool) =
  fun uu____3196  -> lookup_opt "use_hint_hashes" as_bool 
let (get_use_native_tactics :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3207  -> lookup_opt "use_native_tactics" (as_option as_string) 
let (get_use_tactics : unit -> Prims.bool) =
  fun uu____3219  ->
    let uu____3220 = lookup_opt "no_tactics" as_bool  in
    Prims.op_Negation uu____3220
  
let (get_using_facts_from :
  unit -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun uu____3234  ->
    lookup_opt "using_facts_from" (as_option (as_list as_string))
  
let (get_vcgen_optimize_bind_as_seq :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3253  ->
    lookup_opt "vcgen.optimize_bind_as_seq" (as_option as_string)
  
let (get_verify_module : unit -> Prims.string Prims.list) =
  fun uu____3267  -> lookup_opt "verify_module" (as_list as_string) 
let (get___temp_no_proj : unit -> Prims.string Prims.list) =
  fun uu____3281  -> lookup_opt "__temp_no_proj" (as_list as_string) 
let (get_version : unit -> Prims.bool) =
  fun uu____3293  -> lookup_opt "version" as_bool 
let (get_warn_default_effects : unit -> Prims.bool) =
  fun uu____3302  -> lookup_opt "warn_default_effects" as_bool 
let (get_z3cliopt : unit -> Prims.string Prims.list) =
  fun uu____3313  -> lookup_opt "z3cliopt" (as_list as_string) 
let (get_z3refresh : unit -> Prims.bool) =
  fun uu____3325  -> lookup_opt "z3refresh" as_bool 
let (get_z3rlimit : unit -> Prims.int) =
  fun uu____3334  -> lookup_opt "z3rlimit" as_int 
let (get_z3rlimit_factor : unit -> Prims.int) =
  fun uu____3343  -> lookup_opt "z3rlimit_factor" as_int 
let (get_z3seed : unit -> Prims.int) =
  fun uu____3352  -> lookup_opt "z3seed" as_int 
let (get_use_two_phase_tc : unit -> Prims.bool) =
  fun uu____3361  -> lookup_opt "use_two_phase_tc" as_bool 
let (get_no_positivity : unit -> Prims.bool) =
  fun uu____3370  -> lookup_opt "__no_positivity" as_bool 
let (get_ml_no_eta_expand_coertions : unit -> Prims.bool) =
  fun uu____3379  -> lookup_opt "__ml_no_eta_expand_coertions" as_bool 
let (get_warn_error : unit -> Prims.string) =
  fun uu____3388  -> lookup_opt "warn_error" as_string 
let (get_use_extracted_interfaces : unit -> Prims.bool) =
  fun uu____3397  -> lookup_opt "use_extracted_interfaces" as_bool 
let (get_use_nbe : unit -> Prims.bool) =
  fun uu____3406  -> lookup_opt "use_nbe" as_bool 
let (dlevel : Prims.string -> debug_level_t) =
  fun uu___86_3415  ->
    match uu___86_3415 with
    | "Low" -> Low
    | "Medium" -> Medium
    | "High" -> High
    | "Extreme" -> Extreme
    | s -> Other s
  
let (one_debug_level_geq : debug_level_t -> debug_level_t -> Prims.bool) =
  fun l1  ->
    fun l2  ->
      match l1 with
      | Other uu____3436 -> l1 = l2
      | Low  -> l1 = l2
      | Medium  -> (l2 = Low) || (l2 = Medium)
      | High  -> ((l2 = Low) || (l2 = Medium)) || (l2 = High)
      | Extreme  ->
          (((l2 = Low) || (l2 = Medium)) || (l2 = High)) || (l2 = Extreme)
  
let (debug_level_geq : debug_level_t -> Prims.bool) =
  fun l2  ->
    let uu____3445 = get_debug_level ()  in
    FStar_All.pipe_right uu____3445
      (FStar_Util.for_some (fun l1  -> one_debug_level_geq (dlevel l1) l2))
  
let (universe_include_path_base_dirs : Prims.string Prims.list) =
  ["/ulib"; "/lib/fstar"] 
let (_version : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (_platform : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (_compiler : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (_date : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "<not set>" 
let (_commit : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (display_version : unit -> unit) =
  fun uu____3611  ->
    let uu____3612 =
      let uu____3614 = FStar_ST.op_Bang _version  in
      let uu____3637 = FStar_ST.op_Bang _platform  in
      let uu____3660 = FStar_ST.op_Bang _compiler  in
      let uu____3683 = FStar_ST.op_Bang _date  in
      let uu____3706 = FStar_ST.op_Bang _commit  in
      FStar_Util.format5
        "F* %s\nplatform=%s\ncompiler=%s\ndate=%s\ncommit=%s\n" uu____3614
        uu____3637 uu____3660 uu____3683 uu____3706
       in
    FStar_Util.print_string uu____3612
  
let display_usage_aux :
  'Auu____3737 'Auu____3738 .
    ('Auu____3737 * Prims.string * 'Auu____3738 FStar_Getopt.opt_variant *
      Prims.string) Prims.list -> unit
  =
  fun specs  ->
    FStar_Util.print_string "fstar.exe [options] file[s]\n";
    FStar_List.iter
      (fun uu____3793  ->
         match uu____3793 with
         | (uu____3806,flag,p,doc) ->
             (match p with
              | FStar_Getopt.ZeroArgs ig ->
                  if doc = ""
                  then
                    let uu____3825 =
                      let uu____3827 = FStar_Util.colorize_bold flag  in
                      FStar_Util.format1 "  --%s\n" uu____3827  in
                    FStar_Util.print_string uu____3825
                  else
                    (let uu____3832 =
                       let uu____3834 = FStar_Util.colorize_bold flag  in
                       FStar_Util.format2 "  --%s  %s\n" uu____3834 doc  in
                     FStar_Util.print_string uu____3832)
              | FStar_Getopt.OneArg (uu____3837,argname) ->
                  if doc = ""
                  then
                    let uu____3852 =
                      let uu____3854 = FStar_Util.colorize_bold flag  in
                      let uu____3856 = FStar_Util.colorize_bold argname  in
                      FStar_Util.format2 "  --%s %s\n" uu____3854 uu____3856
                       in
                    FStar_Util.print_string uu____3852
                  else
                    (let uu____3861 =
                       let uu____3863 = FStar_Util.colorize_bold flag  in
                       let uu____3865 = FStar_Util.colorize_bold argname  in
                       FStar_Util.format3 "  --%s %s  %s\n" uu____3863
                         uu____3865 doc
                        in
                     FStar_Util.print_string uu____3861))) specs
  
let (mk_spec :
  (FStar_BaseTypes.char * Prims.string * option_val FStar_Getopt.opt_variant
    * Prims.string) -> FStar_Getopt.opt)
  =
  fun o  ->
    let uu____3900 = o  in
    match uu____3900 with
    | (ns,name,arg,desc) ->
        let arg1 =
          match arg with
          | FStar_Getopt.ZeroArgs f ->
              let g uu____3942 =
                let uu____3943 = f ()  in set_option name uu____3943  in
              FStar_Getopt.ZeroArgs g
          | FStar_Getopt.OneArg (f,d) ->
              let g x = let uu____3964 = f x  in set_option name uu____3964
                 in
              FStar_Getopt.OneArg (g, d)
           in
        (ns, name, arg1, desc)
  
let (accumulated_option : Prims.string -> option_val -> option_val) =
  fun name  ->
    fun value  ->
      let prev_values =
        let uu____3991 = lookup_opt name (as_option as_list')  in
        FStar_Util.dflt [] uu____3991  in
      mk_list (value :: prev_values)
  
let (reverse_accumulated_option : Prims.string -> option_val -> option_val) =
  fun name  ->
    fun value  ->
      let prev_values =
        let uu____4020 = lookup_opt name (as_option as_list')  in
        FStar_Util.dflt [] uu____4020  in
      mk_list (FStar_List.append prev_values [value])
  
let accumulate_string :
  'Auu____4042 .
    Prims.string -> ('Auu____4042 -> Prims.string) -> 'Auu____4042 -> unit
  =
  fun name  ->
    fun post_processor  ->
      fun value  ->
        let uu____4067 =
          let uu____4068 =
            let uu____4069 = post_processor value  in mk_string uu____4069
             in
          accumulated_option name uu____4068  in
        set_option name uu____4067
  
let (add_extract_module : Prims.string -> unit) =
  fun s  -> accumulate_string "extract_module" FStar_String.lowercase s 
let (add_extract_namespace : Prims.string -> unit) =
  fun s  -> accumulate_string "extract_namespace" FStar_String.lowercase s 
let (add_verify_module : Prims.string -> unit) =
  fun s  -> accumulate_string "verify_module" FStar_String.lowercase s 
type opt_type =
  | Const of option_val 
  | IntStr of Prims.string 
  | BoolStr 
  | PathStr of Prims.string 
  | SimpleStr of Prims.string 
  | EnumStr of Prims.string Prims.list 
  | OpenEnumStr of (Prims.string Prims.list * Prims.string) 
  | PostProcessed of ((option_val -> option_val) * opt_type) 
  | Accumulated of opt_type 
  | ReverseAccumulated of opt_type 
  | WithSideEffect of ((unit -> unit) * opt_type) 
let (uu___is_Const : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | Const _0 -> true | uu____4191 -> false
  
let (__proj__Const__item___0 : opt_type -> option_val) =
  fun projectee  -> match projectee with | Const _0 -> _0 
let (uu___is_IntStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | IntStr _0 -> true | uu____4212 -> false
  
let (__proj__IntStr__item___0 : opt_type -> Prims.string) =
  fun projectee  -> match projectee with | IntStr _0 -> _0 
let (uu___is_BoolStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | BoolStr  -> true | uu____4234 -> false
  
let (uu___is_PathStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | PathStr _0 -> true | uu____4247 -> false
  
let (__proj__PathStr__item___0 : opt_type -> Prims.string) =
  fun projectee  -> match projectee with | PathStr _0 -> _0 
let (uu___is_SimpleStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | SimpleStr _0 -> true | uu____4271 -> false
  
let (__proj__SimpleStr__item___0 : opt_type -> Prims.string) =
  fun projectee  -> match projectee with | SimpleStr _0 -> _0 
let (uu___is_EnumStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | EnumStr _0 -> true | uu____4297 -> false
  
let (__proj__EnumStr__item___0 : opt_type -> Prims.string Prims.list) =
  fun projectee  -> match projectee with | EnumStr _0 -> _0 
let (uu___is_OpenEnumStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | OpenEnumStr _0 -> true | uu____4334 -> false
  
let (__proj__OpenEnumStr__item___0 :
  opt_type -> (Prims.string Prims.list * Prims.string)) =
  fun projectee  -> match projectee with | OpenEnumStr _0 -> _0 
let (uu___is_PostProcessed : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | PostProcessed _0 -> true | uu____4385 -> false
  
let (__proj__PostProcessed__item___0 :
  opt_type -> ((option_val -> option_val) * opt_type)) =
  fun projectee  -> match projectee with | PostProcessed _0 -> _0 
let (uu___is_Accumulated : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | Accumulated _0 -> true | uu____4426 -> false
  
let (__proj__Accumulated__item___0 : opt_type -> opt_type) =
  fun projectee  -> match projectee with | Accumulated _0 -> _0 
let (uu___is_ReverseAccumulated : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | ReverseAccumulated _0 -> true
    | uu____4446 -> false
  
let (__proj__ReverseAccumulated__item___0 : opt_type -> opt_type) =
  fun projectee  -> match projectee with | ReverseAccumulated _0 -> _0 
let (uu___is_WithSideEffect : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | WithSideEffect _0 -> true | uu____4473 -> false
  
let (__proj__WithSideEffect__item___0 :
  opt_type -> ((unit -> unit) * opt_type)) =
  fun projectee  -> match projectee with | WithSideEffect _0 -> _0 
exception InvalidArgument of Prims.string 
let (uu___is_InvalidArgument : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | InvalidArgument uu____4517 -> true
    | uu____4520 -> false
  
let (__proj__InvalidArgument__item__uu___ : Prims.exn -> Prims.string) =
  fun projectee  ->
    match projectee with | InvalidArgument uu____4531 -> uu____4531
  
let rec (parse_opt_val :
  Prims.string -> opt_type -> Prims.string -> option_val) =
  fun opt_name  ->
    fun typ  ->
      fun str_val  ->
        try
          (fun uu___91_4555  ->
             match () with
             | () ->
                 (match typ with
                  | Const c -> c
                  | IntStr uu____4557 ->
                      let uu____4559 = FStar_Util.safe_int_of_string str_val
                         in
                      (match uu____4559 with
                       | FStar_Pervasives_Native.Some v1 -> mk_int v1
                       | FStar_Pervasives_Native.None  ->
                           FStar_Exn.raise (InvalidArgument opt_name))
                  | BoolStr  ->
                      let uu____4567 =
                        if str_val = "true"
                        then true
                        else
                          if str_val = "false"
                          then false
                          else FStar_Exn.raise (InvalidArgument opt_name)
                         in
                      mk_bool uu____4567
                  | PathStr uu____4584 -> mk_path str_val
                  | SimpleStr uu____4586 -> mk_string str_val
                  | EnumStr strs ->
                      if FStar_List.mem str_val strs
                      then mk_string str_val
                      else FStar_Exn.raise (InvalidArgument opt_name)
                  | OpenEnumStr uu____4596 -> mk_string str_val
                  | PostProcessed (pp,elem_spec) ->
                      let uu____4613 =
                        parse_opt_val opt_name elem_spec str_val  in
                      pp uu____4613
                  | Accumulated elem_spec ->
                      let v1 = parse_opt_val opt_name elem_spec str_val  in
                      accumulated_option opt_name v1
                  | ReverseAccumulated elem_spec ->
                      let v1 = parse_opt_val opt_name elem_spec str_val  in
                      reverse_accumulated_option opt_name v1
                  | WithSideEffect (side_effect,elem_spec) ->
                      (side_effect ();
                       parse_opt_val opt_name elem_spec str_val))) ()
        with
        | InvalidArgument opt_name1 ->
            let uu____4633 =
              FStar_Util.format1 "Invalid argument to --%s" opt_name1  in
            failwith uu____4633
  
let rec (desc_of_opt_type :
  opt_type -> Prims.string FStar_Pervasives_Native.option) =
  fun typ  ->
    let desc_of_enum cases =
      FStar_Pervasives_Native.Some
        (Prims.strcat "[" (Prims.strcat (FStar_String.concat "|" cases) "]"))
       in
    match typ with
    | Const c -> FStar_Pervasives_Native.None
    | IntStr desc -> FStar_Pervasives_Native.Some desc
    | BoolStr  -> desc_of_enum ["true"; "false"]
    | PathStr desc -> FStar_Pervasives_Native.Some desc
    | SimpleStr desc -> FStar_Pervasives_Native.Some desc
    | EnumStr strs -> desc_of_enum strs
    | OpenEnumStr (strs,desc) -> desc_of_enum (FStar_List.append strs [desc])
    | PostProcessed (uu____4703,elem_spec) -> desc_of_opt_type elem_spec
    | Accumulated elem_spec -> desc_of_opt_type elem_spec
    | ReverseAccumulated elem_spec -> desc_of_opt_type elem_spec
    | WithSideEffect (uu____4713,elem_spec) -> desc_of_opt_type elem_spec
  
let rec (arg_spec_of_opt_type :
  Prims.string -> opt_type -> option_val FStar_Getopt.opt_variant) =
  fun opt_name  ->
    fun typ  ->
      let parser = parse_opt_val opt_name typ  in
      let uu____4744 = desc_of_opt_type typ  in
      match uu____4744 with
      | FStar_Pervasives_Native.None  ->
          FStar_Getopt.ZeroArgs ((fun uu____4752  -> parser ""))
      | FStar_Pervasives_Native.Some desc ->
          FStar_Getopt.OneArg (parser, desc)
  
let (pp_validate_dir : option_val -> option_val) =
  fun p  -> let pp = as_string p  in FStar_Util.mkdir false pp; p 
let (pp_lowercase : option_val -> option_val) =
  fun s  ->
    let uu____4778 =
      let uu____4780 = as_string s  in FStar_String.lowercase uu____4780  in
    mk_string uu____4778
  
let (abort_counter : Prims.int FStar_ST.ref) =
  FStar_Util.mk_ref (Prims.parse_int "0") 
let rec (specs_with_types :
  unit ->
    (FStar_BaseTypes.char * Prims.string * opt_type * Prims.string)
      Prims.list)
  =
  fun uu____4837  ->
    let uu____4851 =
      let uu____4865 =
        let uu____4879 =
          let uu____4893 =
            let uu____4907 =
              let uu____4919 =
                let uu____4920 = mk_bool true  in Const uu____4920  in
              (FStar_Getopt.noshort, "cache_checked_modules", uu____4919,
                "Write a '.checked' file for each module after verification and read from it if present, instead of re-verifying")
               in
            let uu____4927 =
              let uu____4941 =
                let uu____4955 =
                  let uu____4967 =
                    let uu____4968 = mk_bool true  in Const uu____4968  in
                  (FStar_Getopt.noshort, "cache_off", uu____4967,
                    "Do not read or write any .checked files")
                   in
                let uu____4975 =
                  let uu____4989 =
                    let uu____5001 =
                      let uu____5002 = mk_bool true  in Const uu____5002  in
                    (FStar_Getopt.noshort, "cmi", uu____5001,
                      "Inline across module interfaces during extraction (aka. cross-module inlining)")
                     in
                  let uu____5009 =
                    let uu____5023 =
                      let uu____5037 =
                        let uu____5051 =
                          let uu____5065 =
                            let uu____5079 =
                              let uu____5093 =
                                let uu____5107 =
                                  let uu____5119 =
                                    let uu____5120 = mk_bool true  in
                                    Const uu____5120  in
                                  (FStar_Getopt.noshort, "detail_errors",
                                    uu____5119,
                                    "Emit a detailed error report by asking the SMT solver many queries; will take longer;\n         implies n_cores=1")
                                   in
                                let uu____5127 =
                                  let uu____5141 =
                                    let uu____5153 =
                                      let uu____5154 = mk_bool true  in
                                      Const uu____5154  in
                                    (FStar_Getopt.noshort,
                                      "detail_hint_replay", uu____5153,
                                      "Emit a detailed report for proof whose unsat core fails to replay;\n         implies n_cores=1")
                                     in
                                  let uu____5161 =
                                    let uu____5175 =
                                      let uu____5187 =
                                        let uu____5188 = mk_bool true  in
                                        Const uu____5188  in
                                      (FStar_Getopt.noshort, "doc",
                                        uu____5187,
                                        "Extract Markdown documentation files for the input modules, as well as an index. Output is written to --odir directory.")
                                       in
                                    let uu____5195 =
                                      let uu____5209 =
                                        let uu____5223 =
                                          let uu____5235 =
                                            let uu____5236 = mk_bool true  in
                                            Const uu____5236  in
                                          (FStar_Getopt.noshort,
                                            "eager_inference", uu____5235,
                                            "Deprecated: Solve all type-inference constraints eagerly; more efficient but at the cost of generality")
                                           in
                                        let uu____5243 =
                                          let uu____5257 =
                                            let uu____5269 =
                                              let uu____5270 = mk_bool true
                                                 in
                                              Const uu____5270  in
                                            (FStar_Getopt.noshort,
                                              "eager_subtyping", uu____5269,
                                              "Try to solve subtyping constraints at each binder (loses precision but may be slightly more efficient)")
                                             in
                                          let uu____5277 =
                                            let uu____5291 =
                                              let uu____5305 =
                                                let uu____5319 =
                                                  let uu____5333 =
                                                    let uu____5345 =
                                                      let uu____5346 =
                                                        mk_bool true  in
                                                      Const uu____5346  in
                                                    (FStar_Getopt.noshort,
                                                      "expose_interfaces",
                                                      uu____5345,
                                                      "Explicitly break the abstraction imposed by the interface of any implementation file that appears on the command line (use with care!)")
                                                     in
                                                  let uu____5353 =
                                                    let uu____5367 =
                                                      let uu____5379 =
                                                        let uu____5380 =
                                                          mk_bool true  in
                                                        Const uu____5380  in
                                                      (FStar_Getopt.noshort,
                                                        "hide_uvar_nums",
                                                        uu____5379,
                                                        "Don't print unification variable numbers")
                                                       in
                                                    let uu____5387 =
                                                      let uu____5401 =
                                                        let uu____5415 =
                                                          let uu____5427 =
                                                            let uu____5428 =
                                                              mk_bool true
                                                               in
                                                            Const uu____5428
                                                             in
                                                          (FStar_Getopt.noshort,
                                                            "hint_info",
                                                            uu____5427,
                                                            "Print information regarding hints (deprecated; use --query_stats instead)")
                                                           in
                                                        let uu____5435 =
                                                          let uu____5449 =
                                                            let uu____5461 =
                                                              let uu____5462
                                                                =
                                                                mk_bool true
                                                                 in
                                                              Const
                                                                uu____5462
                                                               in
                                                            (FStar_Getopt.noshort,
                                                              "in",
                                                              uu____5461,
                                                              "Legacy interactive mode; reads input from stdin")
                                                             in
                                                          let uu____5469 =
                                                            let uu____5483 =
                                                              let uu____5495
                                                                =
                                                                let uu____5496
                                                                  =
                                                                  mk_bool
                                                                    true
                                                                   in
                                                                Const
                                                                  uu____5496
                                                                 in
                                                              (FStar_Getopt.noshort,
                                                                "ide",
                                                                uu____5495,
                                                                "JSON-based interactive mode for IDEs")
                                                               in
                                                            let uu____5503 =
                                                              let uu____5517
                                                                =
                                                                let uu____5531
                                                                  =
                                                                  let uu____5543
                                                                    =
                                                                    let uu____5544
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5544
                                                                     in
                                                                  (FStar_Getopt.noshort,
                                                                    "print",
                                                                    uu____5543,
                                                                    "Parses and prettyprints the files included on the command line")
                                                                   in
                                                                let uu____5551
                                                                  =
                                                                  let uu____5565
                                                                    =
                                                                    let uu____5577
                                                                    =
                                                                    let uu____5578
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5578
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_in_place",
                                                                    uu____5577,
                                                                    "Parses and prettyprints in place the files included on the command line")
                                                                     in
                                                                  let uu____5585
                                                                    =
                                                                    let uu____5599
                                                                    =
                                                                    let uu____5611
                                                                    =
                                                                    let uu____5612
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5612
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "profile",
                                                                    uu____5611,
                                                                    "Prints timing information for various operations in the compiler")
                                                                     in
                                                                    let uu____5619
                                                                    =
                                                                    let uu____5633
                                                                    =
                                                                    let uu____5647
                                                                    =
                                                                    let uu____5661
                                                                    =
                                                                    let uu____5675
                                                                    =
                                                                    let uu____5689
                                                                    =
                                                                    let uu____5701
                                                                    =
                                                                    let uu____5702
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5702
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "lax",
                                                                    uu____5701,
                                                                    "Run the lax-type checker only (admit all verification conditions)")
                                                                     in
                                                                    let uu____5709
                                                                    =
                                                                    let uu____5723
                                                                    =
                                                                    let uu____5737
                                                                    =
                                                                    let uu____5749
                                                                    =
                                                                    let uu____5750
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5750
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "log_types",
                                                                    uu____5749,
                                                                    "Print types computed for data/val/let-bindings")
                                                                     in
                                                                    let uu____5757
                                                                    =
                                                                    let uu____5771
                                                                    =
                                                                    let uu____5783
                                                                    =
                                                                    let uu____5784
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5784
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "log_queries",
                                                                    uu____5783,
                                                                    "Log the Z3 queries in several queries-*.smt2 files, as we go")
                                                                     in
                                                                    let uu____5791
                                                                    =
                                                                    let uu____5805
                                                                    =
                                                                    let uu____5819
                                                                    =
                                                                    let uu____5833
                                                                    =
                                                                    let uu____5847
                                                                    =
                                                                    let uu____5859
                                                                    =
                                                                    let uu____5860
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5860
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "MLish",
                                                                    uu____5859,
                                                                    "Trigger various specializations for compiling the F* compiler itself (not meant for user code)")
                                                                     in
                                                                    let uu____5867
                                                                    =
                                                                    let uu____5881
                                                                    =
                                                                    let uu____5895
                                                                    =
                                                                    let uu____5907
                                                                    =
                                                                    let uu____5908
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5908
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_default_includes",
                                                                    uu____5907,
                                                                    "Ignore the default module search paths")
                                                                     in
                                                                    let uu____5915
                                                                    =
                                                                    let uu____5929
                                                                    =
                                                                    let uu____5943
                                                                    =
                                                                    let uu____5955
                                                                    =
                                                                    let uu____5956
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5956
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_location_info",
                                                                    uu____5955,
                                                                    "Suppress location information in the generated OCaml output (only relevant with --codegen OCaml)")
                                                                     in
                                                                    let uu____5963
                                                                    =
                                                                    let uu____5977
                                                                    =
                                                                    let uu____5989
                                                                    =
                                                                    let uu____5990
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5990
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_smt",
                                                                    uu____5989,
                                                                    "Do not send any queries to the SMT solver, and fail on them instead")
                                                                     in
                                                                    let uu____5997
                                                                    =
                                                                    let uu____6011
                                                                    =
                                                                    let uu____6023
                                                                    =
                                                                    let uu____6024
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6024
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "normalize_pure_terms_for_extraction",
                                                                    uu____6023,
                                                                    "Extract top-level pure terms after normalizing them. This can lead to very large code, but can result in more partial evaluation and compile-time specialization.")
                                                                     in
                                                                    let uu____6031
                                                                    =
                                                                    let uu____6045
                                                                    =
                                                                    let uu____6059
                                                                    =
                                                                    let uu____6073
                                                                    =
                                                                    let uu____6085
                                                                    =
                                                                    let uu____6086
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6086
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_bound_var_types",
                                                                    uu____6085,
                                                                    "Print the types of bound variables")
                                                                     in
                                                                    let uu____6093
                                                                    =
                                                                    let uu____6107
                                                                    =
                                                                    let uu____6119
                                                                    =
                                                                    let uu____6120
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6120
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_effect_args",
                                                                    uu____6119,
                                                                    "Print inferred predicate transformers for all computation types")
                                                                     in
                                                                    let uu____6127
                                                                    =
                                                                    let uu____6141
                                                                    =
                                                                    let uu____6153
                                                                    =
                                                                    let uu____6154
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6154
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_full_names",
                                                                    uu____6153,
                                                                    "Print full names of variables")
                                                                     in
                                                                    let uu____6161
                                                                    =
                                                                    let uu____6175
                                                                    =
                                                                    let uu____6187
                                                                    =
                                                                    let uu____6188
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6188
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_implicits",
                                                                    uu____6187,
                                                                    "Print implicit arguments")
                                                                     in
                                                                    let uu____6195
                                                                    =
                                                                    let uu____6209
                                                                    =
                                                                    let uu____6221
                                                                    =
                                                                    let uu____6222
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6222
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_universes",
                                                                    uu____6221,
                                                                    "Print universes")
                                                                     in
                                                                    let uu____6229
                                                                    =
                                                                    let uu____6243
                                                                    =
                                                                    let uu____6255
                                                                    =
                                                                    let uu____6256
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6256
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_z3_statistics",
                                                                    uu____6255,
                                                                    "Print Z3 statistics for each SMT query (details such as relevant modules, facts, etc. for each proof)")
                                                                     in
                                                                    let uu____6263
                                                                    =
                                                                    let uu____6277
                                                                    =
                                                                    let uu____6289
                                                                    =
                                                                    let uu____6290
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6290
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "prn",
                                                                    uu____6289,
                                                                    "Print full names (deprecated; use --print_full_names instead)")
                                                                     in
                                                                    let uu____6297
                                                                    =
                                                                    let uu____6311
                                                                    =
                                                                    let uu____6323
                                                                    =
                                                                    let uu____6324
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6324
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "query_stats",
                                                                    uu____6323,
                                                                    "Print SMT query statistics")
                                                                     in
                                                                    let uu____6331
                                                                    =
                                                                    let uu____6345
                                                                    =
                                                                    let uu____6357
                                                                    =
                                                                    let uu____6358
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6358
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "record_hints",
                                                                    uu____6357,
                                                                    "Record a database of hints for efficient proof replay")
                                                                     in
                                                                    let uu____6365
                                                                    =
                                                                    let uu____6379
                                                                    =
                                                                    let uu____6393
                                                                    =
                                                                    let uu____6405
                                                                    =
                                                                    let uu____6406
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6406
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "silent",
                                                                    uu____6405,
                                                                    "Disable all non-critical output")
                                                                     in
                                                                    let uu____6413
                                                                    =
                                                                    let uu____6427
                                                                    =
                                                                    let uu____6441
                                                                    =
                                                                    let uu____6455
                                                                    =
                                                                    let uu____6469
                                                                    =
                                                                    let uu____6483
                                                                    =
                                                                    let uu____6495
                                                                    =
                                                                    let uu____6496
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6496
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactic_raw_binders",
                                                                    uu____6495,
                                                                    "Do not use the lexical scope of tactics to improve binder names")
                                                                     in
                                                                    let uu____6503
                                                                    =
                                                                    let uu____6517
                                                                    =
                                                                    let uu____6529
                                                                    =
                                                                    let uu____6530
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6530
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactics_failhard",
                                                                    uu____6529,
                                                                    "Do not recover from metaprogramming errors, and abort if one occurs")
                                                                     in
                                                                    let uu____6537
                                                                    =
                                                                    let uu____6551
                                                                    =
                                                                    let uu____6563
                                                                    =
                                                                    let uu____6564
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6564
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactics_info",
                                                                    uu____6563,
                                                                    "Print some rough information on tactics, such as the time they take to run")
                                                                     in
                                                                    let uu____6571
                                                                    =
                                                                    let uu____6585
                                                                    =
                                                                    let uu____6597
                                                                    =
                                                                    let uu____6598
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6598
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactic_trace",
                                                                    uu____6597,
                                                                    "Print a depth-indexed trace of tactic execution (Warning: very verbose)")
                                                                     in
                                                                    let uu____6605
                                                                    =
                                                                    let uu____6619
                                                                    =
                                                                    let uu____6633
                                                                    =
                                                                    let uu____6645
                                                                    =
                                                                    let uu____6646
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6646
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__tactics_nbe",
                                                                    uu____6645,
                                                                    "Use NBE to evaluate metaprograms (experimental)")
                                                                     in
                                                                    let uu____6653
                                                                    =
                                                                    let uu____6667
                                                                    =
                                                                    let uu____6681
                                                                    =
                                                                    let uu____6693
                                                                    =
                                                                    let uu____6694
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6694
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "timing",
                                                                    uu____6693,
                                                                    "Print the time it takes to verify each top-level definition")
                                                                     in
                                                                    let uu____6701
                                                                    =
                                                                    let uu____6715
                                                                    =
                                                                    let uu____6727
                                                                    =
                                                                    let uu____6728
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6728
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "trace_error",
                                                                    uu____6727,
                                                                    "Don't print an error message; show an exception trace instead")
                                                                     in
                                                                    let uu____6735
                                                                    =
                                                                    let uu____6749
                                                                    =
                                                                    let uu____6761
                                                                    =
                                                                    let uu____6762
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6762
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "ugly",
                                                                    uu____6761,
                                                                    "Emit output formatted for debugging")
                                                                     in
                                                                    let uu____6769
                                                                    =
                                                                    let uu____6783
                                                                    =
                                                                    let uu____6795
                                                                    =
                                                                    let uu____6796
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6796
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "unthrottle_inductives",
                                                                    uu____6795,
                                                                    "Let the SMT solver unfold inductive types to arbitrary depths (may affect verifier performance)")
                                                                     in
                                                                    let uu____6803
                                                                    =
                                                                    let uu____6817
                                                                    =
                                                                    let uu____6829
                                                                    =
                                                                    let uu____6830
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6830
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "unsafe_tactic_exec",
                                                                    uu____6829,
                                                                    "Allow tactics to run external processes. WARNING: checking an untrusted F* file while using this option can have disastrous effects.")
                                                                     in
                                                                    let uu____6837
                                                                    =
                                                                    let uu____6851
                                                                    =
                                                                    let uu____6863
                                                                    =
                                                                    let uu____6864
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6864
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_eq_at_higher_order",
                                                                    uu____6863,
                                                                    "Use equality constraints when comparing higher-order types (Temporary)")
                                                                     in
                                                                    let uu____6871
                                                                    =
                                                                    let uu____6885
                                                                    =
                                                                    let uu____6897
                                                                    =
                                                                    let uu____6898
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6898
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_hints",
                                                                    uu____6897,
                                                                    "Use a previously recorded hints database for proof replay")
                                                                     in
                                                                    let uu____6905
                                                                    =
                                                                    let uu____6919
                                                                    =
                                                                    let uu____6931
                                                                    =
                                                                    let uu____6932
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6932
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_hint_hashes",
                                                                    uu____6931,
                                                                    "Admit queries if their hash matches the hash recorded in the hints database")
                                                                     in
                                                                    let uu____6939
                                                                    =
                                                                    let uu____6953
                                                                    =
                                                                    let uu____6967
                                                                    =
                                                                    let uu____6979
                                                                    =
                                                                    let uu____6980
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6980
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_plugins",
                                                                    uu____6979,
                                                                    "Do not run plugins natively and interpret them as usual instead")
                                                                     in
                                                                    let uu____6987
                                                                    =
                                                                    let uu____7001
                                                                    =
                                                                    let uu____7013
                                                                    =
                                                                    let uu____7014
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7014
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_tactics",
                                                                    uu____7013,
                                                                    "Do not run the tactic engine before discharging a VC")
                                                                     in
                                                                    let uu____7021
                                                                    =
                                                                    let uu____7035
                                                                    =
                                                                    let uu____7049
                                                                    =
                                                                    let uu____7063
                                                                    =
                                                                    let uu____7077
                                                                    =
                                                                    let uu____7089
                                                                    =
                                                                    let uu____7090
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7090
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__temp_fast_implicits",
                                                                    uu____7089,
                                                                    "Don't use this option yet")
                                                                     in
                                                                    let uu____7097
                                                                    =
                                                                    let uu____7111
                                                                    =
                                                                    let uu____7123
                                                                    =
                                                                    let uu____7124
                                                                    =
                                                                    let uu____7132
                                                                    =
                                                                    let uu____7133
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7133
                                                                     in
                                                                    ((fun
                                                                    uu____7140
                                                                     ->
                                                                    display_version
                                                                    ();
                                                                    FStar_All.exit
                                                                    (Prims.parse_int "0")),
                                                                    uu____7132)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7124
                                                                     in
                                                                    (118,
                                                                    "version",
                                                                    uu____7123,
                                                                    "Display version number")
                                                                     in
                                                                    let uu____7149
                                                                    =
                                                                    let uu____7163
                                                                    =
                                                                    let uu____7175
                                                                    =
                                                                    let uu____7176
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7176
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "warn_default_effects",
                                                                    uu____7175,
                                                                    "Warn when (a -> b) is desugared to (a -> Tot b)")
                                                                     in
                                                                    let uu____7183
                                                                    =
                                                                    let uu____7197
                                                                    =
                                                                    let uu____7211
                                                                    =
                                                                    let uu____7223
                                                                    =
                                                                    let uu____7224
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7224
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3refresh",
                                                                    uu____7223,
                                                                    "Restart Z3 after each query; useful for ensuring proof robustness")
                                                                     in
                                                                    let uu____7231
                                                                    =
                                                                    let uu____7245
                                                                    =
                                                                    let uu____7259
                                                                    =
                                                                    let uu____7273
                                                                    =
                                                                    let uu____7287
                                                                    =
                                                                    let uu____7301
                                                                    =
                                                                    let uu____7313
                                                                    =
                                                                    let uu____7314
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7314
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__no_positivity",
                                                                    uu____7313,
                                                                    "Don't check positivity of inductive types")
                                                                     in
                                                                    let uu____7321
                                                                    =
                                                                    let uu____7335
                                                                    =
                                                                    let uu____7347
                                                                    =
                                                                    let uu____7348
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7348
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__ml_no_eta_expand_coertions",
                                                                    uu____7347,
                                                                    "Do not eta-expand coertions in generated OCaml")
                                                                     in
                                                                    let uu____7355
                                                                    =
                                                                    let uu____7369
                                                                    =
                                                                    let uu____7383
                                                                    =
                                                                    let uu____7397
                                                                    =
                                                                    let uu____7411
                                                                    =
                                                                    let uu____7423
                                                                    =
                                                                    let uu____7424
                                                                    =
                                                                    let uu____7432
                                                                    =
                                                                    let uu____7433
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7433
                                                                     in
                                                                    ((fun
                                                                    uu____7439
                                                                     ->
                                                                    FStar_ST.op_Colon_Equals
                                                                    debug_embedding
                                                                    true),
                                                                    uu____7432)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7424
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__debug_embedding",
                                                                    uu____7423,
                                                                    "Debug messages for embeddings/unembeddings of natively compiled terms")
                                                                     in
                                                                    let uu____7467
                                                                    =
                                                                    let uu____7481
                                                                    =
                                                                    let uu____7493
                                                                    =
                                                                    let uu____7494
                                                                    =
                                                                    let uu____7502
                                                                    =
                                                                    let uu____7503
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7503
                                                                     in
                                                                    ((fun
                                                                    uu____7509
                                                                     ->
                                                                    FStar_ST.op_Colon_Equals
                                                                    eager_embedding
                                                                    true),
                                                                    uu____7502)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7494
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "eager_embedding",
                                                                    uu____7493,
                                                                    "Eagerly embed and unembed terms to primitive operations and plugins: not recommended except for benchmarking")
                                                                     in
                                                                    let uu____7537
                                                                    =
                                                                    let uu____7551
                                                                    =
                                                                    let uu____7563
                                                                    =
                                                                    let uu____7564
                                                                    =
                                                                    let uu____7572
                                                                    =
                                                                    let uu____7573
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7573
                                                                     in
                                                                    ((fun
                                                                    uu____7580
                                                                     ->
                                                                    (
                                                                    let uu____7582
                                                                    =
                                                                    specs ()
                                                                     in
                                                                    display_usage_aux
                                                                    uu____7582);
                                                                    FStar_All.exit
                                                                    (Prims.parse_int "0")),
                                                                    uu____7572)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7564
                                                                     in
                                                                    (104,
                                                                    "help",
                                                                    uu____7563,
                                                                    "Display this information")
                                                                     in
                                                                    [uu____7551]
                                                                     in
                                                                    uu____7481
                                                                    ::
                                                                    uu____7537
                                                                     in
                                                                    uu____7411
                                                                    ::
                                                                    uu____7467
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_nbe",
                                                                    BoolStr,
                                                                    "Use normalization by evaluation as the default normalization srategy (default 'false')")
                                                                    ::
                                                                    uu____7397
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_extracted_interfaces",
                                                                    BoolStr,
                                                                    "Extract interfaces from the dependencies and use them for verification (default 'false')")
                                                                    ::
                                                                    uu____7383
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "warn_error",
                                                                    (SimpleStr
                                                                    ""),
                                                                    "The [-warn_error] option follows the OCaml syntax, namely:\n\t\t- [r] is a range of warnings (either a number [n], or a range [n..n])\n\t\t- [-r] silences range [r]\n\t\t- [+r] enables range [r]\n\t\t- [@r] makes range [r] fatal.")
                                                                    ::
                                                                    uu____7369
                                                                     in
                                                                    uu____7335
                                                                    ::
                                                                    uu____7355
                                                                     in
                                                                    uu____7301
                                                                    ::
                                                                    uu____7321
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_two_phase_tc",
                                                                    BoolStr,
                                                                    "Use the two phase typechecker (default 'true')")
                                                                    ::
                                                                    uu____7287
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3seed",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Set the Z3 random seed (default 0)")
                                                                    ::
                                                                    uu____7273
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3rlimit_factor",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Set the Z3 per-query resource limit multiplier. This is useful when, say, regenerating hints and you want to be more lax. (default 1)")
                                                                    ::
                                                                    uu____7259
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3rlimit",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Set the Z3 per-query resource limit (default 5 units, taking roughtly 5s)")
                                                                    ::
                                                                    uu____7245
                                                                     in
                                                                    uu____7211
                                                                    ::
                                                                    uu____7231
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3cliopt",
                                                                    (ReverseAccumulated
                                                                    (SimpleStr
                                                                    "option")),
                                                                    "Z3 command line options")
                                                                    ::
                                                                    uu____7197
                                                                     in
                                                                    uu____7163
                                                                    ::
                                                                    uu____7183
                                                                     in
                                                                    uu____7111
                                                                    ::
                                                                    uu____7149
                                                                     in
                                                                    uu____7077
                                                                    ::
                                                                    uu____7097
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__temp_no_proj",
                                                                    (Accumulated
                                                                    (SimpleStr
                                                                    "module_name")),
                                                                    "Don't generate projectors for this module")
                                                                    ::
                                                                    uu____7063
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "vcgen.optimize_bind_as_seq",
                                                                    (EnumStr
                                                                    ["off";
                                                                    "without_type";
                                                                    "with_type"]),
                                                                    "\n\t\tOptimize the generation of verification conditions, \n\t\t\tspecifically the construction of monadic `bind`,\n\t\t\tgenerating `seq` instead of `bind` when the first computation as a trivial post-condition.\n\t\t\tBy default, this optimization does not apply.\n\t\t\tWhen the `without_type` option is chosen, this imposes a cost on the SMT solver\n\t\t\tto reconstruct type information.\n\t\t\tWhen `with_type` is chosen, type information is provided to the SMT solver,\n\t\t\tbut at the cost of VC bloat, which may often be redundant.")
                                                                    ::
                                                                    uu____7049
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "using_facts_from",
                                                                    (ReverseAccumulated
                                                                    (SimpleStr
                                                                    "One or more space-separated occurrences of '[+|-]( * | namespace | fact id)'")),
                                                                    "\n\t\tPrunes the context to include only the facts from the given namespace or fact id. \n\t\t\tFacts can be include or excluded using the [+|-] qualifier. \n\t\t\tFor example --using_facts_from '* -FStar.Reflection +FStar.List -FStar.List.Tot' will \n\t\t\t\tremove all facts from FStar.List.Tot.*, \n\t\t\t\tretain all remaining facts from FStar.List.*, \n\t\t\t\tremove all facts from FStar.Reflection.*, \n\t\t\t\tand retain all the rest.\n\t\tNote, the '+' is optional: --using_facts_from 'FStar.List' is equivalent to --using_facts_from '+FStar.List'. \n\t\tMultiple uses of this option accumulate, e.g., --using_facts_from A --using_facts_from B is interpreted as --using_facts_from A^B.")
                                                                    ::
                                                                    uu____7035
                                                                     in
                                                                    uu____7001
                                                                    ::
                                                                    uu____7021
                                                                     in
                                                                    uu____6967
                                                                    ::
                                                                    uu____6987
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_native_tactics",
                                                                    (PathStr
                                                                    "path"),
                                                                    "Use compiled tactics from <path>")
                                                                    ::
                                                                    uu____6953
                                                                     in
                                                                    uu____6919
                                                                    ::
                                                                    uu____6939
                                                                     in
                                                                    uu____6885
                                                                    ::
                                                                    uu____6905
                                                                     in
                                                                    uu____6851
                                                                    ::
                                                                    uu____6871
                                                                     in
                                                                    uu____6817
                                                                    ::
                                                                    uu____6837
                                                                     in
                                                                    uu____6783
                                                                    ::
                                                                    uu____6803
                                                                     in
                                                                    uu____6749
                                                                    ::
                                                                    uu____6769
                                                                     in
                                                                    uu____6715
                                                                    ::
                                                                    uu____6735
                                                                     in
                                                                    uu____6681
                                                                    ::
                                                                    uu____6701
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tcnorm",
                                                                    BoolStr,
                                                                    "Attempt to normalize definitions marked as tcnorm (default 'true')")
                                                                    ::
                                                                    uu____6667
                                                                     in
                                                                    uu____6633
                                                                    ::
                                                                    uu____6653
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactic_trace_d",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Trace tactics up to a certain binding depth")
                                                                    ::
                                                                    uu____6619
                                                                     in
                                                                    uu____6585
                                                                    ::
                                                                    uu____6605
                                                                     in
                                                                    uu____6551
                                                                    ::
                                                                    uu____6571
                                                                     in
                                                                    uu____6517
                                                                    ::
                                                                    uu____6537
                                                                     in
                                                                    uu____6483
                                                                    ::
                                                                    uu____6503
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smtencoding.l_arith_repr",
                                                                    (EnumStr
                                                                    ["native";
                                                                    "boxwrap"]),
                                                                    "Toggle the representation of linear arithmetic functions in the SMT encoding:\n\t\ti.e., if 'boxwrap', use 'Prims.op_Addition, Prims.op_Subtraction, Prims.op_Minus'; \n\t\tif 'native', use '+, -, -'; \n\t\t(default 'boxwrap')")
                                                                    ::
                                                                    uu____6469
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smtencoding.nl_arith_repr",
                                                                    (EnumStr
                                                                    ["native";
                                                                    "wrapped";
                                                                    "boxwrap"]),
                                                                    "Control the representation of non-linear arithmetic functions in the SMT encoding:\n\t\ti.e., if 'boxwrap' use 'Prims.op_Multiply, Prims.op_Division, Prims.op_Modulus'; \n\t\tif 'native' use '*, div, mod';\n\t\tif 'wrapped' use '_mul, _div, _mod : Int*Int -> Int'; \n\t\t(default 'boxwrap')")
                                                                    ::
                                                                    uu____6455
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smtencoding.elim_box",
                                                                    BoolStr,
                                                                    "Toggle a peephole optimization that eliminates redundant uses of boxing/unboxing in the SMT encoding (default 'false')")
                                                                    ::
                                                                    uu____6441
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smt",
                                                                    (PathStr
                                                                    "path"),
                                                                    "Path to the Z3 SMT solver (we could eventually support other solvers)")
                                                                    ::
                                                                    uu____6427
                                                                     in
                                                                    uu____6393
                                                                    ::
                                                                    uu____6413
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "reuse_hint_for",
                                                                    (SimpleStr
                                                                    "toplevel_name"),
                                                                    "Optimistically, attempt using the recorded hint for <toplevel_name> (a top-level name in the current module) when trying to verify some other term 'g'")
                                                                    ::
                                                                    uu____6379
                                                                     in
                                                                    uu____6345
                                                                    ::
                                                                    uu____6365
                                                                     in
                                                                    uu____6311
                                                                    ::
                                                                    uu____6331
                                                                     in
                                                                    uu____6277
                                                                    ::
                                                                    uu____6297
                                                                     in
                                                                    uu____6243
                                                                    ::
                                                                    uu____6263
                                                                     in
                                                                    uu____6209
                                                                    ::
                                                                    uu____6229
                                                                     in
                                                                    uu____6175
                                                                    ::
                                                                    uu____6195
                                                                     in
                                                                    uu____6141
                                                                    ::
                                                                    uu____6161
                                                                     in
                                                                    uu____6107
                                                                    ::
                                                                    uu____6127
                                                                     in
                                                                    uu____6073
                                                                    ::
                                                                    uu____6093
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "prims",
                                                                    (PathStr
                                                                    "file"),
                                                                    "") ::
                                                                    uu____6059
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "odir",
                                                                    (PostProcessed
                                                                    (pp_validate_dir,
                                                                    (PathStr
                                                                    "dir"))),
                                                                    "Place output in directory <dir>")
                                                                    ::
                                                                    uu____6045
                                                                     in
                                                                    uu____6011
                                                                    ::
                                                                    uu____6031
                                                                     in
                                                                    uu____5977
                                                                    ::
                                                                    uu____5997
                                                                     in
                                                                    uu____5943
                                                                    ::
                                                                    uu____5963
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_extract",
                                                                    (Accumulated
                                                                    (PathStr
                                                                    "module name")),
                                                                    "Deprecated: use --extract instead; Do not extract code from this module")
                                                                    ::
                                                                    uu____5929
                                                                     in
                                                                    uu____5895
                                                                    ::
                                                                    uu____5915
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "n_cores",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Maximum number of cores to use for the solver (implies detail_errors = false) (default 1)")
                                                                    ::
                                                                    uu____5881
                                                                     in
                                                                    uu____5847
                                                                    ::
                                                                    uu____5867
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "min_fuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Minimum number of unrolling of recursive functions to try (default 1)")
                                                                    ::
                                                                    uu____5833
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "max_ifuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of inductive datatypes to try at most (default 2)")
                                                                    ::
                                                                    uu____5819
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "max_fuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of recursive functions to try at most (default 8)")
                                                                    ::
                                                                    uu____5805
                                                                     in
                                                                    uu____5771
                                                                    ::
                                                                    uu____5791
                                                                     in
                                                                    uu____5737
                                                                    ::
                                                                    uu____5757
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "load",
                                                                    (ReverseAccumulated
                                                                    (PathStr
                                                                    "module")),
                                                                    "Load compiled module")
                                                                    ::
                                                                    uu____5723
                                                                     in
                                                                    uu____5689
                                                                    ::
                                                                    uu____5709
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "keep_query_captions",
                                                                    BoolStr,
                                                                    "Retain comments in the logged SMT queries (requires --log_queries; default true)")
                                                                    ::
                                                                    uu____5675
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "initial_ifuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of inductive datatypes to try at first (default 1)")
                                                                    ::
                                                                    uu____5661
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "initial_fuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of recursive functions to try initially (default 2)")
                                                                    ::
                                                                    uu____5647
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "protect_top_level_axioms",
                                                                    BoolStr,
                                                                    "Guard nullary top-level symbols in the SMT encoding from provide ambient ground facts (default 'false')")
                                                                    ::
                                                                    uu____5633
                                                                     in
                                                                    uu____5599
                                                                    ::
                                                                    uu____5619
                                                                     in
                                                                  uu____5565
                                                                    ::
                                                                    uu____5585
                                                                   in
                                                                uu____5531 ::
                                                                  uu____5551
                                                                 in
                                                              (FStar_Getopt.noshort,
                                                                "include",
                                                                (ReverseAccumulated
                                                                   (PathStr
                                                                    "path")),
                                                                "A directory in which to search for files included on the command line")
                                                                :: uu____5517
                                                               in
                                                            uu____5483 ::
                                                              uu____5503
                                                             in
                                                          uu____5449 ::
                                                            uu____5469
                                                           in
                                                        uu____5415 ::
                                                          uu____5435
                                                         in
                                                      (FStar_Getopt.noshort,
                                                        "hint_file",
                                                        (PathStr "path"),
                                                        "Read/write hints to <path> (instead of module-specific hints files)")
                                                        :: uu____5401
                                                       in
                                                    uu____5367 :: uu____5387
                                                     in
                                                  uu____5333 :: uu____5353
                                                   in
                                                (FStar_Getopt.noshort,
                                                  "extract_namespace",
                                                  (Accumulated
                                                     (PostProcessed
                                                        (pp_lowercase,
                                                          (SimpleStr
                                                             "namespace name")))),
                                                  "Deprecated: use --extract instead; Only extract modules in the specified namespace")
                                                  :: uu____5319
                                                 in
                                              (FStar_Getopt.noshort,
                                                "extract_module",
                                                (Accumulated
                                                   (PostProcessed
                                                      (pp_lowercase,
                                                        (SimpleStr
                                                           "module_name")))),
                                                "Deprecated: use --extract instead; Only extract the specified modules (instead of the possibly-partial dependency graph)")
                                                :: uu____5305
                                               in
                                            (FStar_Getopt.noshort, "extract",
                                              (Accumulated
                                                 (SimpleStr
                                                    "One or more space-separated occurrences of '[+|-]( * | namespace | module)'")),
                                              "\n\t\tExtract only those modules whose names or namespaces match the provided options.\n\t\t\tModules can be extracted or not using the [+|-] qualifier. \n\t\t\tFor example --extract '* -FStar.Reflection +FStar.List -FStar.List.Tot' will \n\t\t\t\tnot extract FStar.List.Tot.*, \n\t\t\t\textract remaining modules from FStar.List.*, \n\t\t\t\tnot extract FStar.Reflection.*, \n\t\t\t\tand extract all the rest.\n\t\tNote, the '+' is optional: --extract '+A' and --extract 'A' mean the same thing.\n\t\tMultiple uses of this option accumulate, e.g., --extract A --extract B is interpreted as --extract 'A B'.")
                                              :: uu____5291
                                             in
                                          uu____5257 :: uu____5277  in
                                        uu____5223 :: uu____5243  in
                                      (FStar_Getopt.noshort, "dump_module",
                                        (Accumulated
                                           (SimpleStr "module_name")), "")
                                        :: uu____5209
                                       in
                                    uu____5175 :: uu____5195  in
                                  uu____5141 :: uu____5161  in
                                uu____5107 :: uu____5127  in
                              (FStar_Getopt.noshort, "dep",
                                (EnumStr ["make"; "graph"; "full"; "raw"]),
                                "Output the transitive closure of the full dependency graph in three formats:\n\t 'graph': a format suitable the 'dot' tool from 'GraphViz'\n\t 'full': a format suitable for 'make', including dependences for producing .ml and .krml files\n\t 'make': (deprecated) a format suitable for 'make', including only dependences among source files")
                                :: uu____5093
                               in
                            (FStar_Getopt.noshort, "defensive",
                              (EnumStr ["no"; "warn"; "fail"]),
                              "Enable several internal sanity checks, useful to track bugs and report issues.\n\t\tif 'no', no checks are performed\n\t\tif 'warn', checks are performed and raise a warning when they fail\n\t\tif 'fail', like 'warn', but the compiler aborts instead of issuing a warning\n\t\t(default 'no')")
                              :: uu____5079
                             in
                          (FStar_Getopt.noshort, "debug_level",
                            (Accumulated
                               (OpenEnumStr
                                  (["Low"; "Medium"; "High"; "Extreme"],
                                    "..."))),
                            "Control the verbosity of debugging info") ::
                            uu____5065
                           in
                        (FStar_Getopt.noshort, "debug",
                          (Accumulated (SimpleStr "module_name")),
                          "Print lots of debugging information while checking module")
                          :: uu____5051
                         in
                      (FStar_Getopt.noshort, "codegen-lib",
                        (Accumulated (SimpleStr "namespace")),
                        "External runtime library (i.e. M.N.x extracts to M.N.X instead of M_N.x)")
                        :: uu____5037
                       in
                    (FStar_Getopt.noshort, "codegen",
                      (EnumStr ["OCaml"; "FSharp"; "Kremlin"; "Plugin"]),
                      "Generate code for further compilation to executable code, or build a compiler plugin")
                      :: uu____5023
                     in
                  uu____4989 :: uu____5009  in
                uu____4955 :: uu____4975  in
              (FStar_Getopt.noshort, "cache_dir",
                (PostProcessed (pp_validate_dir, (PathStr "dir"))),
                "Read and write .checked and .checked.lax in directory <dir>")
                :: uu____4941
               in
            uu____4907 :: uu____4927  in
          (FStar_Getopt.noshort, "already_cached",
            (Accumulated
               (SimpleStr
                  "One or more space-separated occurrences of '[+|-]( * | namespace | module)'")),
            "\n\t\tExpects all modules whose names or namespaces match the provided options \n\t\t\tto already have valid .checked files in the include path")
            :: uu____4893
           in
        (FStar_Getopt.noshort, "admit_except",
          (SimpleStr "[symbol|(symbol, id)]"),
          "Admit all queries, except those with label (<symbol>, <id>)) (e.g. --admit_except '(FStar.Fin.pigeonhole, 1)' or --admit_except FStar.Fin.pigeonhole)")
          :: uu____4879
         in
      (FStar_Getopt.noshort, "admit_smt_queries", BoolStr,
        "Admit SMT queries, unsafe! (default 'false')") :: uu____4865
       in
    (FStar_Getopt.noshort, "abort_on",
      (PostProcessed
         ((fun uu___87_9130  ->
             match uu___87_9130 with
             | Int x -> (FStar_ST.op_Colon_Equals abort_counter x; Int x)
             | x -> failwith "?"), (IntStr "non-negative integer"))),
      "Abort on the n-th error or warning raised. Useful in combination with --trace_error. Count starts at 1, use 0 to disable. (default 0)")
      :: uu____4851

and (specs : unit -> FStar_Getopt.opt Prims.list) =
  fun uu____9159  ->
    let uu____9162 = specs_with_types ()  in
    FStar_List.map
      (fun uu____9193  ->
         match uu____9193 with
         | (short,long,typ,doc) ->
             let uu____9215 =
               let uu____9229 = arg_spec_of_opt_type long typ  in
               (short, long, uu____9229, doc)  in
             mk_spec uu____9215) uu____9162

let (settable : Prims.string -> Prims.bool) =
  fun uu___88_9244  ->
    match uu___88_9244 with
    | "abort_on" -> true
    | "admit_except" -> true
    | "admit_smt_queries" -> true
    | "debug" -> true
    | "debug_level" -> true
    | "defensive" -> true
    | "detail_errors" -> true
    | "detail_hint_replay" -> true
    | "eager_inference" -> true
    | "eager_subtyping" -> true
    | "hide_uvar_nums" -> true
    | "hint_file" -> true
    | "hint_info" -> true
    | "initial_fuel" -> true
    | "initial_ifuel" -> true
    | "lax" -> true
    | "load" -> true
    | "log_queries" -> true
    | "log_types" -> true
    | "max_fuel" -> true
    | "max_ifuel" -> true
    | "min_fuel" -> true
    | "no_plugins" -> true
    | "__no_positivity" -> true
    | "normalize_pure_terms_for_extraction" -> true
    | "no_smt" -> true
    | "no_tactics" -> true
    | "print_bound_var_types" -> true
    | "print_effect_args" -> true
    | "print_full_names" -> true
    | "print_implicits" -> true
    | "print_universes" -> true
    | "print_z3_statistics" -> true
    | "prn" -> true
    | "query_stats" -> true
    | "reuse_hint_for" -> true
    | "silent" -> true
    | "smtencoding.elim_box" -> true
    | "smtencoding.l_arith_repr" -> true
    | "smtencoding.nl_arith_repr" -> true
    | "tactic_raw_binders" -> true
    | "tactics_failhard" -> true
    | "tactics_info" -> true
    | "__tactics_nbe" -> true
    | "tactic_trace" -> true
    | "tactic_trace_d" -> true
    | "tcnorm" -> true
    | "__temp_fast_implicits" -> true
    | "__temp_no_proj" -> true
    | "timing" -> true
    | "trace_error" -> true
    | "ugly" -> true
    | "unthrottle_inductives" -> true
    | "use_eq_at_higher_order" -> true
    | "use_two_phase_tc" -> true
    | "using_facts_from" -> true
    | "vcgen.optimize_bind_as_seq" -> true
    | "warn_error" -> true
    | "z3cliopt" -> true
    | "z3refresh" -> true
    | "z3rlimit" -> true
    | "z3rlimit_factor" -> true
    | "z3seed" -> true
    | uu____9373 -> false
  
let (all_specs : FStar_Getopt.opt Prims.list) = specs () 
let (all_specs_with_types :
  (FStar_BaseTypes.char * Prims.string * opt_type * Prims.string) Prims.list)
  = specs_with_types () 
let (settable_specs :
  (FStar_BaseTypes.char * Prims.string * unit FStar_Getopt.opt_variant *
    Prims.string) Prims.list)
  =
  FStar_All.pipe_right all_specs
    (FStar_List.filter
       (fun uu____9457  ->
          match uu____9457 with
          | (uu____9472,x,uu____9474,uu____9475) -> settable x))
  
let (display_usage : unit -> unit) =
  fun uu____9491  ->
    let uu____9492 = specs ()  in display_usage_aux uu____9492
  
let (fstar_bin_directory : Prims.string) = FStar_Util.get_exec_dir () 
exception File_argument of Prims.string 
let (uu___is_File_argument : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | File_argument uu____9524 -> true
    | uu____9527 -> false
  
let (__proj__File_argument__item__uu___ : Prims.exn -> Prims.string) =
  fun projectee  ->
    match projectee with | File_argument uu____9538 -> uu____9538
  
let (set_options : Prims.string -> FStar_Getopt.parse_cmdline_res) =
  fun s  ->
    try
      (fun uu___93_9549  ->
         match () with
         | () ->
             if s = ""
             then FStar_Getopt.Success
             else
               FStar_Getopt.parse_string settable_specs
                 (fun s1  -> FStar_Exn.raise (File_argument s1)) s) ()
    with
    | File_argument s1 ->
        let uu____9566 =
          FStar_Util.format1 "File %s is not a valid option" s1  in
        FStar_Getopt.Error uu____9566
  
let (file_list_ : Prims.string Prims.list FStar_ST.ref) =
  FStar_Util.mk_ref [] 
let (parse_cmd_line :
  unit -> (FStar_Getopt.parse_cmdline_res * Prims.string Prims.list)) =
  fun uu____9602  ->
    let res =
      FStar_Getopt.parse_cmdline all_specs
        (fun i  ->
           let uu____9608 =
             let uu____9612 = FStar_ST.op_Bang file_list_  in
             FStar_List.append uu____9612 [i]  in
           FStar_ST.op_Colon_Equals file_list_ uu____9608)
       in
    let uu____9669 =
      let uu____9673 = FStar_ST.op_Bang file_list_  in
      FStar_List.map FStar_Common.try_convert_file_name_to_mixed uu____9673
       in
    (res, uu____9669)
  
let (file_list : unit -> Prims.string Prims.list) =
  fun uu____9715  -> FStar_ST.op_Bang file_list_ 
let (restore_cmd_line_options : Prims.bool -> FStar_Getopt.parse_cmdline_res)
  =
  fun should_clear  ->
    let old_verify_module = get_verify_module ()  in
    if should_clear then clear () else init ();
    (let r =
       let uu____9758 = specs ()  in
       FStar_Getopt.parse_cmdline uu____9758 (fun x  -> ())  in
     (let uu____9765 =
        let uu____9771 =
          let uu____9772 = FStar_List.map mk_string old_verify_module  in
          List uu____9772  in
        ("verify_module", uu____9771)  in
      set_option' uu____9765);
     r)
  
let (module_name_of_file_name : Prims.string -> Prims.string) =
  fun f  ->
    let f1 = FStar_Util.basename f  in
    let f2 =
      let uu____9791 =
        let uu____9793 =
          let uu____9795 =
            let uu____9797 = FStar_Util.get_file_extension f1  in
            FStar_String.length uu____9797  in
          (FStar_String.length f1) - uu____9795  in
        uu____9793 - (Prims.parse_int "1")  in
      FStar_String.substring f1 (Prims.parse_int "0") uu____9791  in
    FStar_String.lowercase f2
  
let (should_verify : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____9810 = get_lax ()  in
    if uu____9810
    then false
    else
      (let l = get_verify_module ()  in
       FStar_List.contains (FStar_String.lowercase m) l)
  
let (should_verify_file : Prims.string -> Prims.bool) =
  fun fn  ->
    let uu____9831 = module_name_of_file_name fn  in should_verify uu____9831
  
let (dont_gen_projectors : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____9842 = get___temp_no_proj ()  in
    FStar_List.contains m uu____9842
  
let (should_print_message : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____9856 = should_verify m  in
    if uu____9856 then m <> "Prims" else false
  
let (include_path : unit -> Prims.string Prims.list) =
  fun uu____9873  ->
    let cache_dir =
      let uu____9878 = get_cache_dir ()  in
      match uu____9878 with
      | FStar_Pervasives_Native.None  -> []
      | FStar_Pervasives_Native.Some c -> [c]  in
    let uu____9892 = get_no_default_includes ()  in
    if uu____9892
    then
      let uu____9898 = get_include ()  in
      FStar_List.append cache_dir uu____9898
    else
      (let lib_paths =
         let uu____9909 = FStar_Util.expand_environment_variable "FSTAR_LIB"
            in
         match uu____9909 with
         | FStar_Pervasives_Native.None  ->
             let fstar_home = Prims.strcat fstar_bin_directory "/.."  in
             let defs = universe_include_path_base_dirs  in
             let uu____9925 =
               FStar_All.pipe_right defs
                 (FStar_List.map (fun x  -> Prims.strcat fstar_home x))
                in
             FStar_All.pipe_right uu____9925
               (FStar_List.filter FStar_Util.file_exists)
         | FStar_Pervasives_Native.Some s -> [s]  in
       let uu____9952 =
         let uu____9956 =
           let uu____9960 = get_include ()  in
           FStar_List.append uu____9960 ["."]  in
         FStar_List.append lib_paths uu____9956  in
       FStar_List.append cache_dir uu____9952)
  
let (find_file : Prims.string -> Prims.string FStar_Pervasives_Native.option)
  =
  let file_map = FStar_Util.smap_create (Prims.parse_int "100")  in
  fun filename  ->
    let uu____9987 = FStar_Util.smap_try_find file_map filename  in
    match uu____9987 with
    | FStar_Pervasives_Native.Some f -> FStar_Pervasives_Native.Some f
    | FStar_Pervasives_Native.None  ->
        let result =
          try
            (fun uu___95_10009  ->
               match () with
               | () ->
                   let uu____10013 = FStar_Util.is_path_absolute filename  in
                   if uu____10013
                   then
                     (if FStar_Util.file_exists filename
                      then FStar_Pervasives_Native.Some filename
                      else FStar_Pervasives_Native.None)
                   else
                     (let uu____10029 =
                        let uu____10033 = include_path ()  in
                        FStar_List.rev uu____10033  in
                      FStar_Util.find_map uu____10029
                        (fun p  ->
                           let path =
                             if p = "."
                             then filename
                             else FStar_Util.join_paths p filename  in
                           if FStar_Util.file_exists path
                           then FStar_Pervasives_Native.Some path
                           else FStar_Pervasives_Native.None))) ()
          with | uu___94_10061 -> FStar_Pervasives_Native.None  in
        (match result with
         | FStar_Pervasives_Native.None  -> result
         | FStar_Pervasives_Native.Some f ->
             (FStar_Util.smap_add file_map filename f; result))
  
let (prims : unit -> Prims.string) =
  fun uu____10081  ->
    let uu____10082 = get_prims ()  in
    match uu____10082 with
    | FStar_Pervasives_Native.None  ->
        let filename = "prims.fst"  in
        let uu____10091 = find_file filename  in
        (match uu____10091 with
         | FStar_Pervasives_Native.Some result -> result
         | FStar_Pervasives_Native.None  ->
             let uu____10100 =
               FStar_Util.format1
                 "unable to find required file \"%s\" in the module search path.\n"
                 filename
                in
             failwith uu____10100)
    | FStar_Pervasives_Native.Some x -> x
  
let (prims_basename : unit -> Prims.string) =
  fun uu____10113  ->
    let uu____10114 = prims ()  in FStar_Util.basename uu____10114
  
let (pervasives : unit -> Prims.string) =
  fun uu____10122  ->
    let filename = "FStar.Pervasives.fst"  in
    let uu____10126 = find_file filename  in
    match uu____10126 with
    | FStar_Pervasives_Native.Some result -> result
    | FStar_Pervasives_Native.None  ->
        let uu____10135 =
          FStar_Util.format1
            "unable to find required file \"%s\" in the module search path.\n"
            filename
           in
        failwith uu____10135
  
let (pervasives_basename : unit -> Prims.string) =
  fun uu____10145  ->
    let uu____10146 = pervasives ()  in FStar_Util.basename uu____10146
  
let (pervasives_native_basename : unit -> Prims.string) =
  fun uu____10154  ->
    let filename = "FStar.Pervasives.Native.fst"  in
    let uu____10158 = find_file filename  in
    match uu____10158 with
    | FStar_Pervasives_Native.Some result -> FStar_Util.basename result
    | FStar_Pervasives_Native.None  ->
        let uu____10167 =
          FStar_Util.format1
            "unable to find required file \"%s\" in the module search path.\n"
            filename
           in
        failwith uu____10167
  
let (prepend_output_dir : Prims.string -> Prims.string) =
  fun fname  ->
    let uu____10180 = get_odir ()  in
    match uu____10180 with
    | FStar_Pervasives_Native.None  -> fname
    | FStar_Pervasives_Native.Some x -> FStar_Util.join_paths x fname
  
let (prepend_cache_dir : Prims.string -> Prims.string) =
  fun fpath  ->
    let uu____10198 = get_cache_dir ()  in
    match uu____10198 with
    | FStar_Pervasives_Native.None  -> fpath
    | FStar_Pervasives_Native.Some x ->
        let uu____10207 = FStar_Util.basename fpath  in
        FStar_Util.join_paths x uu____10207
  
let (path_of_text : Prims.string -> Prims.string Prims.list) =
  fun text  -> FStar_String.split [46] text 
let (parse_settings :
  Prims.string Prims.list ->
    (Prims.string Prims.list * Prims.bool) Prims.list)
  =
  fun ns  ->
    let cache = FStar_Util.smap_create (Prims.parse_int "31")  in
    let with_cache f s =
      let uu____10329 = FStar_Util.smap_try_find cache s  in
      match uu____10329 with
      | FStar_Pervasives_Native.Some s1 -> s1
      | FStar_Pervasives_Native.None  ->
          let res = f s  in (FStar_Util.smap_add cache s res; res)
       in
    let parse_one_setting s =
      if s = "*"
      then ([], true)
      else
        if s = "-*"
        then ([], false)
        else
          if FStar_Util.starts_with s "-"
          then
            (let path =
               let uu____10483 =
                 FStar_Util.substring_from s (Prims.parse_int "1")  in
               path_of_text uu____10483  in
             (path, false))
          else
            (let s1 =
               if FStar_Util.starts_with s "+"
               then FStar_Util.substring_from s (Prims.parse_int "1")
               else s  in
             ((path_of_text s1), true))
       in
    let uu____10506 =
      FStar_All.pipe_right ns
        (FStar_List.collect
           (fun s  ->
              let s1 = FStar_Util.trim_string s  in
              if s1 = ""
              then []
              else
                with_cache
                  (fun s2  ->
                     let uu____10574 =
                       FStar_All.pipe_right (FStar_Util.split s2 " ")
                         (FStar_List.filter (fun s3  -> s3 <> ""))
                        in
                     FStar_All.pipe_right uu____10574
                       (FStar_List.map parse_one_setting)) s1))
       in
    FStar_All.pipe_right uu____10506 FStar_List.rev
  
let (__temp_no_proj : Prims.string -> Prims.bool) =
  fun s  ->
    let uu____10650 = get___temp_no_proj ()  in
    FStar_All.pipe_right uu____10650 (FStar_List.contains s)
  
let (__temp_fast_implicits : unit -> Prims.bool) =
  fun uu____10665  -> lookup_opt "__temp_fast_implicits" as_bool 
let (admit_smt_queries : unit -> Prims.bool) =
  fun uu____10674  -> get_admit_smt_queries () 
let (admit_except : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____10683  -> get_admit_except () 
let (cache_checked_modules : unit -> Prims.bool) =
  fun uu____10690  -> get_cache_checked_modules () 
let (cache_off : unit -> Prims.bool) = fun uu____10697  -> get_cache_off () 
let (cmi : unit -> Prims.bool) = fun uu____10704  -> get_cmi () 
type codegen_t =
  | OCaml 
  | FSharp 
  | Kremlin 
  | Plugin 
let (uu___is_OCaml : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | OCaml  -> true | uu____10714 -> false
  
let (uu___is_FSharp : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | FSharp  -> true | uu____10725 -> false
  
let (uu___is_Kremlin : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Kremlin  -> true | uu____10736 -> false
  
let (uu___is_Plugin : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Plugin  -> true | uu____10747 -> false
  
let (codegen : unit -> codegen_t FStar_Pervasives_Native.option) =
  fun uu____10756  ->
    let uu____10757 = get_codegen ()  in
    FStar_Util.map_opt uu____10757
      (fun uu___89_10763  ->
         match uu___89_10763 with
         | "OCaml" -> OCaml
         | "FSharp" -> FSharp
         | "Kremlin" -> Kremlin
         | "Plugin" -> Plugin
         | uu____10769 -> failwith "Impossible")
  
let (codegen_libs : unit -> Prims.string Prims.list Prims.list) =
  fun uu____10782  ->
    let uu____10783 = get_codegen_lib ()  in
    FStar_All.pipe_right uu____10783
      (FStar_List.map (fun x  -> FStar_Util.split x "."))
  
let (debug_any : unit -> Prims.bool) =
  fun uu____10809  -> let uu____10810 = get_debug ()  in uu____10810 <> [] 
let (debug_module : Prims.string -> Prims.bool) =
  fun modul  ->
    let uu____10827 = get_debug ()  in
    FStar_All.pipe_right uu____10827 (FStar_List.contains modul)
  
let (debug_at_level : Prims.string -> debug_level_t -> Prims.bool) =
  fun modul  ->
    fun level  ->
      (let uu____10852 = get_debug ()  in
       FStar_All.pipe_right uu____10852 (FStar_List.contains modul)) &&
        (debug_level_geq level)
  
let (defensive : unit -> Prims.bool) =
  fun uu____10867  ->
    let uu____10868 = get_defensive ()  in uu____10868 <> "no"
  
let (defensive_fail : unit -> Prims.bool) =
  fun uu____10878  ->
    let uu____10879 = get_defensive ()  in uu____10879 = "fail"
  
let (dep : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____10891  -> get_dep () 
let (detail_errors : unit -> Prims.bool) =
  fun uu____10898  -> get_detail_errors () 
let (detail_hint_replay : unit -> Prims.bool) =
  fun uu____10905  -> get_detail_hint_replay () 
let (doc : unit -> Prims.bool) = fun uu____10912  -> get_doc () 
let (dump_module : Prims.string -> Prims.bool) =
  fun s  ->
    let uu____10922 = get_dump_module ()  in
    FStar_All.pipe_right uu____10922 (FStar_List.contains s)
  
let (eager_subtyping : unit -> Prims.bool) =
  fun uu____10937  -> get_eager_subtyping () 
let (expose_interfaces : unit -> Prims.bool) =
  fun uu____10944  -> get_expose_interfaces () 
let (fs_typ_app : Prims.string -> Prims.bool) =
  fun filename  ->
    let uu____10954 = FStar_ST.op_Bang light_off_files  in
    FStar_List.contains filename uu____10954
  
let (full_context_dependency : unit -> Prims.bool) = fun uu____10990  -> true 
let (hide_uvar_nums : unit -> Prims.bool) =
  fun uu____10998  -> get_hide_uvar_nums () 
let (hint_info : unit -> Prims.bool) =
  fun uu____11005  -> (get_hint_info ()) || (get_query_stats ()) 
let (hint_file : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11014  -> get_hint_file () 
let (ide : unit -> Prims.bool) = fun uu____11021  -> get_ide () 
let (print : unit -> Prims.bool) = fun uu____11028  -> get_print () 
let (print_in_place : unit -> Prims.bool) =
  fun uu____11035  -> get_print_in_place () 
let profile : 'a . (unit -> 'a) -> ('a -> Prims.string) -> 'a =
  fun f  ->
    fun msg  ->
      let uu____11066 = get_profile ()  in
      if uu____11066
      then
        let uu____11069 = FStar_Util.record_time f  in
        match uu____11069 with
        | (a,time) ->
            ((let uu____11080 = FStar_Util.string_of_int time  in
              let uu____11082 = msg a  in
              FStar_Util.print2 "Elapsed time %s ms: %s\n" uu____11080
                uu____11082);
             a)
      else f ()
  
let (protect_top_level_axioms : unit -> Prims.bool) =
  fun uu____11093  -> get_protect_top_level_axioms () 
let (initial_fuel : unit -> Prims.int) =
  fun uu____11100  ->
    let uu____11101 = get_initial_fuel ()  in
    let uu____11103 = get_max_fuel ()  in Prims.min uu____11101 uu____11103
  
let (initial_ifuel : unit -> Prims.int) =
  fun uu____11111  ->
    let uu____11112 = get_initial_ifuel ()  in
    let uu____11114 = get_max_ifuel ()  in Prims.min uu____11112 uu____11114
  
let (interactive : unit -> Prims.bool) =
  fun uu____11122  -> (get_in ()) || (get_ide ()) 
let (lax : unit -> Prims.bool) = fun uu____11129  -> get_lax () 
let (load : unit -> Prims.string Prims.list) =
  fun uu____11138  -> get_load () 
let (legacy_interactive : unit -> Prims.bool) = fun uu____11145  -> get_in () 
let (log_queries : unit -> Prims.bool) =
  fun uu____11152  -> get_log_queries () 
let (keep_query_captions : unit -> Prims.bool) =
  fun uu____11159  -> (log_queries ()) && (get_keep_query_captions ()) 
let (log_types : unit -> Prims.bool) = fun uu____11166  -> get_log_types () 
let (max_fuel : unit -> Prims.int) = fun uu____11173  -> get_max_fuel () 
let (max_ifuel : unit -> Prims.int) = fun uu____11180  -> get_max_ifuel () 
let (min_fuel : unit -> Prims.int) = fun uu____11187  -> get_min_fuel () 
let (ml_ish : unit -> Prims.bool) = fun uu____11194  -> get_MLish () 
let (set_ml_ish : unit -> unit) =
  fun uu____11200  -> set_option "MLish" (Bool true) 
let (n_cores : unit -> Prims.int) = fun uu____11209  -> get_n_cores () 
let (no_default_includes : unit -> Prims.bool) =
  fun uu____11216  -> get_no_default_includes () 
let (no_extract : Prims.string -> Prims.bool) =
  fun s  ->
    let s1 = FStar_String.lowercase s  in
    let uu____11228 = get_no_extract ()  in
    FStar_All.pipe_right uu____11228
      (FStar_Util.for_some (fun f  -> (FStar_String.lowercase f) = s1))
  
let (normalize_pure_terms_for_extraction : unit -> Prims.bool) =
  fun uu____11247  -> get_normalize_pure_terms_for_extraction () 
let (no_location_info : unit -> Prims.bool) =
  fun uu____11254  -> get_no_location_info () 
let (no_plugins : unit -> Prims.bool) = fun uu____11261  -> get_no_plugins () 
let (no_smt : unit -> Prims.bool) = fun uu____11268  -> get_no_smt () 
let (output_dir : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11277  -> get_odir () 
let (ugly : unit -> Prims.bool) = fun uu____11284  -> get_ugly () 
let (print_bound_var_types : unit -> Prims.bool) =
  fun uu____11291  -> get_print_bound_var_types () 
let (print_effect_args : unit -> Prims.bool) =
  fun uu____11298  -> get_print_effect_args () 
let (print_implicits : unit -> Prims.bool) =
  fun uu____11305  -> get_print_implicits () 
let (print_real_names : unit -> Prims.bool) =
  fun uu____11312  -> (get_prn ()) || (get_print_full_names ()) 
let (print_universes : unit -> Prims.bool) =
  fun uu____11319  -> get_print_universes () 
let (print_z3_statistics : unit -> Prims.bool) =
  fun uu____11326  -> get_print_z3_statistics () 
let (query_stats : unit -> Prims.bool) =
  fun uu____11333  -> get_query_stats () 
let (record_hints : unit -> Prims.bool) =
  fun uu____11340  -> get_record_hints () 
let (reuse_hint_for : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11349  -> get_reuse_hint_for () 
let (silent : unit -> Prims.bool) = fun uu____11356  -> get_silent () 
let (smtencoding_elim_box : unit -> Prims.bool) =
  fun uu____11363  -> get_smtencoding_elim_box () 
let (smtencoding_nl_arith_native : unit -> Prims.bool) =
  fun uu____11370  ->
    let uu____11371 = get_smtencoding_nl_arith_repr ()  in
    uu____11371 = "native"
  
let (smtencoding_nl_arith_wrapped : unit -> Prims.bool) =
  fun uu____11381  ->
    let uu____11382 = get_smtencoding_nl_arith_repr ()  in
    uu____11382 = "wrapped"
  
let (smtencoding_nl_arith_default : unit -> Prims.bool) =
  fun uu____11392  ->
    let uu____11393 = get_smtencoding_nl_arith_repr ()  in
    uu____11393 = "boxwrap"
  
let (smtencoding_l_arith_native : unit -> Prims.bool) =
  fun uu____11403  ->
    let uu____11404 = get_smtencoding_l_arith_repr ()  in
    uu____11404 = "native"
  
let (smtencoding_l_arith_default : unit -> Prims.bool) =
  fun uu____11414  ->
    let uu____11415 = get_smtencoding_l_arith_repr ()  in
    uu____11415 = "boxwrap"
  
let (tactic_raw_binders : unit -> Prims.bool) =
  fun uu____11425  -> get_tactic_raw_binders () 
let (tactics_failhard : unit -> Prims.bool) =
  fun uu____11432  -> get_tactics_failhard () 
let (tactics_info : unit -> Prims.bool) =
  fun uu____11439  -> get_tactics_info () 
let (tactic_trace : unit -> Prims.bool) =
  fun uu____11446  -> get_tactic_trace () 
let (tactic_trace_d : unit -> Prims.int) =
  fun uu____11453  -> get_tactic_trace_d () 
let (tactics_nbe : unit -> Prims.bool) =
  fun uu____11460  -> get_tactics_nbe () 
let (tcnorm : unit -> Prims.bool) = fun uu____11467  -> get_tcnorm () 
let (timing : unit -> Prims.bool) = fun uu____11474  -> get_timing () 
let (trace_error : unit -> Prims.bool) =
  fun uu____11481  -> get_trace_error () 
let (unthrottle_inductives : unit -> Prims.bool) =
  fun uu____11488  -> get_unthrottle_inductives () 
let (unsafe_tactic_exec : unit -> Prims.bool) =
  fun uu____11495  -> get_unsafe_tactic_exec () 
let (use_eq_at_higher_order : unit -> Prims.bool) =
  fun uu____11502  -> get_use_eq_at_higher_order () 
let (use_hints : unit -> Prims.bool) = fun uu____11509  -> get_use_hints () 
let (use_hint_hashes : unit -> Prims.bool) =
  fun uu____11516  -> get_use_hint_hashes () 
let (use_native_tactics :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11525  -> get_use_native_tactics () 
let (use_tactics : unit -> Prims.bool) =
  fun uu____11532  -> get_use_tactics () 
let (using_facts_from :
  unit -> (Prims.string Prims.list * Prims.bool) Prims.list) =
  fun uu____11548  ->
    let uu____11549 = get_using_facts_from ()  in
    match uu____11549 with
    | FStar_Pervasives_Native.None  -> [([], true)]
    | FStar_Pervasives_Native.Some ns -> parse_settings ns
  
let (vcgen_optimize_bind_as_seq : unit -> Prims.bool) =
  fun uu____11603  ->
    let uu____11604 = get_vcgen_optimize_bind_as_seq ()  in
    FStar_Option.isSome uu____11604
  
let (vcgen_decorate_with_type : unit -> Prims.bool) =
  fun uu____11615  ->
    let uu____11616 = get_vcgen_optimize_bind_as_seq ()  in
    match uu____11616 with
    | FStar_Pervasives_Native.Some "with_type" -> true
    | uu____11624 -> false
  
let (warn_default_effects : unit -> Prims.bool) =
  fun uu____11635  -> get_warn_default_effects () 
let (z3_exe : unit -> Prims.string) =
  fun uu____11642  ->
    let uu____11643 = get_smt ()  in
    match uu____11643 with
    | FStar_Pervasives_Native.None  -> FStar_Platform.exe "z3"
    | FStar_Pervasives_Native.Some s -> s
  
let (z3_cliopt : unit -> Prims.string Prims.list) =
  fun uu____11661  -> get_z3cliopt () 
let (z3_refresh : unit -> Prims.bool) = fun uu____11668  -> get_z3refresh () 
let (z3_rlimit : unit -> Prims.int) = fun uu____11675  -> get_z3rlimit () 
let (z3_rlimit_factor : unit -> Prims.int) =
  fun uu____11682  -> get_z3rlimit_factor () 
let (z3_seed : unit -> Prims.int) = fun uu____11689  -> get_z3seed () 
let (use_two_phase_tc : unit -> Prims.bool) =
  fun uu____11696  ->
    (get_use_two_phase_tc ()) &&
      (let uu____11698 = lax ()  in Prims.op_Negation uu____11698)
  
let (no_positivity : unit -> Prims.bool) =
  fun uu____11706  -> get_no_positivity () 
let (ml_no_eta_expand_coertions : unit -> Prims.bool) =
  fun uu____11713  -> get_ml_no_eta_expand_coertions () 
let (warn_error : unit -> Prims.string) =
  fun uu____11720  -> get_warn_error () 
let (use_extracted_interfaces : unit -> Prims.bool) =
  fun uu____11727  -> get_use_extracted_interfaces () 
let (use_nbe : unit -> Prims.bool) = fun uu____11734  -> get_use_nbe () 
let with_saved_options : 'a . (unit -> 'a) -> 'a =
  fun f  ->
    let uu____11751 =
      let uu____11753 = trace_error ()  in Prims.op_Negation uu____11753  in
    if uu____11751
    then
      (push ();
       (let r =
          try
            (fun uu___97_11768  ->
               match () with
               | () -> let uu____11773 = f ()  in FStar_Util.Inr uu____11773)
              ()
          with | uu___96_11775 -> FStar_Util.Inl uu___96_11775  in
        pop ();
        (match r with
         | FStar_Util.Inr v1 -> v1
         | FStar_Util.Inl ex -> FStar_Exn.raise ex)))
    else (push (); (let retv = f ()  in pop (); retv))
  
let (module_matches_namespace_filter :
  Prims.string -> Prims.string Prims.list -> Prims.bool) =
  fun m  ->
    fun filter1  ->
      let m1 = FStar_String.lowercase m  in
      let setting = parse_settings filter1  in
      let m_components = path_of_text m1  in
      let rec matches_path m_components1 path =
        match (m_components1, path) with
        | (uu____11856,[]) -> true
        | (m2::ms,p::ps) ->
            (m2 = (FStar_String.lowercase p)) && (matches_path ms ps)
        | uu____11889 -> false  in
      let uu____11901 =
        FStar_All.pipe_right setting
          (FStar_Util.try_find
             (fun uu____11943  ->
                match uu____11943 with
                | (path,uu____11954) -> matches_path m_components path))
         in
      match uu____11901 with
      | FStar_Pervasives_Native.None  -> false
      | FStar_Pervasives_Native.Some (uu____11973,flag) -> flag
  
let (should_extract : Prims.string -> Prims.bool) =
  fun m  ->
    let m1 = FStar_String.lowercase m  in
    let uu____12002 = get_extract ()  in
    match uu____12002 with
    | FStar_Pervasives_Native.Some extract_setting ->
        ((let uu____12017 =
            let uu____12033 = get_no_extract ()  in
            let uu____12037 = get_extract_namespace ()  in
            let uu____12041 = get_extract_module ()  in
            (uu____12033, uu____12037, uu____12041)  in
          match uu____12017 with
          | ([],[],[]) -> ()
          | uu____12066 ->
              failwith
                "Incompatible options: --extract cannot be used with --no_extract, --extract_namespace or --extract_module");
         module_matches_namespace_filter m1 extract_setting)
    | FStar_Pervasives_Native.None  ->
        let should_extract_namespace m2 =
          let uu____12095 = get_extract_namespace ()  in
          match uu____12095 with
          | [] -> false
          | ns ->
              FStar_All.pipe_right ns
                (FStar_Util.for_some
                   (fun n1  ->
                      FStar_Util.starts_with m2 (FStar_String.lowercase n1)))
           in
        let should_extract_module m2 =
          let uu____12123 = get_extract_module ()  in
          match uu____12123 with
          | [] -> false
          | l ->
              FStar_All.pipe_right l
                (FStar_Util.for_some
                   (fun n1  -> (FStar_String.lowercase n1) = m2))
           in
        (let uu____12145 = no_extract m1  in Prims.op_Negation uu____12145)
          &&
          (let uu____12148 =
             let uu____12159 = get_extract_namespace ()  in
             let uu____12163 = get_extract_module ()  in
             (uu____12159, uu____12163)  in
           (match uu____12148 with
            | ([],[]) -> true
            | uu____12183 ->
                (should_extract_namespace m1) || (should_extract_module m1)))
  
let (should_be_already_cached : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____12203 = get_already_cached ()  in
    match uu____12203 with
    | FStar_Pervasives_Native.None  -> false
    | FStar_Pervasives_Native.Some already_cached_setting ->
        module_matches_namespace_filter m already_cached_setting
  