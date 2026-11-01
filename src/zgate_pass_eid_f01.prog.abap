*&---------------------------------------------------------------------*
*& Include          ZGATE_PASS_EID_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZGATE_PASS_EID_F01                               *
*&---------------------------------------------------------------------*
TABLES : ZGATE_PASS_H,ZGATE_PASS_I,zst_gp_wmpl,lfa1,lfm1,ZMMRT_GP_RET_WMP,eket,konv,v_konv_cds,
         zpass_dept_wmpl,t001w,tsp03,ekko,marm,t006a,setleaf.
TYPES : <icons>.
TYPE-POOLS : slis,vrm.
*****INTERNAL DATA****
TYPES : BEGIN OF ty_po,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          matnr TYPE ekpo-matnr,
          menge TYPE ekpo-menge,
          meins TYPE ekpo-meins,
        END OF ty_po.
TYPES : BEGIN OF ty_passi,
          sel(1),
          item_no      TYPE zitemnr,
          mat_ret_date TYPE zgate_pass_i-mat_ret_date,          "zgate_pass_I-mat_ret_date,
          matnr        TYPE matnr,
          maktx        TYPE maktx,
          meins        TYPE meins,
          menge        TYPE menge_d,
          value        TYPE dmbtr,
          anln1        TYPE anla-anln1,
          txt50        TYPE anla-txt50,
          remarks      TYPE char50,
        END OF ty_passi.
TYPES : BEGIN OF ty_mat_ret,
          sel(1)           TYPE c,
          item_no          TYPE zgate_pass_I-item_no,
          mat_ret_date     TYPE zgate_pass_I-mat_ret_date,
          act_mat_ret_date TYPE ZMMRT_GP_RET_WMP-act_mat_ret_date,
          maktx            TYPE zgate_pass_I-maktx,
          meins            TYPE zgate_pass_I-meins,
          ret_qty          TYPE zgate_pass_I-ret_qty,
          menge            TYPE zgate_pass_I-menge,
          remqty           TYPE zgate_pass_I-remqty,
          act_qty          TYPE zgate_pass_I-act_qty,
          ret_val          TYPE zgate_pass_I-ret_val,
          val_of_mat       TYPE zgate_pass_I-val_of_mat,
          retremarks       TYPE ZMMRT_GP_RET_WMP-retemarks,
          secpassin        TYPE ZMMRT_GP_RET_WMP-secpassin,
          dcno             TYPE ZMMRT_GP_RET_WMP-dcno,
          recby            TYPE ZMMRT_GP_RET_WMP-recby,
          preby            TYPE ZMMRT_GP_RET_WMP-preby,
          retvehicleno     TYPE ZMMRT_GP_RET_WMP-retvehicleno,
          retdispatch_mode TYPE ZMMRT_GP_RET_WMP-retdispatch_mode,
          invoice          TYPE ZMMRT_GP_RET_WMP-invoice,
          matpassin        TYPE ZMMRT_GP_RET_WMP-matpassin,
          pass_year        TYPE zgate_pass_h-pass_year,
          pass_no          TYPE zgate_pass_h-pass_no,
          plant            TYPE zgate_pass_h-plant,
          pass_typ         TYPE zgate_pass_h-pass_typ,
        END OF ty_mat_ret.
DATA : i_material TYPE TABLE OF ty_passi.
DATA : w_material TYPE ty_passi.

DATA : ipo TYPE TABLE OF ty_po,wpo TYPE ty_po.

DATA : w_material_tab TYPE ty_passi.
DATA : w_mat_ret TYPE ty_mat_ret.
DATA : i_mat_ret TYPE TABLE OF ty_mat_ret.
DATA : w_mat_ret1 TYPE ty_mat_ret.
DATA : i_mat_ret_db TYPE TABLE OF ZMMRT_GP_RET_WMP."ZMMRT_GP_RET_WMP.
DATA : w_mat_ret_db TYPE ZMMRT_GP_RET_WMP.
DATA : i_gate_pass_itm TYPE TABLE OF zgate_pass_I.
DATA : w_mat_item TYPE zgate_pass_I.
DATA  w_gate_pass_hdr TYPE zgate_pass_h.
DATA  w_gate_pass1 TYPE ZMMRT_GP_RET_WMP.
DATA : i_gate_pass_itm1 TYPE TABLE OF ZMMRT_GP_RET_WMP.
DATA : w_mat_item1 TYPE ZMMRT_GP_RET_WMP.
*DATA : iauthority TYPE TABLE OF zpass_authority.
*DATA : wauthority TYPE zpass_authority.
DATA : BEGIN OF ipassin OCCURS 0,
         plant            TYPE ZMMRT_GP_RET_WMP-plant,
         act_mat_ret_date TYPE ZMMRT_GP_RET_WMP-act_mat_ret_date,
         pass_no          TYPE ZMMRT_GP_RET_WMP-pass_no,
         matepassin       TYPE ZMMRT_GP_RET_WMP-matpassin,
         party_name       TYPE zgate_pass_h-party_name,
         department       TYPE Zgate_pass_h-department,
       END OF ipassin.
DATA : BEGIN OF ipassin1 OCCURS 0,
         plant            TYPE ZMMRT_GP_RET_WMP-plant,
         act_mat_ret_date TYPE ZMMRT_GP_RET_WMP-act_mat_ret_date,
         pass_no          TYPE ZMMRT_GP_RET_WMP-pass_no,
         party_name       TYPE Zgate_pass_h-party_name,
         department       TYPE Zgate_pass_h-department,
         matepassin       TYPE ZMMRT_GP_RET_WMP-matpassin,
       END OF ipassin1.
***
DATA : ok_100 TYPE sy-ucomm.
DATA : ok_200 TYPE sy-ucomm.
DATA : ok_300 TYPE sy-ucomm.
DATA : ok_400 TYPE sy-ucomm.
DATA : ok_500 TYPE sy-ucomm.
DATA : ok_600 TYPE sy-ucomm.
DATA : ok_700 TYPE sy-ucomm.
DATA : ok_800 TYPE sy-ucomm.
DATA : ok_900 TYPE sy-ucomm.
DATA : ok_code_903 TYPE sy-ucomm, sb_bukrs TYPE bukrs.
******
DATA: g_dynnr1    TYPE sy-dynnr VALUE 400.
DATA : tcode_1 TYPE char15 VALUE 'ZEID_NRET'.
DATA : tcode_2 TYPE char10 VALUE 'ZEID_RET'.
DATA : tcode_3 TYPE char15 VALUE 'ZEID_NRET_IN'.
DATA : tcode_4 TYPE char15 VALUE 'ZEID_RET_IN'.

****
DATA:
  g_editor           TYPE REF TO cl_gui_textedit,
  g_editor_container TYPE REF TO cl_gui_custom_container,
  g_ok_code          LIKE sy-ucomm,         " return code from screen
  g_repid            LIKE sy-repid.
****FOR F4
DATA : BEGIN OF it_dept OCCURS 0,
         werks      TYPE ZPASS_DEPT_WMPL-werks,
         department TYPE ZPASS_DEPT_WMPL-department,
       END OF it_dept.
DATA : BEGIN OF ipassno OCCURS 0,
         issue_date TYPE Zgate_pass_h-issue_date,
         party_name TYPE Zgate_pass_h-party_name,
         department TYPE Zgate_pass_h-department,
         refno      TYPE Zgate_pass_h-refno,
         pass_no    TYPE Zgate_pass_h-pass_no,
       END OF ipassno.
TYPES : BEGIN OF ty_lfa1,
          party_code TYPE lifnr,
          party_name TYPE lfa1-name1,
          ort01      TYPE lfa1-ort01,
          ort02      TYPE lfa1-ort02,
          pstlz      TYPE lfa1-pstlz,
          land1      TYPE lfa1-land1,
          stras      TYPE lfa1-stras,
          telf1      TYPE lfa1-telf1,
          telfx      TYPE lfa1-telfx,
        END OF ty_lfa1.
TYPES : BEGIN OF ty_head,
          party_code      TYPE lifnr,
          party_name      TYPE lfa1-name1,
          ort01           TYPE lfa1-ort01,
          ort02           TYPE lfa1-ort02,
          pstlz           TYPE lfa1-pstlz,
          land1           TYPE lfa1-land1,
          stras           TYPE lfa1-stras,
          telf1           TYPE lfa1-telf1,
          telfx           TYPE lfa1-telfx,
          mobile          TYPE Zgate_pass_h-mobile,
          enteredby       TYPE pernr_d,
          enteredbyname   TYPE vorna,
          department      TYPE Zgate_pass_h-department,
          issued_to       TYPE Zgate_pass_h-issue_to,
          landline        TYPE Zgate_pass_h-landline,
          dispatch_mode   TYPE Zgate_pass_h-dispatch_mode,
          vehicle_no      TYPE Zgate_pass_h-vehical_no,
          dcno            TYPE Zgate_pass_h-dcno,
          dept_issue_date TYPE Zgate_pass_h-dept_issue_date,
          issue_date      TYPE Zgate_pass_h-issue_date,
          issue_time      TYPE Zgate_pass_h-issue_time,
          sezno           TYPE Zgate_pass_h-sezno,
          GP_REG_NO       type Zgate_pass_h-GP_REG_NO,
        END OF ty_head.
DATA : w_lfa1 TYPE ty_lfa1.
DATA : w_head TYPE ty_head.
TYPES : BEGIN OF ty_itm_po,
          sel(1),
          chk          TYPE mb_take_it,
          item_no      TYPE zitemnr,
          ebelp        TYPE ekpo-ebelp,
          mat_ret_date TYPE zgate_pass_I-mat_ret_date,
          matnr        TYPE matnr,
          maktx        TYPE maktx,
          menge        TYPE menge_d,
          meins        TYPE meins,
          value        TYPE dmbtr,
          currency     TYPE ekko-waers,
          mblnr        TYPE mkpf-mblnr,
          zeile        TYPE mseg-zeile,
          remarks      TYPE char50,
          anln1        TYPE anla-anln1,
          txt50        TYPE anla-txt50,
        END OF ty_itm_po.
*TYPES : BEGIN OF ty_emp,                  "Started R.Shrujan On 19.06.2014
*          empid TYPE zplantssan-empid,
*          name  TYPE zplantssan-name,
*        END OF ty_emp.
*DATA : empid      TYPE zplantssan-empid,
*       employname TYPE zplantssan-name.
"DATA : it_emp TYPE STANDARD TABLE OF ty_emp WITH HEADER LINE.
*DATA : PLANT1 TYPE ZPLANTSSAN-WERKS.      "Ended R.Shrujan On 19.06.2014
DATA : itm_po  TYPE TABLE OF ty_itm_po,witm_po TYPE ty_itm_po.
CONTROLS : tc_po TYPE TABLEVIEW USING SCREEN 0999.
DATA: t_return3 LIKE ddshretval OCCURS 0 WITH HEADER LINE.
DATA: t_return4 LIKE ddshretval OCCURS 0 WITH HEADER LINE.
DATA: t_return5 LIKE ddshretval OCCURS 0 WITH HEADER LINE.
DATA : t_return6 LIKE ddshretval OCCURS 0 WITH HEADER LINE.
DATA:i_return_tab TYPE TABLE OF ddshretval.             " F4 help for vendor/customer
DATA : git_v TYPE vrm_values.
DATA : gfl_vw LIKE LINE OF git_v.
DATA: progname      TYPE sy-repid,
      dynnum        TYPE sy-dynnr,
      dynpro_values TYPE TABLE OF dynpread,
      field_value   LIKE LINE OF dynpro_values.
DATA : dynpro_values1 TYPE TABLE OF dynpread,
       field_value1   LIKE LINE OF dynpro_values.
DATA: status_icon300 TYPE icons-text,status_icon500 TYPE icons-text,
      icon_name(30)  TYPE c,
      icon_text(60)  TYPE c.
******DATA DECLARATIONS.
DATA  g_passtyp TYPE zpasstyp.
DATA : g_retpass TYPE zpasstyp.                        "Gate pass type, NRT / RT
CONTROLS: tc04 TYPE TABLEVIEW USING SCREEN 0500.
DATA : name1(20).
DATA : name2(20).
DATA : ans(1).
DATA : name_1 TYPE Zgate_pass_h-party_name.
DATA : totlines TYPE i.
DATA : line1 TYPE i.
CONSTANTS: c_nrt(3) TYPE c VALUE 'NRT',
           c_rt(2)  TYPE c VALUE 'RT',
           c_x(1)   TYPE c VALUE 'X'.
DATA : c_objnr(2)  TYPE c VALUE '01',
       c_objnr1(2) TYPE c VALUE '01'.
DATA : c_nrobj_nrt(12)     TYPE c VALUE 'ZXX_GP_NRT',
       c_nrobj_rt(11)      TYPE c VALUE 'ZXX_GP_RT',
       c_nrobj_passin(12)  TYPE c VALUE 'ZEIDPASSIN',
       c_nrobj_nrt_in(12)  TYPE c VALUE 'ZXX_GP_NRI',
       c_nrobj_rt_in(12)   TYPE c VALUE 'ZXX_GP_RTI',
       c_nrobj_passout(12) TYPE c VALUE 'ZEIDPASOUT'.
DATA : o_nrobj_nrt(12)    TYPE c VALUE 'ZXX_OP_NRT',
       o_nrobj_rt(11)     TYPE c VALUE 'ZXX_OP_RT',
       o_nrobj_nrt_in(12) TYPE c VALUE 'ZXX_OP_NRI',
       o_nrobj_rt_in(12)  TYPE c VALUE 'ZXX_OP_RTI'.
DATA  g_nr_obj TYPE nrobj.
DATA  g_nr_obj1 TYPE nrobj.
DATA : text  TYPE char255,text1 TYPE char255,text2 TYPE char255,text3 TYPE char255.
CONSTANTS: c_line_length TYPE i VALUE 256.
TYPES: BEGIN OF mytable_line,
         line(c_line_length) TYPE c,
       END OF mytable_line.
DATA g_mytable TYPE TABLE OF mytable_line.
DATA w_mytableline TYPE mytable_line.
DATA  g_pass_no TYPE zpassnr.                           "gate Pass no.
DATA : texted(1).
DATA : pernr TYPE pa0001-pernr.
DATA : approve(1).
DATA: it_extab  TYPE slis_t_extab.
DATA: wa_extab LIKE LINE OF it_extab.
DATA: it_extab1  TYPE slis_t_extab.
DATA: wa_extab1 LIKE LINE OF it_extab.
DATA : pai500 TYPE char1.
DATA : pai300 TYPE char1.
DATA : matpassin TYPE ZMMRT_GP_RET_WMP-matpassin.
DATA : act_qty TYPE zgate_pass_I-act_qty.
DATA : ret_qty TYPE zgate_pass_I-ret_qty.
DATA : remqty TYPE zgate_pass_I-remqty.
DATA : len TYPE i.
DATA : s_in(2) TYPE c VALUE 'IN'.
DATA : s_out(3) TYPE c VALUE 'OUT'.
DATA : g_inout(3).
DATA : w_check_del TYPE ZMMRT_GP_RET_WMP.
DATA : text_icon TYPE char64.
DATA : del_act TYPE menge_d,del_rem TYPE menge_d.
DATA : del_dum TYPE menge_d.
DATA : ipassi TYPE TABLE OF zgate_pass_I.
DATA : wpassi TYPE zgate_pass_I.
DATA : materialpassin TYPE Zgate_pass_h-matpassin.
DATA : ques TYPE char64.
DATA:c_ven(1) TYPE c,
     c_sto(1) TYPE c,
     c_sec(1) TYPE c,
     c_dep(1) TYPE c,
     c_cus(1) TYPE c,
     c_tou(1) TYPE c.
DATA:p_prt      TYPE rspopname,            " Output Device
     p_print(1) TYPE c ,              " Print
     p_pre(1)   TYPE c .              " Print Preview
DATA : daysdiff TYPE days.
DATA  g_text TYPE string.
DATA  : l_flag(1).
DATA : w_cntrl  TYPE ssfctrlop.
DATA : w_output TYPE ssfcompop.
DATA : purtext(255).
DATA : purtext1(255).
DATA : purtext2(255).
DATA : purtext3(255).
DATA : dismode(20).
"DATA : dept TYPE zmaindept.
"DATA : dept_1 TYPE zmaindept.
DATA : textdel1 TYPE char255.
DATA : textdel2 TYPE char255.
DATA : textdel3 TYPE char255.
DATA : textdel4 TYPE char255.
DATA : iheader TYPE TABLE OF Zgate_pass_h.
DATA : wheader TYPE Zgate_pass_h.
DATA : fisdate(8).
DATA : year(4).
DATA : subject(255).
DATA : rettype(30).
DATA : app(1).
DATA : id TYPE pa0105-usrid_long.
DATA : valid_item .
*****DECLARATION FOR MAIL
DATA: lt_mailsubject     TYPE sodocchgi1.
*DATA: lt_mailrecipients  TYPE STANDARD TABLE OF somlrec90 WITH HEADER LINE.
DATA: lt_mailtxt         TYPE STANDARD TABLE OF soli      WITH HEADER LINE.
DATA: lt_mailrecipients  TYPE STANDARD TABLE OF somlreci1 WITH HEADER LINE.
***
DATA : ok_998 TYPE sy-ucomm,ok_999 TYPE sy-ucomm.
TYPES : BEGIN OF ty_po_head,
          waers TYPE ekko-waers,
          eindt type eket-eindt.
          INCLUDE STRUCTURE ekpo.
        TYPES : END OF ty_po_head.
TYPES : BEGIN OF ty_po_eket.
                   INCLUDE STRUCTURE eket.
        TYPES : END OF ty_po_eket.
TYPES : BEGIN OF ty_material_po.
          INCLUDE STRUCTURE zgate_pass_I.
        TYPES : END OF ty_material_po.
DATA : ipo_head TYPE TABLE OF ty_po_head,wpo_head TYPE ty_po_head.
DATA : ipo_head_tol TYPE TABLE OF ty_po_head,wpo_head_tol TYPE ty_po_head.
DATA:  Ipo_eket type table of ty_po_eket,wa_eket type ty_po_eket.
DATA : i_material_po TYPE TABLE OF ty_material_po,w_material_po TYPE ty_material_po.
DATA : w_pass TYPE Zgate_pass_h.
DATA : cnt TYPE i.
DATA: po_st_icon TYPE icons-text.
DATA : wmara TYPE mara,wt405 TYPE t405.

DATA: int_amt  TYPE wmto_s-amount, "Added by Rahul C on 06.11.2019 CTS ID: SRS 2019002588
      disp_amt TYPE wmto_s-amount.
