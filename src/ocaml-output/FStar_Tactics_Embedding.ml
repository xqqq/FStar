open Prims
type name = FStar_Syntax_Syntax.bv
let fstar_tactics_lid': Prims.string Prims.list -> FStar_Ident.lid =
  fun s  -> FStar_Syntax_Const.fstar_tactics_lid' s
let fstar_tactics_lid: Prims.string -> FStar_Ident.lid =
  fun s  -> FStar_Syntax_Const.fstar_tactics_lid s
let by_tactic_lid: FStar_Ident.lid = FStar_Syntax_Const.by_tactic_lid
let lid_as_tm: FStar_Ident.lident -> FStar_Syntax_Syntax.term =
  fun l  ->
    let uu____12 =
      FStar_Syntax_Syntax.lid_as_fv l FStar_Syntax_Syntax.Delta_constant None in
    FStar_All.pipe_right uu____12 FStar_Syntax_Syntax.fv_to_tm
let mk_tactic_lid_as_term: Prims.string -> FStar_Syntax_Syntax.term =
  fun s  ->
    let uu____16 = fstar_tactics_lid' ["Effect"; s] in lid_as_tm uu____16
let fstar_tactics_goal: FStar_Syntax_Syntax.term =
  mk_tactic_lid_as_term "goal"
let fstar_tactics_goals: FStar_Syntax_Syntax.term =
  mk_tactic_lid_as_term "goals"
let lid_as_data_tm: FStar_Ident.lident -> FStar_Syntax_Syntax.term =
  fun l  ->
    let uu____20 =
      FStar_Syntax_Syntax.lid_as_fv l FStar_Syntax_Syntax.Delta_constant
        (Some FStar_Syntax_Syntax.Data_ctor) in
    FStar_Syntax_Syntax.fv_to_tm uu____20
let fstar_tactics_lid_as_data_tm: Prims.string -> FStar_Syntax_Syntax.term =
  fun s  ->
    let uu____24 = fstar_tactics_lid' ["Effect"; s] in
    lid_as_data_tm uu____24
let fstar_tactics_Failed: FStar_Syntax_Syntax.term =
  fstar_tactics_lid_as_data_tm "Failed"
let fstar_tactics_Success: FStar_Syntax_Syntax.term =
  fstar_tactics_lid_as_data_tm "Success"
let t_bool:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = FStar_TypeChecker_Common.t_bool
let t_string:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = FStar_TypeChecker_Common.t_string
let fstar_tac_prefix_typ:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  =
  let uu____31 =
    let uu____32 =
      let uu____33 = lid_as_tm FStar_Syntax_Const.list_lid in
      FStar_Syntax_Syntax.mk_Tm_uinst uu____33 [FStar_Syntax_Syntax.U_zero] in
    let uu____34 =
      let uu____35 = FStar_Syntax_Syntax.as_arg t_string in [uu____35] in
    FStar_Syntax_Syntax.mk_Tm_app uu____32 uu____34 in
  uu____31 None FStar_Range.dummyRange
let pair_typ:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    fun s  ->
      let uu____48 =
        let uu____49 =
          let uu____50 = lid_as_tm FStar_Reflection_Basic.lid_tuple2 in
          FStar_Syntax_Syntax.mk_Tm_uinst uu____50
            [FStar_Syntax_Syntax.U_zero; FStar_Syntax_Syntax.U_zero] in
        let uu____51 =
          let uu____52 = FStar_Syntax_Syntax.as_arg t in
          let uu____53 =
            let uu____55 = FStar_Syntax_Syntax.as_arg s in [uu____55] in
          uu____52 :: uu____53 in
        FStar_Syntax_Syntax.mk_Tm_app uu____49 uu____51 in
      uu____48 None FStar_Range.dummyRange
let fstar_tac_nselt_typ:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = pair_typ fstar_tac_prefix_typ t_bool
let fstar_tac_ns_typ:
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = pair_typ fstar_tac_nselt_typ t_bool
let embed_proof_namespace:
  FStar_Tactics_Basic.proofstate ->
    FStar_TypeChecker_Env.proof_namespace -> FStar_Syntax_Syntax.term
  =
  fun ps  ->
    fun ns  ->
      let embed_prefix prf =
        FStar_Reflection_Basic.embed_list FStar_Reflection_Basic.embed_string
          t_string prf in
      let embed_elt e =
        FStar_Reflection_Basic.embed_pair embed_prefix fstar_tac_prefix_typ
          FStar_Reflection_Basic.embed_bool t_bool e in
      let uu____87 = FStar_List.hd ns in
      FStar_Reflection_Basic.embed_list embed_elt fstar_tac_nselt_typ
        uu____87
let unembed_proof_namespace:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term ->
      (Prims.string Prims.list* Prims.bool) Prims.list Prims.list
  =
  fun ps  ->
    fun t  ->
      let orig_ns =
        FStar_TypeChecker_Env.get_proof_ns
          ps.FStar_Tactics_Basic.main_context in
      let hd1 =
        FStar_Reflection_Basic.unembed_list
          (FStar_Reflection_Basic.unembed_pair
             (FStar_Reflection_Basic.unembed_list
                FStar_Reflection_Basic.unembed_string)
             FStar_Reflection_Basic.unembed_bool) t in
      hd1 :: orig_ns
let embed_env:
  FStar_Tactics_Basic.proofstate ->
    FStar_TypeChecker_Env.env ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax
  =
  fun ps  ->
    fun env  ->
      let uu____121 =
        let uu____122 =
          let uu____126 = FStar_TypeChecker_Env.all_binders env in
          let uu____127 = FStar_TypeChecker_Env.get_proof_ns env in
          (uu____126, uu____127) in
        FStar_Reflection_Basic.embed_pair
          (FStar_Reflection_Basic.embed_list
             FStar_Reflection_Basic.embed_binder
             FStar_Reflection_Data.fstar_refl_binder)
          FStar_Reflection_Data.fstar_refl_binders (embed_proof_namespace ps)
          fstar_tac_ns_typ uu____122 in
      FStar_Reflection_Basic.protect_embedded_term
        FStar_Reflection_Data.fstar_refl_env uu____121
let unembed_env:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term -> FStar_TypeChecker_Env.env
  =
  fun ps  ->
    fun protected_embedded_env  ->
      let embedded_env =
        FStar_Reflection_Basic.un_protect_embedded_term
          protected_embedded_env in
      let uu____136 =
        FStar_Reflection_Basic.unembed_pair
          (FStar_Reflection_Basic.unembed_list
             FStar_Reflection_Basic.unembed_binder)
          (unembed_proof_namespace ps) embedded_env in
      match uu____136 with
      | (binders,ns) ->
          let env = ps.FStar_Tactics_Basic.main_context in
          let env1 = FStar_TypeChecker_Env.set_proof_ns ns env in
          let env2 =
            FStar_List.fold_left
              (fun env2  ->
                 fun b  ->
                   let uu____154 =
                     FStar_TypeChecker_Env.try_lookup_bv env2 (fst b) in
                   match uu____154 with
                   | None  -> FStar_TypeChecker_Env.push_binders env2 [b]
                   | uu____164 -> env2) env1 binders in
          env2
let embed_witness:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term option -> FStar_Syntax_Syntax.term
  =
  fun ps  ->
    fun w  ->
      FStar_Reflection_Basic.embed_option FStar_Reflection_Basic.embed_term
        FStar_Reflection_Data.fstar_refl_term w
let unembed_witness:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term option
  =
  fun ps  ->
    fun t  ->
      FStar_Reflection_Basic.unembed_option
        FStar_Reflection_Basic.unembed_term t
let embed_goal:
  FStar_Tactics_Basic.proofstate ->
    FStar_Tactics_Basic.goal -> FStar_Syntax_Syntax.term
  =
  fun ps  ->
    fun g  ->
      let uu____189 =
        pair_typ FStar_Reflection_Data.fstar_refl_env
          FStar_Reflection_Data.fstar_refl_term in
      FStar_Reflection_Basic.embed_pair
        (FStar_Reflection_Basic.embed_pair (embed_env ps)
           FStar_Reflection_Data.fstar_refl_env
           FStar_Reflection_Basic.embed_term
           FStar_Reflection_Data.fstar_refl_term) uu____189
        (embed_witness ps) FStar_Reflection_Data.fstar_refl_term
        (((g.FStar_Tactics_Basic.context), (g.FStar_Tactics_Basic.goal_ty)),
          (g.FStar_Tactics_Basic.witness))
let unembed_goal:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term -> FStar_Tactics_Basic.goal
  =
  fun ps  ->
    fun t  ->
      let uu____202 =
        FStar_Reflection_Basic.unembed_pair
          (FStar_Reflection_Basic.unembed_pair (unembed_env ps)
             FStar_Reflection_Basic.unembed_term) (unembed_witness ps) t in
      match uu____202 with
      | ((env,goal_ty),witness) ->
          {
            FStar_Tactics_Basic.context = env;
            FStar_Tactics_Basic.witness = witness;
            FStar_Tactics_Basic.goal_ty = goal_ty
          }
let embed_goals:
  FStar_Tactics_Basic.proofstate ->
    FStar_Tactics_Basic.goal Prims.list -> FStar_Syntax_Syntax.term
  =
  fun ps  ->
    fun l  ->
      FStar_Reflection_Basic.embed_list (embed_goal ps) fstar_tactics_goal l
let unembed_goals:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term -> FStar_Tactics_Basic.goal Prims.list
  =
  fun ps  ->
    fun egs  -> FStar_Reflection_Basic.unembed_list (unembed_goal ps) egs
type state =
  (FStar_Tactics_Basic.goal Prims.list* FStar_Tactics_Basic.goal Prims.list)
let embed_state:
  FStar_Tactics_Basic.proofstate -> state -> FStar_Syntax_Syntax.term =
  fun ps  ->
    fun s  ->
      FStar_Reflection_Basic.embed_pair (embed_goals ps) fstar_tactics_goals
        (embed_goals ps) fstar_tactics_goals s
let unembed_state:
  FStar_Tactics_Basic.proofstate ->
    FStar_Syntax_Syntax.term ->
      (FStar_Tactics_Basic.goal Prims.list* FStar_Tactics_Basic.goal
        Prims.list)
  =
  fun ps  ->
    fun s  ->
      let s1 = FStar_Syntax_Util.unascribe s in
      FStar_Reflection_Basic.unembed_pair (unembed_goals ps)
        (unembed_goals ps) s1
let embed_result ps res embed_a t_a =
  match res with
  | FStar_Tactics_Basic.Failed (msg,ps1) ->
      let uu____286 =
        let uu____287 =
          FStar_Syntax_Syntax.mk_Tm_uinst fstar_tactics_Failed
            [FStar_Syntax_Syntax.U_zero] in
        let uu____288 =
          let uu____289 = FStar_Syntax_Syntax.iarg t_a in
          let uu____290 =
            let uu____292 =
              let uu____293 = FStar_Reflection_Basic.embed_string msg in
              FStar_Syntax_Syntax.as_arg uu____293 in
            let uu____294 =
              let uu____296 =
                let uu____297 =
                  embed_state ps1
                    ((ps1.FStar_Tactics_Basic.goals),
                      (ps1.FStar_Tactics_Basic.smt_goals)) in
                FStar_Syntax_Syntax.as_arg uu____297 in
              [uu____296] in
            uu____292 :: uu____294 in
          uu____289 :: uu____290 in
        FStar_Syntax_Syntax.mk_Tm_app uu____287 uu____288 in
      uu____286 None FStar_Range.dummyRange
  | FStar_Tactics_Basic.Success (a,ps1) ->
      let uu____306 =
        let uu____307 =
          FStar_Syntax_Syntax.mk_Tm_uinst fstar_tactics_Success
            [FStar_Syntax_Syntax.U_zero] in
        let uu____308 =
          let uu____309 = FStar_Syntax_Syntax.iarg t_a in
          let uu____310 =
            let uu____312 =
              let uu____313 = embed_a a in
              FStar_Syntax_Syntax.as_arg uu____313 in
            let uu____314 =
              let uu____316 =
                let uu____317 =
                  embed_state ps1
                    ((ps1.FStar_Tactics_Basic.goals),
                      (ps1.FStar_Tactics_Basic.smt_goals)) in
                FStar_Syntax_Syntax.as_arg uu____317 in
              [uu____316] in
            uu____312 :: uu____314 in
          uu____309 :: uu____310 in
        FStar_Syntax_Syntax.mk_Tm_app uu____307 uu____308 in
      uu____306 None FStar_Range.dummyRange
let unembed_result ps res unembed_a =
  let res1 = FStar_Syntax_Util.unascribe res in
  let uu____353 = FStar_Syntax_Util.head_and_args res1 in
  match uu____353 with
  | (hd1,args) ->
      let uu____385 =
        let uu____393 =
          let uu____394 = FStar_Syntax_Util.un_uinst hd1 in
          uu____394.FStar_Syntax_Syntax.n in
        (uu____393, args) in
      (match uu____385 with
       | (FStar_Syntax_Syntax.Tm_fvar
          fv,_t::(a,uu____411)::(embedded_state,uu____413)::[]) when
           let uu____447 = fstar_tactics_lid' ["Effect"; "Success"] in
           FStar_Syntax_Syntax.fv_eq_lid fv uu____447 ->
           let uu____448 =
             let uu____451 = unembed_a a in
             let uu____452 = unembed_state ps embedded_state in
             (uu____451, uu____452) in
           FStar_Util.Inl uu____448
       | (FStar_Syntax_Syntax.Tm_fvar
          fv,_t::(embedded_string,uu____460)::(embedded_state,uu____462)::[])
           when
           let uu____496 = fstar_tactics_lid' ["Effect"; "Failed"] in
           FStar_Syntax_Syntax.fv_eq_lid fv uu____496 ->
           let uu____497 =
             let uu____500 =
               FStar_Reflection_Basic.unembed_string embedded_string in
             let uu____501 = unembed_state ps embedded_state in
             (uu____500, uu____501) in
           FStar_Util.Inr uu____497
       | uu____506 ->
           let uu____514 =
             let uu____515 = FStar_Syntax_Print.term_to_string res1 in
             FStar_Util.format1 "Not an embedded result: %s" uu____515 in
           failwith uu____514)