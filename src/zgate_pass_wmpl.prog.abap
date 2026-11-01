*&---------------------------------------------------------------------*
*& Modulpool ZGATE_PASS_WMPL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM ZGATE_PASS_WMPL.
*&---------------------------------------------------------------------*
*& Module pool       ZGATE_PASS_EID                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
INCLUDE zgate_pass_eid_f01.
*DATA : i_material TYPE TABLE OF ty_passi.
*DATA : w_material TYPE ty_passi.

LOAD-OF-PROGRAM.
  IF sy-tcode = 'ZEID_NRET'.
    ques = 'You Are Entering The NON-Returnable-Out Gatepass'.
  ELSEIF sy-tcode = tcode_2.
    ques = 'You Are Entering The Returnable-Out Gatepass'.
  ELSEIF sy-tcode = tcode_3.
    ques = 'You Are Entering The NON-Returnable-IN Gatepass'.
  ELSEIF sy-tcode = tcode_4.
    ques = 'You Are Entering The Returnable-IN Gatepass'.
  ENDIF.

  MESSAGE ques TYPE 'I' DISPLAY LIKE 'S'.
*****
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
****LOAD
*  LOAD

***
  SET PF-STATUS 'Z100'.
  IF sy-tcode = tcode_1.
    SET TITLEBAR 'Z1000'.
  ELSEIF sy-tcode = tcode_2.
    SET TITLEBAR 'Z1001'.
  ELSEIF sy-tcode = tcode_3.
    SET TITLEBAR 'Z1002'.
  ELSEIF sy-tcode = tcode_4.
    SET TITLEBAR 'Z1003'.
  ENDIF.
  CLEAR zst_gp_wmpl-plant.CLEAR zst_gp_wmpl-pass_no.CLEAR zst_gp_wmpl-pass_year.
  CLEAR zgate_pass_H.
  IF sy-tcode = tcode_1 OR sy-tcode = tcode_3.
    LOOP AT SCREEN.
      IF screen-group3 = 'NT'.
        screen-invisible  = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'Z200'.
  IF sy-tcode = tcode_1.
    SET TITLEBAR 'Z1000'.
  ELSEIF sy-tcode = tcode_2.
    IF ok_100 = 'P_CREA' OR ok_100 = 'P_DISP' OR ok_100 = 'P_DEL'.
      SET TITLEBAR 'ZN1000'.
    ELSE.
      SET TITLEBAR 'Z1001'.
    ENDIF.
  ELSEIF sy-tcode = tcode_3.
    SET TITLEBAR 'Z1002'.
  ELSEIF sy-tcode = tcode_4.
    IF ok_100 = 'P_CREA' OR ok_100 = 'P_DISP' OR ok_100 = 'P_DEL'.
      SET TITLEBAR 'ZN1003'.
    ELSE.
      SET TITLEBAR 'Z1003'.
    ENDIF.
  ENDIF.

  CLEAR w_material.REFRESH i_material.CLEAR Zgate_pass_h.
  ok_200 = ok_100.
  IF ok_200 = 'CREA'.
    LOOP AT SCREEN.
      IF screen-name = 'ZST_GP_EID-PASS_NO'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'PASS_NO'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF ok_200 <> 'CREA'.
    LOOP AT SCREEN.
      IF screen-name = 'REFNO'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZST_GP_EID-REFNO'.
        screen-invisible = 1.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF sy-tcode = tcode_1.
    g_passtyp = c_nrt.
    g_inout = s_out.
    g_retpass  = ' '.

  ELSEIF sy-tcode = tcode_2.
    g_passtyp = c_rt.
    g_inout = s_out.
    g_retpass  = c_nrt.
  ELSEIF sy-tcode = tcode_3.
    g_passtyp = c_nrt.
    g_inout = s_in.
    g_retpass  = ' '.
  ELSEIF sy-tcode = tcode_4.
    g_passtyp = c_rt.
    g_inout = s_in.
    g_retpass  = c_nrt.
  ENDIF.
*****
  CLEAR text.CLEAR text1.CLEAR text2.CLEAR text3.CLEAR texted.
  REFRESH i_material.CLEAR w_material.CLEAR w_material_tab.
  CLEAR w_lfa1.CLEAR ok_300.REFRESH i_mat_ret.REFRESH i_mat_ret_db.CLEAR w_mat_ret_db.
  CLEAR w_mat_ret.CLEAR pai500.CLEAR icon_text.CLEAR icon_name.CLEAR pai300.
  CLEAR icon_text.CLEAR icon_name.CLEAR status_icon300.CLEAR status_icon500.
  CLEAR text_icon.CLEAR w_check_del.CLEAR textdel1.CLEAR textdel2.CLEAR textdel3.
  CLEAR totlines.CLEAR approve.REFRESH it_extab.CLEAR wa_extab.CLEAR daysdiff.
***
ENDMODULE.                 " STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_200 INPUT.
  IF ok_200 = 'EXIT' OR ok_200 = 'BACK' OR ok_200 = 'CANCEL'.
    CLEAR ok_200.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.                 " EXIT_200  INPUT

*&spwizard: declaration of tablecontrol 'TC1' itself
"CONTROLS: tc1 TYPE TABLEVIEW USING SCREEN 0300.

*&spwizard: lines of tablecontrol 'TC1'
DATA:     g_tc1_lines  LIKE sy-loopc.

DATA:     ok_code LIKE sy-ucomm.
*&SPWizard: Data incl. inserted by SP Wizard. DO NOT CHANGE THIS LINE!
INCLUDE zgate_pass_eid_po .

*&spwizard: output module for tc 'TC1'. do not change this line!
*&spwizard: update lines for equivalent scrollbar
MODULE tc1_change_tc_attr OUTPUT.
  DESCRIBE TABLE i_material LINES tc1-lines.
ENDMODULE.

*&spwizard: output module for tc 'TC1'. do not change this line!
*&spwizard: get lines of tablecontrol
MODULE tc1_get_lines OUTPUT.
  g_tc1_lines = sy-loopc.
ENDMODULE.

*&spwizard: input module for tc 'TC1'. do not change this line!
*&spwizard: process user command
MODULE tc1_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'TC1'
                              'I_MATERIAL'
                              ' '
                     CHANGING ok_code.
  sy-ucomm = ok_code.
ENDMODULE.

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
FORM user_ok_tc USING    p_tc_name TYPE dynfnam
                         p_table_name
                         p_mark_name
                CHANGING p_ok      LIKE sy-ucomm.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA: l_ok     TYPE sy-ucomm,
        l_offset TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
  SEARCH p_ok FOR p_tc_name.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  l_offset = strlen( p_tc_name ) + 1.
  l_ok = p_ok+l_offset.
*&SPWIZARD: execute general and TC specific operations                 *
  CASE l_ok.
    WHEN 'INSR'.                      "insert row
      PERFORM fcode_insert_row USING    p_tc_name
                                        p_table_name.
      CLEAR p_ok.

    WHEN 'DELE'.                      "delete row
      PERFORM fcode_delete_row USING    p_tc_name
                                        p_table_name
                                        p_mark_name.
      CLEAR p_ok.

    WHEN 'P--' OR                     "top of list
         'P-'  OR                     "previous page
         'P+'  OR                     "next page
         'P++'.                       "bottom of list
      PERFORM compute_scrolling_in_tc USING p_tc_name
                                            l_ok.
      CLEAR p_ok.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
    WHEN 'MARK'.                      "mark all filled lines
      PERFORM fcode_tc_mark_lines USING p_tc_name
                                        p_table_name
                                        p_mark_name   .
      CLEAR p_ok.

    WHEN 'DMRK'.                      "demark all filled lines
      PERFORM fcode_tc_demark_lines USING p_tc_name
                                          p_table_name
                                          p_mark_name .
      CLEAR p_ok.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

  ENDCASE.

ENDFORM.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_insert_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_lines_name       LIKE feld-name.
  DATA l_selline          LIKE sy-stepl.
  DATA l_lastline         TYPE i.
  DATA l_line             TYPE i.
  DATA l_table_name       LIKE feld-name.
  FIELD-SYMBOLS <tc>                 TYPE cxtab_control.
  FIELD-SYMBOLS <table>              TYPE STANDARD TABLE.
  FIELD-SYMBOLS <lines>              TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_lines_name.
  ASSIGN (l_lines_name) TO <lines>.

*&SPWIZARD: get current line                                           *
  GET CURSOR LINE l_selline.
  IF sy-subrc <> 0.                   " append line to table
    l_selline = <tc>-lines + 1.
*&SPWIZARD: set top line                                               *
    IF l_selline > <lines>.
      <tc>-top_line = l_selline - <lines> + 1 .
    ELSE.
      <tc>-top_line = 1.
    ENDIF.
  ELSE.                               " insert line into table
    l_selline = <tc>-top_line + l_selline - 1.
    l_lastline = <tc>-top_line + <lines> - 1.
  ENDIF.
*&SPWIZARD: set new cursor line                                        *
  l_line = l_selline - <tc>-top_line + 1.

*&SPWIZARD: insert initial line                                        *
  INSERT INITIAL LINE INTO <table> INDEX l_selline.
  <tc>-lines = <tc>-lines + 1.
*&SPWIZARD: set cursor                                                 *
  SET CURSOR LINE l_line.

ENDFORM.                              " FCODE_INSERT_ROW

*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_delete_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name
                       p_mark_name   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
  DESCRIBE TABLE <table> LINES <tc>-lines.

  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    IF <mark_field> = 'X'.
      DELETE <table> INDEX syst-tabix.
      IF sy-subrc = 0.
        <tc>-lines = <tc>-lines - 1.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
FORM compute_scrolling_in_tc USING    p_tc_name
                                      p_ok.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_tc_new_top_line     TYPE i.
  DATA l_tc_name             LIKE feld-name.
  DATA l_tc_lines_name       LIKE feld-name.
  DATA l_tc_field_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <lines>      TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.
*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_tc_lines_name.
  ASSIGN (l_tc_lines_name) TO <lines>.


*&SPWIZARD: is no line filled?                                         *
  IF <tc>-lines = 0.
*&SPWIZARD: yes, ...                                                   *
    l_tc_new_top_line = 1.
  ELSE.
*&SPWIZARD: no, ...                                                    *
    CALL FUNCTION 'SCROLLING_IN_TABLE'
      EXPORTING
        entry_act      = <tc>-top_line
        entry_from     = 1
        entry_to       = <tc>-lines
        last_page_full = 'X'
        loops          = <lines>
        ok_code        = p_ok
        overlapping    = 'X'
      IMPORTING
        entry_new      = l_tc_new_top_line
      EXCEPTIONS
*       NO_ENTRY_OR_PAGE_ACT  = 01
*       NO_ENTRY_TO    = 02
*       NO_OK_CODE_OR_PAGE_GO = 03
        OTHERS         = 0.
  ENDIF.

*&SPWIZARD: get actual tc and column                                   *
  GET CURSOR FIELD l_tc_field_name
             AREA  l_tc_name.

  IF syst-subrc = 0.
    IF l_tc_name = p_tc_name.
*&SPWIZARD: et actual column                                           *
      SET CURSOR FIELD l_tc_field_name LINE 1.
    ENDIF.
  ENDIF.

*&SPWIZARD: set the new top line                                       *
  <tc>-top_line = l_tc_new_top_line.


ENDFORM.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_mark_lines USING p_tc_name
                               p_table_name
                               p_mark_name.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = 'X'.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_demark_lines USING p_tc_name
                                 p_table_name
                                 p_mark_name .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = space.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines
*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  IF ok_200 <> 'DELE'.
    wa_extab-fcode = 'DELETE'.
    APPEND wa_extab TO it_extab.
    SET PF-STATUS 'Z300' EXCLUDING it_extab.
  ELSE.
    wa_extab-fcode = 'PRINT'.
    APPEND wa_extab TO it_extab.
    SET PF-STATUS 'Z300' EXCLUDING it_extab.
  ENDIF.
  IF sy-tcode = tcode_1.
    SET TITLEBAR 'Z1000'.
  ELSEIF sy-tcode = tcode_2.
    SET TITLEBAR 'Z1001'.
  ELSEIF sy-tcode = tcode_3.
    SET TITLEBAR 'Z1002'.
  ELSEIF sy-tcode = tcode_4.
    SET TITLEBAR 'Z1003'.
  ENDIF.
  tc1-lines = 30.
ENDMODULE.                 " STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  RET_INVISIBLE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ret_invisible OUTPUT.
  IF sy-tcode = tcode_1 OR sy-tcode = tcode_3.
    LOOP AT SCREEN.
      IF screen-name = 'W_MATERIAL-MAT_RET_DATE'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.

    ENDLOOP.
  ENDIF.
***  * BCS support 16224
**
**    LOOP AT SCREEN.
**      IF SCREEN-NAME = 'ZGATE_PASS_EID-SEZ_GP_NO'.
**        SCREEN-ACTIVE = 0.
***        SCREEN-INPUT = 0.
**        SCREEN-INVISIBLE = 1.
**        MODIFY SCREEN.
**        ENDIF.
**      ENDLOOP.
**    ENDIF.
ENDMODULE.                 " RET_INVISIBLE  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_RET_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_ret_date INPUT.
  IF ok_200 = 'CREA'.
    IF sy-tcode = tcode_2 OR sy-tcode = tcode_4.
      IF w_material-mat_ret_date IS INITIAL.
        MESSAGE 'The Return Date Cannot be Empty For Returnable Gatepass' TYPE 'E'.
      ELSE.
        IF w_material-mat_ret_date < sy-datum AND zgate_pass_H-issue_date > '20110401'.
          MESSAGE 'The Expected Date Of return is Already Past' TYPE 'E'.
        ENDIF.
      ENDIF.
      IF w_material-mat_ret_date IS NOT INITIAL.
*     DAYSDIFF = W_MATERIAL-MAT_RET_DATE - SY-DATUM.
*     IF DAYSDIFF > 366.
*       MESSAGE 'You Cannot Enter The Return Date Greater Than 1 Year' TYPE 'E'.
*     ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.                 " CHECK_RET_DATE  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_MAKTX  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_maktx INPUT.
  IF w_material-maktx IS INITIAL.
    MESSAGE 'Please Enter The Material Description' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_MAKTX  INPUT
*&---------------------------------------------------------------------*
*&      Module  INT_TEXTEDITOR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE int_texteditor OUTPUT.
  g_repid = sy-repid.
  IF g_editor IS INITIAL.
    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2.
    CLEAR g_editor_container.CLEAR g_editor.
    CREATE OBJECT g_editor_container
      EXPORTING
        container_name              = 'TEXTEDITOR1'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc NE 0.
*      add your handling
    ENDIF.
    texted = 'X'.
    CREATE OBJECT g_editor
      EXPORTING
        parent                     = g_editor_container
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true
        max_number_chars           = 150
      EXCEPTIONS
        OTHERS                     = 1.
    IF sy-subrc NE 0.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel = g_repid
          txt2  = space
          txt1  = TEXT-001.
    ENDIF.
    IF sy-ucomm = 'BACK'.
      PERFORM clear_data.
    ENDIF.
  ENDIF.
  REFRESH g_mytable.CLEAR w_mytableline.

  IF ok_200 = 'DISP' OR ok_200 = 'CHAN' OR ok_100 = 'PO_DI' OR ok_100 = 'PO_CH'." AND ZGATE_PASS_EID-APPROVED_I IS NOT INITIAL ) ."OR OK_200 = 'DELE'.
*  SHIFT ZST_GP_EID-PASS_NO LEFT DELETING LEADING '0'.
**syed ON 17.06.2013
    SELECT cpurpose1 cpurpose2 cpurpose3 INTO ( text , text1 , text2 ) FROM zgate_pass_H UP TO 1 ROWS WHERE pass_no = zst_gp_wmpl-pass_no AND plant = zst_gp_wmpl-plant AND pass_typ = g_passtyp AND pass_year = zst_gp_wmpl-pass_year AND subtype =
 g_inout
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    IF text IS NOT INITIAL.
    ELSE.
**
      SELECT purpose purpose1 purpose2 purpose3 INTO ( text , text1 , text2 , text3 ) FROM zgate_pass_h
      UP TO 1 ROWS WHERE
      pass_no = zst_gp_eid-pass_no AND
      plant = zst_gp_eid-plant AND
      pass_typ = g_passtyp AND
      pass_year = zst_gp_eid-pass_year AND
      subtype = g_inout
 ORDER BY PRIMARY KEY .
      ENDSELECT.
    ENDIF.
    w_mytableline-line = text. APPEND w_mytableline TO g_mytable.
    w_mytableline-line = text1. APPEND w_mytableline TO g_mytable.
    w_mytableline-line = text2. APPEND w_mytableline TO g_mytable.
    w_mytableline-line = text3. APPEND w_mytableline TO g_mytable.
    CALL METHOD g_editor->set_text_as_r3table
      EXPORTING
        table  = g_mytable
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel = g_repid
          txt2  = space
          txt1  = TEXT-003.
    ENDIF.
    IF ( ok_200 = 'CHAN' OR ok_100 = 'PO_CH' ) AND Zgate_pass_h-approved_i IS INITIAL.
      CALL METHOD g_editor->set_focus
        EXPORTING
          control = g_editor.
      CALL METHOD g_editor->set_readonly_mode( '0' ).
    ELSE.
      CALL METHOD g_editor->set_focus
        EXPORTING
          control = g_editor.
      CALL METHOD g_editor->set_readonly_mode( '1' ).
    ENDIF.
  ELSEIF ok_200 = 'CREA' OR ok_200 = 'DELE' OR ok_100 = 'PO_CR'." OR  ( OK_200 = 'CHAN' AND Zgate_pass_h-APPROVED_I IS INITIAL ).
    CALL METHOD g_editor->set_focus
      EXPORTING
        control = g_editor.
    CALL METHOD g_editor->set_readonly_mode( '0' ).
    IF texted <> 'X'.
      PERFORM clear_data1.
    ENDIF.
  ENDIF.

ENDMODULE.                 " INT_TEXTEDITOR  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_100 INPUT.
  IF sy-ucomm = 'BACK' OR sy-ucomm = 'EXIT' OR sy-ucomm = 'CANCEL'.
    LEAVE PROGRAM.
  ENDIF.
ENDMODULE.                 " EXIT_100  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  IF ok_100 = 'CREA' .
    CALL SCREEN 200.
  ENDIF.
  IF  ok_100 = 'DISP'.
    CALL SCREEN 200.
  ENDIF.
  IF  ok_100 = 'CHAN'.
    CALL SCREEN 200.
  ENDIF.
  IF ok_100 = 'DELE'.
    CALL SCREEN 200.
  ENDIF.

  IF ok_100 = 'P_CREA'.
*AUTHORITY-CHECK OBJECT 'ZEIDPASSIN'
*                  ID 'ACTVT'  FIELD '01'
*                  ID 'PLANT' FIELD zst_gp_EID-plant.
*      IF SY-SUBRC <> 0   .
*        IF SY-TCODE = TCODE_2.
*         MESSAGE 'You Are Not Auhotirsed To Create The Passin' TYPE 'E'.
*        ELSEIF SY-TCODE = TCODE_4.
*         MESSAGE 'You Are Not Auhotirsed To Create The Passout' TYPE 'E'.
*        ENDIF.
*         ELSE.
    CALL SCREEN 200.
*      ENDIF.
  ENDIF.
*
  IF ok_100 = 'P_DISP'.
*AUTHORITY-CHECK OBJECT 'ZEIDPASSIN'
*                  ID 'ACTVT'  FIELD '03'
*                  ID 'PLANT' FIELD zst_gp_EID-plant.
*      IF SY-SUBRC <> 0   .
*        IF SY-TCODE = TCODE_2.
*         MESSAGE 'You Are Not Authorised To View The Passin' TYPE 'E'.
*        ELSEIF SY-TCODE = TCODE_4.
*         MESSAGE 'You Are Not Authorised To View The Passout' TYPE 'E'.
*        ENDIF.
*        ELSE.
    CALL SCREEN 600.
  ENDIF.
*ENDIF.
  IF ok_100 = 'P_CHAN'.
*AUTHORITY-CHECK OBJECT 'ZEIDPASSIN'
*                  ID 'ACTVT'  FIELD '02'
*                  ID 'PLANT' FIELD zst_gp_EID-plant.
*      IF SY-SUBRC <> 0   .
*        IF SY-TCODE = TCODE_2.
*         MESSAGE 'You Are Not Authorised To Change The Passin' TYPE 'E'.
*        ELSEIF SY-TCODE = TCODE_4.
*         MESSAGE 'You Are Not Authorised To Change The Passout' TYPE 'E'.
*        ENDIF.
*        ELSE.
    CALL SCREEN 600.
  ENDIF.
*ENDIF.
  IF ok_100 = 'P_DELE'.
*AUTHORITY-CHECK OBJECT 'ZEIDPASSIN'
*                  ID 'ACTVT'  FIELD '06'
*                  ID 'PLANT' FIELD zst_gp_EID-plant.
*      IF SY-SUBRC <> 0   .
*        IF SY-TCODE = TCODE_2.
*         MESSAGE 'You Are Not Auhotirsed To Delete The Passin' TYPE 'E'.
*        ELSEIF SY-TCODE = TCODE_4.
*         MESSAGE 'You Are Not Auhotirsed To Delete The Passout' TYPE 'E'.
*        ENDIF.
*       ELSE.
    CALL SCREEN 600.
  ENDIF.
*ENDIF.
***PO REFERRED
  IF ok_100 = 'PO_CR' OR ok_100 = 'PO_DI' OR ok_100 = 'PO_CH' OR ok_100 = 'PO_DE'.

    IF sy-dynnr = '0100'.
      CALL SCREEN 9000.
    ELSE.
      CALL SCREEN 998.
    ENDIF.
  ENDIF.
***
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  ok_200 = ok_100.
  CASE ok_200.
    WHEN 'CREA'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
              ID 'ACTVT'  FIELD '01'
              ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE 'You Are Not Authorised To Create The GatePass' TYPE 'E'.
      ELSE.
        IF sy-tcode = tcode_2 OR sy-tcode = tcode_1.
          CALL SCREEN 300.
        ELSEIF sy-tcode = tcode_4 OR sy-tcode = tcode_3.
          CALL SCREEN 700.
        ENDIF.
      ENDIF.
    WHEN 'DISP'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
                ID 'ACTVT'  FIELD '03'
                ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE 'You Are Not Authorised To Display The GatePass' TYPE 'E'.
      ELSE.
        SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp
           " AND ( ebeln IS NULL OR ebeln EQ ' ' ) "Ganapathi Raman P 06-08-2019
 ORDER BY PRIMARY KEY .
        ENDSELECT." EQ ' '.
        IF sy-subrc <> 0.
          MESSAGE 'The Pass Number You Have Entered Does Not Exist' TYPE 'E'.
        ELSE.
          IF sy-tcode = tcode_2 OR sy-tcode = tcode_1.
            CALL SCREEN 300.
          ELSEIF sy-tcode = tcode_4 OR sy-tcode = tcode_3.
            CALL SCREEN 700.
          ENDIF.
        ENDIF.
      ENDIF.
    WHEN 'CHAN'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
                ID 'ACTVT'  FIELD '02'
                ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE 'You Are Not Authorised To Change The GatePass' TYPE 'E'.
      ELSE.
        SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp
          " AND ( ebeln IS NULL OR ebeln EQ ' ' )  "Ganapathi Raman P 06-08-2019
 ORDER BY PRIMARY KEY .
        ENDSELECT."AND EBELN EQ ' '.
        IF sy-subrc <> 0.
          MESSAGE 'The Gate Pass Number You have Entered Does Not Exist ' TYPE 'E'.
        ELSEIF Zgate_pass_h-del_ind = 'X'.
          MESSAGE 'You Cannot Change The Deleted Gate Pass' TYPE 'E'.
        ELSE.
          IF sy-tcode = tcode_2 OR sy-tcode = tcode_1.
            CALL SCREEN 300.
          ELSEIF sy-tcode = tcode_4 OR sy-tcode = tcode_3.
            CALL SCREEN 700.
          ENDIF.
        ENDIF.
      ENDIF.
    WHEN 'DELE'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
                ID 'ACTVT'  FIELD '06'
                ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE 'You Are Not Authorised To Delete The GatePass' TYPE 'E'.
      ELSE.
        SELECT * FROM zmmtr_gp_ret_eid INTO w_check_del UP TO 1 ROWS WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout
 ORDER BY PRIMARY KEY .
        ENDSELECT." AND PASS_TYP = G_PASSTYP.
        SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp
          "AND ( ebeln IS NULL OR ebeln EQ ' ' ) "Ganapathi Raman P 06-08-2019
 ORDER BY PRIMARY KEY .
        ENDSELECT."AND EBELN EQ ' '.
        IF sy-subrc <> 0.
          MESSAGE 'The Gate Pass Number You have Entered Does Not Exist ' TYPE 'E'.
        ELSEIF Zgate_pass_h-del_ind = 'X'.
          MESSAGE 'The Gate Pass Has Already Been Deleted' TYPE 'E'.
        ELSEIF w_check_del IS NOT INITIAL.
          MESSAGE 'You Cannot Delete The Gate Pass Which Has Been Returned' TYPE 'E'.
        ELSE.
          IF sy-tcode = tcode_2 OR sy-tcode = tcode_1.
            CALL SCREEN 300.
          ELSEIF sy-tcode = tcode_4 OR sy-tcode = tcode_3.
            CALL SCREEN 700.
          ENDIF.
        ENDIF.
      ENDIF.

    WHEN 'P_CREA'.
      AUTHORITY-CHECK OBJECT 'ZEIDPASSIN'
                ID 'ACTVT'  FIELD '01'
                ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE 'You Are Not Authorised To Create The GatePass' TYPE 'E'.
      ELSE.
        SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no
 AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout
 ORDER BY PRIMARY KEY .
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE 'The Gate Pass Does Not Exist' TYPE 'E'.
        ELSEIF Zgate_pass_h-approved_i IS INITIAL.
          MESSAGE 'The Gate Pass Has Not Been Approved' TYPE 'E'.
        ELSEIF Zgate_pass_h-del_ind IS NOT INITIAL.
          MESSAGE 'The Gate Pass Has Not Been Deleted' TYPE 'E'.
        ELSE.
          IF sy-tcode = tcode_2.
            CALL SCREEN 500.
          ELSEIF sy-tcode = tcode_4.
            CALL SCREEN 900.
          ENDIF.
*           IF SY-TCODE = TCODE_2 OR SY-TCODE = TCODE_1.
*            CALL SCREEN 300.
*           ELSEIF SY-TCODE = TCODE_4 OR SY-TCODE = TCODE_3.
*             CALL SCREEN 700.
*           ENDIF.
        ENDIF.
      ENDIF.

    WHEN 'P_DISP'.
      AUTHORITY-CHECK OBJECT 'ZEIDPASSIN'
                ID 'ACTVT'  FIELD '03'
                ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE 'You Are Not Authorised To Display The GatePass' TYPE 'E'.
      ELSE.
        SELECT * FROM zmmtr_gp_ret_eid UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year
 AND matpassin = zmmtr_gp_ret_eid-matpassin AND subtype = g_inout
 ORDER BY PRIMARY KEY .
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE 'The Material Pass In Number You Have Entered Does Not Exist' TYPE 'E'.
        ELSE.
          CALL SCREEN 600.
        ENDIF.
      ENDIF.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*&      Form  CHECK_AVAILABILITY_GATE_PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_availability_gate_pass .

ENDFORM.                    " CHECK_AVAILABILITY_GATE_PASS
*&---------------------------------------------------------------------*
*&      Module  READ_TC1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE read_tc1 INPUT.
  w_material-item_no = tc1-current_line.
  MOVE-CORRESPONDING w_material TO w_material_tab.
  IF w_material_tab-matnr IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = w_material_tab-matnr
      IMPORTING
        output = w_material_tab-matnr.

    SELECT SINGLE maktx FROM makt INTO w_material_tab-maktx
                         WHERE matnr = w_material_tab-matnr AND
                               spras = sy-langu.
    SELECT SINGLE meins FROM mara INTO w_material_tab-meins WHERE matnr = w_material-matnr
                     ."AND SPRAS = SY-LANGU.
  ENDIF.

  IF w_material_tab-maktx IS INITIAL.
    MESSAGE 'Please Enter A Material Description' TYPE 'E'.
  ENDIF.
  IF w_material_tab-meins IS INITIAL.
    MESSAGE 'Please Enter The Unit Of Measurement' TYPE 'E'.
  ENDIF.
  IF sy-tcode = tcode_2 OR sy-tcode = tcode_4.
    IF w_material_tab-mat_ret_date IS NOT INITIAL .
      MODIFY i_material FROM w_material_tab INDEX tc1-current_line.
      IF sy-subrc <> 0.
        APPEND w_material_tab TO i_material.
      ENDIF.
      CLEAR w_material_tab.
    ENDIF.
  ENDIF.
  IF sy-tcode = tcode_1 OR sy-tcode = tcode_3.
    IF w_material_tab-maktx IS NOT INITIAL.
      MODIFY i_material FROM w_material_tab INDEX tc1-current_line.
      IF sy-subrc <> 0.
        APPEND w_material_tab TO i_material.
      ENDIF.
      CLEAR w_material_tab.
    ENDIF.
  ENDIF.
ENDMODULE.                 " READ_TC1  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_300 INPUT.
  IF ok_300 = 'BACK' OR ok_300 = 'EXIT' OR ok_300 = 'CANCEL'.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
*       TITLEBAR              = ' '
*       DIAGNOSE_OBJECT       = ' '
        text_question         = 'Do You  Want To Exit?'
        text_button_1         = 'Yes'(001)
*       ICON_BUTTON_1         = ' '
        text_button_2         = 'No'(002)
*       ICON_BUTTON_2         = ' '
*       DEFAULT_BUTTON        = '1'
        display_cancel_button = ' '
*       USERDEFINED_F1_HELP   = ' '
*       START_COLUMN          = 25
*       START_ROW             = 6
*       POPUP_TYPE            =
*       IV_QUICKINFO_BUTTON_1 = ' '
*       IV_QUICKINFO_BUTTON_2 = ' '
      IMPORTING
        answer                = ans
*  TABLES
*       PARAMETER             =
*  EXCEPTIONS
*       TEXT_NOT_FOUND        = 1
*       OTHERS                = 2
      .
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF ans = 1.
      LEAVE TO SCREEN 0.
    ENDIF.
  ENDIF.
ENDMODULE.                 " EXIT_300  INPUT
*&---------------------------------------------------------------------*
*&      Module  SCREEN_DISPLAY  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE screen_display OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'Zgate_pass_h-PASS_NO'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
    IF screen-name = 'Zgate_pass_h-PLANT'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
  IF ok_200 = 'DISP' OR ok_200 = 'DELE'.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.                      "karthik on 31.12.2015
      IF screen-name = 'ZGATE_PASSI_EID-EBELN'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-group1 = 'GRH'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF screen-name = 'APPROVE'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF ok_200 = 'DELE'.
    LOOP AT SCREEN.
      IF screen-name = 'APPROVE'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
            ID 'ACTVT' FIELD '10'
            ID 'PLANT' FIELD zst_gp_eid-plant.
  IF sy-subrc <> 0.
    LOOP AT SCREEN.
      IF screen-name = 'APPROVE'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF ok_200 = 'CHAN'.
    SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year
 AND plant = zst_gp_eid-plant AND subtype = g_inout AND approved_i = 'X' AND pass_typ = g_passtyp
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    IF sy-subrc = 0.
      LOOP AT SCREEN.
        IF screen-name = 'APPROVE'.
          screen-invisible = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-group1 = 'GRH'.
          screen-input = 0.
          MODIFY SCREEN.
        ENDIF.
        IF screen-group1 = 'GR1'.
          screen-input = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
* bcs support
  SELECT SINGLE bukrs
    FROM t001k
    INTO @DATA(lv_bukrs_srs)
     WHERE bwkey = @zst_gp_eid-plant.
   IF sy-subrc EQ 0.
    ENDIF.
   IF  lv_bukrs_srs NE 'SRS'. "Zgate_pass_h-PLANT ZST_GP_EID-PLANT
     LOOP AT SCREEN.
      IF screen-group1 = 'GR3'.
         screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
     ELSE.
   IF ok_200 = 'DISP' OR ok_200 = 'DELE'.
*      or ok_200 = 'CREA' OR ok_200 = 'CHAN'.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR3'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    ENDIF.
    ENDIF.
* ENDIF.
ENDMODULE.                 " SCREEN_DISPLAY  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_DEPT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_dept INPUT.
  CLEAR: field_value, dynpro_values.
  REFRESH dynpro_values.CLEAR field_value.
  field_value-fieldname = 'Zgate_pass_h-PLANT'.
  APPEND field_value TO dynpro_values.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = dynpro_values.
  READ TABLE dynpro_values INDEX 1 INTO field_value.
  SELECT werks department FROM zpass_dept_eid INTO TABLE it_dept WHERE werks = Zgate_pass_h-plant.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield    = 'Zgate_pass_h-DEPARTMENT'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'Zgate_pass_h-DEPARTMENT'
      value_org   = 'S'
    TABLES
      value_tab   = it_dept
      return_tab  = t_return3.

ENDMODULE.                 " GET_DEPT  INPUT
*&---------------------------------------------------------------------*
*&      Module  INITIALOZE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE initialoze_screen OUTPUT.
  Zgate_pass_h-plant = zst_gp_eid-plant.
  IF Zgate_pass_h-dept_issue_date IS INITIAL.
    Zgate_pass_h-dept_issue_date = sy-datum.
  ENDIF.
  IF Zgate_pass_h-issue_time IS INITIAL.
    Zgate_pass_h-issue_time = sy-uzeit.
  ENDIF.
  IF Zgate_pass_h-issue_date IS INITIAL.
    Zgate_pass_h-issue_date = sy-datum.
  ENDIF.
  IF pai300 <> 'X'.
    IF ok_200 = 'DISP' OR ok_200 = 'CHAN' OR ok_200 = 'DELE'.
      SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      IF sy-subrc = 0.
        SELECT * FROM zgate_passi_eid INTO CORRESPONDING FIELDS OF TABLE i_material WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp ORDER BY PRIMARY KEY.
        SELECT ebeln FROM zgate_passi_eid INTO (zgate_passi_eid-ebeln) UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp
 ORDER BY PRIMARY KEY .
        ENDSELECT.
        w_lfa1-party_name = Zgate_pass_h-party_name.
        w_lfa1-ort01 = Zgate_pass_h-ort01.
        w_lfa1-ort02 = Zgate_pass_h-ort02.
        w_lfa1-pstlz = Zgate_pass_h-pstlz.
        w_lfa1-land1 = Zgate_pass_h-land1.
        w_lfa1-stras = Zgate_pass_h-stras.
        w_lfa1-telf1 = Zgate_pass_h-telf1.
        w_lfa1-telfx = Zgate_pass_h-telfx.
      ENDIF.

    ENDIF.
  ENDIF.
ENDMODULE.                 " INITIALOZE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  POP_VEND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pop_vend INPUT.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = 'LFA1'
      fieldname         = 'LIFNR'
      dynpprog          = sy-cprog
      dynpnr            = sy-dynnr
      dynprofield       = 'Zgate_pass_h-PARTY_CODE'
    TABLES
      return_tab        = i_return_tab
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.                 " POP_VEND  INPUT
*&---------------------------------------------------------------------*
*&      Module  F4_PARTY  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_party INPUT.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = Zgate_pass_h-party_code
    IMPORTING
      output = Zgate_pass_h-party_code.
  IF Zgate_pass_h-party_code IS NOT INITIAL.
*Begin of Replace IBM HANATIZATION -SAU001
*  SELECT SINGLE * FROM LFM1 WHERE LIFNR = Zgate_pass_h-PARTY_CODE AND EKORG = ZST_GP_EID-PLANT.
    DATA : lv_lifnr TYPE elifn.
    SELECT SINGLE lifnr FROM lfm1 INTO lv_lifnr WHERE lifnr = Zgate_pass_h-party_code AND ekorg = zst_gp_eid-plant.
*End of Replace IBM HANATIZATION -SAU001
    IF sy-subrc = 0.
      SELECT SINGLE lifnr name1 ort01 ort02 pstlz land1 stras telf1
                          telfx FROM lfa1 INTO w_lfa1 WHERE
        lifnr = Zgate_pass_h-party_code.
    ELSE.
*Begin of Replace IBM HANATIZATION -SAU001
*       SELECT SINGLE * FROM LFM1 WHERE LIFNR = Zgate_pass_h-PARTY_CODE AND EKORG = 'SUCP'.
      CLEAR lv_lifnr.
      SELECT SINGLE lifnr FROM lfm1 INTO lv_lifnr WHERE lifnr = Zgate_pass_h-party_code AND ekorg = 'SUCP'.
*End of Replace IBM HANATIZATION -SAU001
      IF sy-subrc = 0.
        SELECT SINGLE lifnr name1 ort01 ort02 pstlz land1 stras telf1
                         telfx FROM lfa1 INTO w_lfa1 WHERE
          lifnr = Zgate_pass_h-party_code.
      ELSE.
        MESSAGE 'Please Enter A Valid Vendor Code' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.                 " F4_PARTY  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_ENTEREDBYNAME  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_enteredbyname INPUT.
  SELECT nachn vorna FROM pa0002 INTO ( name1 , name2 ) UP TO 1 ROWS WHERE pernr = Zgate_pass_h-enteredby
 ORDER BY PRIMARY KEY .
  ENDSELECT.
  IF sy-subrc = 0.
    CONCATENATE name1 name2 INTO Zgate_pass_h-enteredbyname SEPARATED BY space.
  ENDIF.
ENDMODULE.                 " GET_ENTEREDBYNAME  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_F4_MEINS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_f4_meins INPUT.
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = 'MARA'
      fieldname         = 'MEINS'
      dynpprog          = sy-cprog
      dynpnr            = sy-dynnr
      dynprofield       = 'W_MATERIAL-MEINS'
    TABLES
      return_tab        = i_return_tab
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDMODULE.                 " GET_F4_MEINS  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_DISPATCH_MODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_dispatch_mode INPUT.
  REFRESH git_v.CLEAR git_v.
  gfl_vw-key = 'A'.
  gfl_vw-text = '-By Vehicle'.
  APPEND gfl_vw TO git_v.

  gfl_vw-key = 'B'.
  gfl_vw-text = '-By Hand'.
  APPEND gfl_vw TO git_v.

  gfl_vw-key = 'C'.
  gfl_vw-text = '-By Courier'.
  APPEND gfl_vw TO git_v.

  gfl_vw-key = 'D'.
  gfl_vw-text = '- Others'.
  APPEND gfl_vw TO git_v.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'Zgate_pass_h-DISPATCH_MODE'
      values          = git_v
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

ENDMODULE.                 " GET_DISPATCH_MODE  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  pai300 = 'X'.
  CASE ok_300.
    WHEN 'SAVE'.
*     IF W_LFA1 IS INITIAL.
*       MESSAGE 'Please Enter The Vendor Details' type 'E'.
*     ENDIF.
      CLEAR ans.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
*         TITLEBAR              = ' '
          text_question         = 'Do You Want To Save ?'
          text_button_1         = 'Yes'(001)
          text_button_2         = 'No'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = ans.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF ans = 1.
* IF OK_200 = 'CREA'.
        PERFORM save_gatepass.
* ELSEIF OK_200 = 'CHAN'.
*   PERFORM UPDATE_GATEPASS.
* ENDIF.
      ENDIF.
      LEAVE TO SCREEN 0.
    WHEN 'APPR'.
      IF ok_200 = 'CREA' OR ok_200 = 'CHAN'.
        CLEAR ans.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
*           TITLEBAR              = ' '
            text_question         = 'Do You Want To Approve ?'
            text_button_1         = 'Yes'(001)
            text_button_2         = 'No'(002)
            display_cancel_button = ' '
          IMPORTING
            answer                = ans.
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
        IF ans = 1.
          approve = 'X'.
          PERFORM save_gatepass.
          MESSAGE s061 WITH Zgate_pass_h-pass_no." 'S'.
          LEAVE TO SCREEN 0.
        ENDIF.
      ENDIF.
    WHEN 'DELETE'.
      IF ok_200 = 'DELE'.
        CLEAR ans.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
*           TITLEBAR              = ' '
            text_question         = 'Do You Want To Delete ?'
            text_button_1         = 'Yes'(001)
            text_button_2         = 'No'(002)
            display_cancel_button = ' '
          IMPORTING
            answer                = ans.
        IF ans = 1.
          PERFORM delete_gatepass.
          LEAVE TO SCREEN 0.
        ENDIF.
      ENDIF.
    WHEN 'PRINT'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
               ID 'ACTVT'  FIELD '04'
               ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE e035 WITH zst_gp_eid-plant.
      ELSE.
        SELECT SINGLE * FROM Zgate_pass_h
             INTO w_gate_pass_hdr
             WHERE pass_no = Zgate_pass_h-pass_no
             AND plant = zst_gp_eid-plant
              AND pass_year = zst_gp_eid-pass_year
             AND pass_typ = g_passtyp.

        IF Zgate_pass_h-approved_i <> 'X'.
          MESSAGE e025 WITH Zgate_pass_h-pass_no.
        ELSE.
          CALL SCREEN 0800 STARTING AT 12 2 ENDING AT 100 20.
        ENDIF.
      ENDIF.

    WHEN 'DEL2'.
      DELETE i_material WHERE sel = 'X'.
      CLEAR ok_300.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*&      Form  SAVE_GATEPASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_gatepass .
  IF i_material[] IS INITIAL.
    MESSAGE 'Enter Atleast One Line Item' TYPE 'E'.
  ELSEIF totlines = 0.
    CLEAR ok_300.
    MESSAGE 'Please Enter The Purpose' TYPE 'E'.
  ELSE.
    IF approve = 'X'.
      Zgate_pass_h-approved_i = 'X'.
      Zgate_pass_h-approved_by = sy-uname.
      Zgate_pass_h-approved_date = sy-datum.
    ENDIF.
    Zgate_pass_h-purpose = text.
    Zgate_pass_h-purpose1 = text1.
    Zgate_pass_h-purpose2 = text2.
    Zgate_pass_h-purpose3 = text3.
    IF sy-tcode = tcode_1.
      Zgate_pass_h-pass_typ = c_nrt.          "'NRT'.
      g_nr_obj = c_nrobj_nrt.
*       For returnable gate pass
    ELSEIF sy-tcode =  tcode_2.
      Zgate_pass_h-pass_typ = c_rt.           "'RT'.
      g_nr_obj =  c_nrobj_rt.
    ELSEIF sy-tcode =  tcode_3.
      Zgate_pass_h-pass_typ = c_nrt.           "'RT'.
      g_nr_obj =  c_nrobj_nrt_in.
    ELSEIF sy-tcode =  tcode_4.
      Zgate_pass_h-pass_typ = c_rt.           "'RT'.
      g_nr_obj =  c_nrobj_rt_in.
    ENDIF.
    CLEAR w_material_tab.
    REFRESH i_gate_pass_itm.
    IF ok_200 = 'CREA'.
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = c_objnr
          object                  = g_nr_obj
          subobject               = Zgate_pass_h-plant
          toyear                  = zst_gp_eid-pass_year
        IMPORTING
          number                  = g_pass_no
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      Zgate_pass_h-pass_no = g_pass_no.

    ENDIF.
    Zgate_pass_h-in_out = g_retpass.
    Zgate_pass_h-subtype = g_inout.
    Zgate_pass_h-pass_year = zst_gp_eid-pass_year.
*        Zgate_pass_h-pass_no = g_pass_no.
    Zgate_pass_h-party_name = w_lfa1-party_name.
    Zgate_pass_h-ort01 = w_lfa1-ort01.
    Zgate_pass_h-ort02 = w_lfa1-ort02.
    Zgate_pass_h-pstlz = w_lfa1-pstlz.
    Zgate_pass_h-land1 = w_lfa1-land1.
    Zgate_pass_h-stras = w_lfa1-stras.
    Zgate_pass_h-telf1 = w_lfa1-telf1.
    Zgate_pass_h-telfx = w_lfa1-telfx.
    Zgate_pass_h-purpose = text.
    Zgate_pass_h-refno = zst_gp_eid-refno.
    Zgate_pass_h-created_by = sy-uname.
    Zgate_pass_h-changeddate = sy-datum.
    Zgate_pass_h-changedtime = sy-uzeit.
    Zgate_pass_h-ebeln      =  zst_gp_eid-ebeln. "Ganapathi Raman P 06-08-2019
*** bcssupport
    DATA(lv_sez_gp_no)     =  Zgate_pass_h-sez_gp_no .
    DATA(lv_sez_gp_dt)     =  Zgate_pass_h-sez_gp_dt .
    LOOP AT i_material INTO w_material_tab.
      w_mat_item-in_out = g_retpass.
      w_mat_item-subtype = g_inout.
      w_mat_item-pass_year = zst_gp_eid-pass_year.
      w_mat_item-mat_ret_date = w_material_tab-mat_ret_date.
      w_mat_item-matnr = w_material_tab-matnr.
      w_mat_item-pass_no = Zgate_pass_h-pass_no.
      w_mat_item-plant = Zgate_pass_h-plant.
      w_mat_item-pass_typ = g_passtyp.
      w_mat_item-item_no = w_material_tab-item_no.
      w_mat_item-maktx = w_material_tab-maktx.
      w_mat_item-meins = w_material_tab-meins.
      w_mat_item-menge = w_material_tab-menge.
      w_mat_item-remarks = w_material_tab-remarks.
      w_mat_item-anln1 = w_material_tab-anln1.
      w_mat_item-txt50 = w_material_tab-txt50.
      w_mat_item-value = w_material_tab-value.
      w_mat_item-val_of_mat "#EC CI_FLDEXT_OK[0002610650]
 = w_material_tab-value /
                     w_material_tab-menge.
      w_mat_item-remqty = w_material_tab-menge.
      w_mat_item-changedby = sy-uname.
      w_mat_item-changedtime = sy-uzeit.
      w_mat_item-changeddate = sy-datum.
      w_mat_item-ebeln =  zst_gp_eid-ebeln. "zgate_passi_eid-ebeln.         "karthik on 31.12.2015 "Ganapathi Raman P 06-08-2019
      APPEND w_mat_item TO i_gate_pass_itm.
      CLEAR w_mat_item.
    ENDLOOP.
    SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE pass_no = Zgate_pass_h-pass_no
 AND plant = Zgate_pass_h-plant AND pass_typ = g_passtyp AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    IF sy-subrc <> 0.
      INSERT Zgate_pass_h.
*Begin of Addition by Rahul C on 28.11.2019 CTS ID: EID 2019002701*
      LOOP AT i_gate_pass_itm INTO w_mat_item.
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input                =  w_mat_item-meins
           language             = sy-langu
         IMPORTING
           output               = w_mat_item-meins
         EXCEPTIONS
           unit_not_found       = 1
           OTHERS               = 2
                  .
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        MODIFY i_gate_pass_itm FROM w_mat_item TRANSPORTING meins.
      CLEAR w_mat_item.
      ENDLOOP.
*****************End of Addition*****************
      INSERT zgate_passi_eid FROM TABLE i_gate_pass_itm.
      IF sy-subrc = 0.
        PERFORM send_mail.
        MESSAGE s000 WITH Zgate_pass_h-pass_no.
      ENDIF.
    ELSE.
      IF approve = 'X'.
        Zgate_pass_h-approved_i = 'X'.
        Zgate_pass_h-approved_by = sy-uname.
        Zgate_pass_h-approved_date = sy-datum.
      ENDIF.
      Zgate_pass_h-purpose = text.
      Zgate_pass_h-purpose1 = text1.
      Zgate_pass_h-purpose2 = text2.
      Zgate_pass_h-purpose3 = text3.
      Zgate_pass_h-pass_year = zst_gp_eid-pass_year.
      Zgate_pass_h-in_out = g_retpass.
      Zgate_pass_h-subtype = g_inout.
*        Zgate_pass_h-pass_no = g_pass_no.
      Zgate_pass_h-party_name = w_lfa1-party_name.
      Zgate_pass_h-ort01 = w_lfa1-ort01.
      Zgate_pass_h-ort02 = w_lfa1-ort02.
      Zgate_pass_h-pstlz = w_lfa1-pstlz.
      Zgate_pass_h-land1 = w_lfa1-land1.
      Zgate_pass_h-stras = w_lfa1-stras.
      Zgate_pass_h-telf1 = w_lfa1-telf1.
      Zgate_pass_h-telfx = w_lfa1-telfx.
      Zgate_pass_h-purpose = text.
      Zgate_pass_h-created_by = sy-uname.
      Zgate_pass_h-changeddate = sy-datum.
      Zgate_pass_h-changedtime = sy-uzeit.
      Zgate_pass_h-sez_gp_no =   lv_sez_gp_no ."bcs support
      Zgate_pass_h-sez_gp_dt  =   lv_sez_gp_dt ."bcs support
      MODIFY Zgate_pass_h.
      MODIFY zgate_passi_eid FROM TABLE i_gate_pass_itm.
      IF sy-subrc = 0.
        IF approve = 'X'.
          PERFORM send_mail_approval.
        ENDIF.
        MESSAGE s005 WITH Zgate_pass_h-pass_no.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " SAVE_GATEPASS
*&---------------------------------------------------------------------*
*&      Module  ENTR_SAVE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE entr_save INPUT.
  CALL METHOD g_editor->get_text_as_r3table
    IMPORTING
      table  = g_mytable
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc NE 0.
    CALL FUNCTION 'POPUP_TO_INFORM'
      EXPORTING
        titel = g_repid
        txt2  = space
        txt1  = TEXT-003.
  ENDIF.
  LOOP AT g_mytable INTO w_mytableline.
    IF sy-tabix = 1.
      text = w_mytableline-line.
    ELSEIF sy-tabix = 2.
      text1 = w_mytableline-line.
    ELSEIF sy-tabix = 3.
      text2 = w_mytableline-line.
    ELSEIF sy-tabix = 4.
      text3 = w_mytableline-line.
    ENDIF.
  ENDLOOP.
*      READ TABLE G_MYTABLE INTO W_MYTABLELINE INDEX 1.
*      TEXT = W_MYTABLELINE-LINE.

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc NE 0.
    CALL FUNCTION 'POPUP_TO_INFORM'
      EXPORTING
        titel = g_repid
        txt2  = space
        txt1  = TEXT-002.
  ENDIF.
  DELETE g_mytable WHERE line IS INITIAL.
  DESCRIBE TABLE g_mytable LINES totlines.
  DESCRIBE TABLE i_material LINES line1.
  READ TABLE i_material INTO w_material INDEX line1.

ENDMODULE.                 " ENTR_SAVE  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_ISSUED  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_issued INPUT.
  IF Zgate_pass_h-department IS NOT INITIAL AND  Zgate_pass_h-issued_to IS INITIAL.
    MESSAGE 'Please Enter the Issued To Field' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_ISSUED  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_DISP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_disp INPUT.
  IF Zgate_pass_h-issued_to IS NOT INITIAL AND Zgate_pass_h-dispatch_mode IS INITIAL.
    MESSAGE 'Please Enter The Mode Of Dispach' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_DISP  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_DEPT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_dept INPUT.
  IF Zgate_pass_h-enteredby IS NOT INITIAL AND Zgate_pass_h-department IS INITIAL.
    MESSAGE 'Please Enter A Department' TYPE 'E'.
  ENDIF.

  IF Zgate_pass_h-department IS NOT INITIAL.
*Begin of Replace IBM HANATIZATION -SAU001
*  SELECT SINGLE * FROM ZPASS_DEPT_EID WHERE BUKRS in ('EID','AAA') AND WERKS = ZST_GP_EID-PLANT AND DEPARTMENT = ZGATE_PASS_EID-DEPARTMENT."Added AAA by Kannan S on 10/12/2018
    DATA : lv_bukrs TYPE bukrs.
    SELECT SINGLE bukrs FROM zpass_dept_eid INTO lv_bukrs WHERE bukrs IN ('EID','AAA') AND werks = zst_gp_eid-plant AND department = zgate_pass_eid-department.
*End of Replace IBM HANATIZATION -SAU001
    IF sy-subrc <> 0.
      MESSAGE 'Enter A Valid Department' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDMODULE.                 " CHECK_DEPT  INPUT
*&---------------------------------------------------------------------*
*&      Module  DISPLAY_TC1  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE display_tc1 OUTPUT.
  READ TABLE i_material INTO w_material INDEX tc1-current_line.

ENDMODULE.                 " DISPLAY_TC1  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INP_TABLE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE inp_table OUTPUT.
  IF ok_200 = 'DISP' OR ok_200 = 'DELE'.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF zgate_pass_eid-approved_i IS NOT INITIAL.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group2 = 'GRH'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMODULE.                 " INP_TABLE  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_data .
  CALL METHOD g_editor->delete_text.

ENDFORM.                    " CLEAR_DATA
*&---------------------------------------------------------------------*
*&      Module  VALID_PHNO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE valid_phno INPUT.
  IF Zgate_pass_h-landline IS NOT INITIAL.
    IF Zgate_pass_h-landline CA 'ABCDEFGHIJKLMNOQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()+?></*+'.
      MESSAGE 'Please Enter Only Numbers' TYPE 'E'.
    ENDIF.
    IF Zgate_pass_h-mobile CA 'ABCDEFGHIJKLMNOQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()+?></*-'.
      MESSAGE 'Please Enter Only Numbers' TYPE 'E'.
    ENDIF.
  ENDIF.
  IF Zgate_pass_h-dispatch_mode = 'B' AND Zgate_pass_h-mobile  IS INITIAL.
    MESSAGE 'Please Enter The Mobile Number' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " VALID_PHNO  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_VEHICLE_NO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_vehicle_no INPUT.
  IF Zgate_pass_h-dispatch_mode = 'A' AND Zgate_pass_h-vehicle_no  IS INITIAL.
    MESSAGE 'Please Enter A Vehicle Number' TYPE 'E'.
  ENDIF.

ENDMODULE.                 " CHECK_VEHICLE_NO  INPUT
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_data1 .
  CALL METHOD g_editor->delete_text.
  texted = 'X'.

ENDFORM.                    " CLEAR_DATA1
*&---------------------------------------------------------------------*
*&      Module  CHECK_QUAN_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_quan_value INPUT.
  IF w_material-menge IS INITIAL.
    MESSAGE 'Please Enter The Quantity' TYPE 'E'.
  ENDIF.
  IF w_material-value IS INITIAL AND Zgate_pass_h-issue_date > '20110405'.
    MESSAGE 'Please Enter The Value' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_QUAN_VALUE  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_ENTEREDBY  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_enteredby INPUT.
  IF Zgate_pass_h-enteredby IS NOT INITIAL AND sy-ucomm <> 'PRINT'..
    SELECT SINGLE pernr INTO pernr FROM pa0000 WHERE pernr = Zgate_pass_h-enteredby AND stat2 = '3' AND endda > sy-datum.
    IF sy-subrc <> 0.
      MESSAGE ' The Employee Number You have entered does Not exist' TYPE 'E'.
    ENDIF.
  ENDIF.
  IF Zgate_pass_h-enteredby IS INITIAL.
    MESSAGE 'Please Enter The Entered By Number' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_ENTEREDBY  INPUT
*&---------------------------------------------------------------------*
*&      Form  DELETE_GATEPASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete_gatepass .
  IF totlines = 0.
    CLEAR :ok_300,ok_999.
    MESSAGE 'Please Enter The Purpose' TYPE 'E'.
  ELSE.
    DELETE g_mytable WHERE line IS INITIAL.
    LOOP AT g_mytable INTO w_mytableline.
      IF sy-tabix = 1.
        textdel1 = w_mytableline-line.
      ELSEIF sy-tabix = 2.
        textdel2 = w_mytableline-line.
      ELSEIF sy-tabix = 3.
        textdel3 = w_mytableline-line.
      ENDIF.
    ENDLOOP.
    UPDATE Zgate_pass_h SET del_ind = 'X' deldate = sy-datum deleted_by = sy-uname cpurpose1 = textdel1 cpurpose2 = textdel2 cpurpose3 = textdel3 changedby = sy-uname WHERE pass_no = zst_gp_eid-pass_no
                  AND plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout.
    IF sy-subrc = 0.
      MESSAGE s011 WITH zst_gp_eid-pass_no.
    ENDIF.
  ENDIF.
ENDFORM.                    " DELETE_GATEPASS

*&spwizard: declaration of tablecontrol 'TC05' itself
CONTROLS: tc05 TYPE TABLEVIEW USING SCREEN 0500.

*&spwizard: lines of tablecontrol 'TC05'
DATA:     g_tc05_lines  LIKE sy-loopc.

*&spwizard: output module for tc 'TC05'. do not change this line!
*&spwizard: update lines for equivalent scrollbar
MODULE tc05_change_tc_attr OUTPUT.
  DESCRIBE TABLE i_mat_ret LINES tc05-lines.
ENDMODULE.

*&spwizard: output module for tc 'TC05'. do not change this line!
*&spwizard: get lines of tablecontrol
MODULE tc05_get_lines OUTPUT.
  g_tc05_lines = sy-loopc.
ENDMODULE.

*&spwizard: input module for tc 'TC05'. do not change this line!
*&spwizard: modify table
MODULE tc05_modify INPUT.
  IF ok_200 = 'P_CREA'.
    IF w_mat_ret-ret_qty > w_mat_ret-remqty.
      MESSAGE 'Please Enter The Returned Quantity Less Than Or Equal To The Remaining Quantity' TYPE 'E'.
    ENDIF.
*    W_MAT_RET-RET_VAL = W_MAT_RET-VAL_OF_MAT * W_MAT_RET-RET_QTY.
  ENDIF.
  MODIFY i_mat_ret
    FROM w_mat_ret
    INDEX tc05-current_line.

ENDMODULE.

*&spwizard: input module for tc 'TC05'. do not change this line!
*&spwizard: process user command
MODULE tc05_user_command INPUT.
  ok_500 = sy-ucomm.
  PERFORM user_ok_tc USING    'TC05'
                              'I_MAT_RET'
                              ' '
                     CHANGING ok_500.
  sy-ucomm = ok_500.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_500 INPUT.
  IF ok_500 = 'BACK' OR ok_500 = 'CANCEL' OR ok_500 = 'EXIT'.
    CLEAR ans.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
*       TITLEBAR              = ' '
        text_question         = 'Do You Want To EXIT ?'
        text_button_1         = 'Yes'(001)
        text_button_2         = 'No'(002)
        display_cancel_button = ' '
      IMPORTING
        answer                = ans.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF ans = 1.
      LEAVE TO SCREEN 0.
    ENDIF.
  ENDIF.
ENDMODULE.                 " EXIT_500  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0500 OUTPUT.
  IF ok_100 = 'P_DISP'.
    wa_extab1-fcode = 'SAVE'.
    APPEND wa_extab1 TO it_extab1.
    wa_extab1-fcode = 'DELETE'.
    APPEND wa_extab1 TO it_extab1.
  ELSEIF ok_100 = 'P_DELE'.
    wa_extab1-fcode = 'SAVE'.
    APPEND wa_extab1 TO it_extab1.
    wa_extab1-fcode = 'PRINT'.
    APPEND wa_extab1 TO it_extab1.
  ELSEIF ok_100 = 'P_CREA'.
    wa_extab1-fcode = 'DELETE'.
    APPEND wa_extab1 TO it_extab1.
    wa_extab1-fcode = 'PRINT'.
    APPEND wa_extab1 TO it_extab1.
  ELSEIF ok_100 = 'P_CHAN'.
    wa_extab1-fcode = 'DELETE'.
    APPEND wa_extab1 TO it_extab1.
    wa_extab1-fcode = 'PRINT'.
    APPEND wa_extab1 TO it_extab1.
    wa_extab1-fcode = 'SAVE'.
    APPEND wa_extab1 TO it_extab1.
  ENDIF.
  SET PF-STATUS 'Z500' EXCLUDING it_extab1.
  IF sy-tcode = tcode_1.
    SET TITLEBAR 'Z5000'.
  ELSEIF sy-tcode = tcode_2.
    SET TITLEBAR 'Z5001'.
  ELSEIF sy-tcode = tcode_3.
    SET TITLEBAR 'Z5002'.
  ELSEIF sy-tcode = tcode_4.
    SET TITLEBAR 'Z5003'.
  ENDIF.
  tc1-lines = 30.
*  SET TITLEBAR 'xxx'.
  tc05-lines = 50.
  IF sy-tcode = tcode_4.
    AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
            ID 'ACTVT' FIELD '10'
            ID 'PLANT' FIELD zst_gp_eid-plant.
    IF sy-subrc <> 0.
      LOOP AT SCREEN.
        IF screen-name = 'ROVE'.
          screen-invisible = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ELSEIF ok_100 <> 'P_CHAN'.
      LOOP AT SCREEN.
        IF screen-name = 'ROVE'.
          screen-invisible = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ELSE.
    LOOP AT SCREEN.
      IF screen-name = 'ROVE'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF sy-tcode = tcode_2.
    g_passtyp = c_rt.
    g_retpass = c_nrt.
    g_inout = s_out.
  ELSEIF sy-tcode = tcode_4.
    g_passtyp = c_rt.
    g_retpass = c_nrt.
    g_inout = s_in.
  ENDIF.
ENDMODULE.                 " STATUS_0500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INITIALIZE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE initialize_screen OUTPUT.
  DATA : ac_qty TYPE zmmtr_gp_ret_eid-ret_qty.
  CLEAR : ac_qty.

*  IF PAI500 <> 'X'.
  IF ok_200 = 'P_CREA'.
    IF pai500 <> 'X'.
      SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE pass_no = zst_gp_eid-pass_no AND
 plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout AND pass_typ = g_passtyp
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      SELECT item_no mat_ret_date maktx meins act_qty remarks menge remqty val_of_mat value ret_val
                  FROM zgate_passi_eid INTO CORRESPONDING FIELDS OF TABLE i_mat_ret
                  WHERE pass_no = zst_gp_eid-pass_no AND pass_year  = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant AND subtype = g_inout AND pass_typ = g_passtyp.
      SELECT * FROM zmmtr_gp_ret_eid INTO TABLE i_mat_ret_db WHERE plant = zst_gp_eid-plant
                  AND pass_year = zst_gp_eid-pass_year  AND subtype = g_inout AND pass_no = zst_gp_eid-pass_no AND del_ind <> 'X'.
      LOOP AT i_mat_ret INTO w_mat_ret." WHERE ACT_QTY > 0.
        CLEAR : ac_qty.
        LOOP AT i_mat_ret_db INTO w_mat_ret_db WHERE pass_no = zst_gp_eid-pass_no AND plant = zst_gp_eid-plant AND item_no = w_mat_ret-item_no AND pass_year = zst_gp_eid-pass_year.
          ac_qty = ac_qty + w_mat_ret_db-ret_qty.
        ENDLOOP.
        w_mat_ret-act_qty = ac_qty.
        w_mat_ret-remqty = w_mat_ret-menge - w_mat_ret-act_qty.
        w_mat_ret-ret_val "#EC CI_FLDEXT_OK[0002610650]
 = w_mat_ret-act_qty * w_mat_ret-val_of_mat.
        MODIFY i_mat_ret FROM w_mat_ret.
        CLEAR w_mat_ret.
      ENDLOOP.
      REFRESH : i_mat_ret_db.CLEAR : w_mat_ret_db.
    ENDIF.
  ENDIF.
  IF ok_100 = 'P_DISP' OR ok_100 = 'P_DELE' OR ok_100 = 'P_CHAN'.
    REFRESH i_mat_ret.CLEAR w_mat_ret.
    materialpassin = Zgate_pass_h-matpassin.
    SELECT * FROM zmmtr_gp_ret_eid INTO TABLE i_mat_ret_db WHERE plant = zst_gp_eid-plant
                AND pass_year = zst_gp_eid-pass_year AND matpassin = Zgate_pass_h-matpassin AND subtype = g_inout.

    SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE pass_no = zmmtr_gp_ret_eid-pass_no AND
 plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year AND subtype = g_inout
 ORDER BY PRIMARY KEY .
    ENDSELECT.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Information msg: CL_CI_TEST_FOR_ALL_ENTRIES - FAllRisky

*    SELECT * FROM zgate_passi_eid INTO TABLE ipassi FOR ALL ENTRIES IN i_mat_ret WHERE pass_year = zst_gp_eid-pass_year
*              AND plant = zst_gp_eid-plant AND pass_no = zmmtr_gp_ret_eid-pass_no AND pass_typ = g_passtyp
*              AND item_no = i_mat_ret-item_no AND subtype = g_inout.

IF i_mat_ret_db[] IS NOT INITIAL. "Changed I_MAT_RET to I_MAT_RET_DB in the Select query on 03.06.2020 by Rahul C CTS ID: 2020000961
  SELECT *
    FROM zgate_passi_eid
    INTO TABLE ipassi
    FOR ALL ENTRIES IN i_mat_ret_db
    WHERE pass_year = i_mat_ret_db-pass_year
      AND plant = i_mat_ret_db-plant
      AND pass_no = i_mat_ret_db-pass_no
      AND pass_typ = g_passtyp
      AND item_no = i_mat_ret_db-item_no
      AND subtype = g_inout
    ORDER BY PRIMARY KEY.
ENDIF.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
    MOVE : zmmtr_gp_ret_eid-secpassin TO Zgate_pass_h-secpassin,
           zmmtr_gp_ret_eid-invoice TO Zgate_pass_h-invoice,
           zmmtr_gp_ret_eid-dcno TO Zgate_pass_h-dcno,
           zmmtr_gp_ret_eid-recby TO Zgate_pass_h-recby,
           zmmtr_gp_ret_eid-preby TO Zgate_pass_h-preby,
           zmmtr_gp_ret_eid-retvehicleno TO Zgate_pass_h-retvehicleno,
           zmmtr_gp_ret_eid-retdispatch_mode  TO Zgate_pass_h-retdispatch_mode.
    MOVE materialpassin TO Zgate_pass_h-matpassin.
    LOOP AT i_mat_ret_db INTO w_mat_ret_db.
      MOVE-CORRESPONDING w_mat_ret_db TO w_mat_ret.
      READ TABLE ipassi INTO wpassi WITH KEY pass_year  = w_mat_ret_db-pass_year plant = w_mat_ret_db-plant
                        pass_no = w_mat_ret_db-pass_no item_no = w_mat_ret_db-item_no.
      IF sy-subrc = 0.
        w_mat_ret-mat_ret_date = wpassi-mat_ret_date.
        w_mat_ret-maktx = wpassi-maktx.
      ENDIF.
      APPEND w_mat_ret TO i_mat_ret.
      CLEAR w_mat_ret.CLEAR w_mat_ret_db.CLEAR wpassi.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " INITIALIZE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_ACT_RET_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_act_ret_date INPUT.
  IF w_mat_ret-act_mat_ret_date > sy-datum.
    MESSAGE 'Please Do Not Enter The Future Date' TYPE 'E'.
  ENDIF.
  IF w_mat_ret-act_mat_ret_date IS INITIAL AND w_mat_ret-ret_qty IS NOT INITIAL.
    MESSAGE 'Please Enter The Actual Return Date' TYPE 'E'.
  ENDIF.
  IF w_mat_ret-act_mat_ret_date IS NOT INITIAL AND w_mat_ret-act_mat_ret_date < Zgate_pass_h-approved_date." IS NOT INITIAL.
    MESSAGE 'Please Enter The Actual Return Date Greater Than Or Equal To Approved Date' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_ACT_RET_DATE  INPUT
*&---------------------------------------------------------------------*
*&      Form  APPROVE_GATEPASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM approve_gatepass .
  UPDATE Zgate_pass_h SET approved_i = 'X' approved_by = sy-uname approved_date = sy-datum
  changeddate = sy-datum changedby = sy-uname changedtime = sy-uzeit
            WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year
            AND plant = zst_gp_eid-plant AND subtype = g_inout.
ENDFORM.                    " APPROVE_GATEPASS
*&---------------------------------------------------------------------*
*&      Module  DISABLE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE disable_screen OUTPUT.
  LOOP AT SCREEN.
    IF screen-group2 = 'GR2'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
  IF ok_100 = 'P_DISP' OR ok_100 = 'P_DELE'.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF w_mat_ret-remqty  = 0.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      MODIFY i_mat_ret FROM w_mat_ret INDEX tc05-current_line.
    ENDLOOP.
  ENDIF.
ENDMODULE.                 " DISABLE_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_HEADER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_header INPUT.
  IF Zgate_pass_h-dcno IS INITIAL.
    MESSAGE 'Please Enter The Delivery Challan Number ' TYPE 'E'.
  ENDIF.
  IF Zgate_pass_h-preby IS INITIAL.
    MESSAGE 'Please Enter The Prepared By ' TYPE 'E'.
  ENDIF.
  IF Zgate_pass_h-retdispatch_mode IS INITIAL.
    MESSAGE 'Please Enter The Return Dispatch Mode ' TYPE 'E'.
  ENDIF.

  pai500 = 'X'.
ENDMODULE.                 " CHECK_HEADER  INPUT
*&---------------------------------------------------------------------*
*&      Module  GET_RETDISPATCH_MODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_retdispatch_mode INPUT.
  REFRESH git_v.CLEAR git_v.
  gfl_vw-key = 'A'.
  gfl_vw-text = '-By Vehicle'.
  APPEND gfl_vw TO git_v.

  gfl_vw-key = 'B'.
  gfl_vw-text = '-By Hand'.
  APPEND gfl_vw TO git_v.

  gfl_vw-key = 'C'.
  gfl_vw-text = '-By Courier'.
  APPEND gfl_vw TO git_v.

  gfl_vw-key = 'D'.
  gfl_vw-text = '- Others'.
  APPEND gfl_vw TO git_v.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'Zgate_pass_h-RETDISPATCH_MODE'
      values          = git_v
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

ENDMODULE.                 " GET_RETDISPATCH_MODE  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0500 INPUT.
  CASE ok_500.
    WHEN 'SAVE'.
      PERFORM save_matpassin.
      LEAVE TO SCREEN 0.

    WHEN 'DELETE'.
      CLEAR ans.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
*         TITLEBAR              = ' '
          text_question         = 'Do You Want To Delete ?'
          text_button_1         = 'Yes'(001)
          text_button_2         = 'No'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = ans.
      IF ans = 1.
        PERFORM delete_matpassin.
      ENDIF.
      LEAVE TO SCREEN 0.

    WHEN 'PRINT'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
               ID 'ACTVT'  FIELD '04'
               ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE e035 WITH zst_gp_eid-plant.
      ELSE.
*Begin of Replace IBM HANATIZATION -SAU001
*        SELECT SINGLE * FROM ZMMTR_GP_RET_EID
*             INTO W_GATE_PASS1
        DATA : lv_pass_no TYPE zpassnr.
        SELECT SINGLE pass_no FROM zmmtr_gp_ret_eid
             INTO lv_pass_no
*End of Replace IBM HANATIZATION -SAU001
             WHERE matpassin = materialpassin
             AND plant = zst_gp_eid-plant
              AND pass_year = zst_gp_eid-pass_year.
        IF sy-subrc = 0.
          IF sy-tcode = tcode_4.
            IF zmmtr_gp_ret_eid-approve IS NOT INITIAL.
              CALL SCREEN 0801 STARTING AT 12 2 ENDING AT 100 20.
            ELSE.
              MESSAGE 'The Material PassOut Has Not Been Approved' TYPE 'E'.
            ENDIF.
          ELSE.
            CALL SCREEN 0801 STARTING AT 12 2 ENDING AT 100 20.
          ENDIF.
        ELSE.

        ENDIF.
      ENDIF.
    WHEN 'ROVE'.
      IF sy-tcode = tcode_4 AND ok_500 = 'ROVE'.
        SELECT approve INTO app FROM zmmtr_gp_ret_eid UP TO 1 ROWS WHERE matpassin = materialpassin AND plant = zst_gp_eid-plant
 AND pass_year = zst_gp_eid-pass_year
 ORDER BY PRIMARY KEY .
        ENDSELECT.
        IF app IS NOT INITIAL.
          MESSAGE 'The Material Pass Out Has Already  Been Approved' TYPE 'E'.
        ELSE.
          CLEAR ans.
          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
*             TITLEBAR              = ' '
              text_question         = 'Do You Want To Save ?'
              text_button_1         = 'Yes'(001)
              text_button_2         = 'No'(002)
              display_cancel_button = ' '
            IMPORTING
              answer                = ans.
          IF ans = 1.
            UPDATE zmmtr_gp_ret_eid SET approve = 'X' WHERE matpassin = materialpassin
                  AND plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year.
            IF sy-subrc = 0.
              LOOP AT i_mat_ret_db INTO w_mat_ret_db.
                SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year
 AND pass_no = w_mat_ret_db-pass_no
 ORDER BY PRIMARY KEY .
                ENDSELECT.
                w_mat_ret_db-remqty  = w_mat_ret_db-menge - w_mat_ret_db-act_qty."W_MAT_RET_DB-REMQTY + W_MAT_RET_DB-RET_QTY.
                w_mat_ret_db-act_qty = w_mat_ret_db-menge - w_mat_ret_db-remqty.
                CLEAR act_qty .CLEAR ret_qty.CLEAR remqty.
                remqty = w_mat_ret_db-remqty."W_MAT_RET_DB-MENGE - W_MAT_RET_DB-RET_QTY - W_MAT_RET_DB-ACT_QTY.
                act_qty = w_mat_ret_db-act_qty."W_MAT_RET_DB-MENGE - REMQTY.
                UPDATE zgate_passi_eid SET remqty = remqty act_qty = act_qty subtype = g_inout in_out = g_retpass changeddate = sy-datum changedby = sy-uname changedtime = sy-uzeit WHERE pass_no = Zgate_pass_h-pass_no
                        AND pass_year  = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
                        AND item_no = w_mat_ret_db-item_no AND subtype = g_inout.

              ENDLOOP.
              MESSAGE 'The Material Passout Has Been Approved' TYPE 'S'.
              LEAVE TO SCREEN 0.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0500  INPUT
*&---------------------------------------------------------------------*
*&      Form  SAVE_MATPASSIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_matpassin .
  DELETE i_mat_ret WHERE ret_qty = 0.
  CLEAR matpassin.
  IF sy-tcode =  tcode_2.
    Zgate_pass_h-pass_typ = c_rt.           "'RT'.
    g_nr_obj =  c_nrobj_passin.
  ELSEIF sy-tcode =  tcode_4.
    Zgate_pass_h-pass_typ = c_rt.           "'RT'.
    g_nr_obj =  c_nrobj_passout.
  ENDIF.
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = c_objnr
      object                  = g_nr_obj
      subobject               = Zgate_pass_h-plant
      toyear                  = zst_gp_eid-pass_year
    IMPORTING
      number                  = matpassin
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  LOOP AT i_mat_ret INTO w_mat_ret.
    w_mat_ret-pass_year = zst_gp_eid-pass_year.
    w_mat_ret-pass_no = zst_gp_eid-pass_no.
    w_mat_ret-plant = zst_gp_eid-plant.
    w_mat_ret-pass_typ = g_passtyp.
    w_mat_ret-matpassin = matpassin.
    w_mat_ret-secpassin = Zgate_pass_h-secpassin.
    w_mat_ret-dcno = Zgate_pass_h-dcno.
    w_mat_ret-retvehicleno = Zgate_pass_h-retvehicleno.         "KARTHIK ON 11.09.2015
    w_mat_ret-recby = Zgate_pass_h-recby.
    w_mat_ret-preby = Zgate_pass_h-preby.
    w_mat_ret-invoice = Zgate_pass_h-invoice.
    w_mat_ret-retdispatch_mode = Zgate_pass_h-retdispatch_mode.
    MODIFY i_mat_ret FROM w_mat_ret.
    CLEAR w_mat_ret.
  ENDLOOP.
  LOOP AT i_mat_ret INTO w_mat_ret.
    MOVE-CORRESPONDING w_mat_ret TO w_mat_ret_db .
    w_mat_ret_db-subtype = g_inout.
    w_mat_ret_db-in_out = g_retpass.
    w_mat_ret_db-act_qty  = w_mat_ret_db-menge - w_mat_ret_db-remqty + w_mat_ret_db-ret_qty.
    w_mat_ret_db-remqty = w_mat_ret_db-menge - w_mat_ret_db-act_qty.
    w_mat_ret_db-ret_val "#EC CI_FLDEXT_OK[0002610650]
 = w_mat_ret_db-ret_qty * w_mat_ret_db-val_of_mat.
    w_mat_ret_db-approve = ' '.
    w_mat_ret_db-changeddate = sy-datum.
    w_mat_ret_db-changedby = sy-uname.
    w_mat_ret_db-changedtime = sy-uzeit.
    APPEND w_mat_ret_db TO i_mat_ret_db.
    CLEAR w_mat_ret.CLEAR w_mat_ret_db.
  ENDLOOP.
  INSERT zmmtr_gp_ret_eid FROM TABLE i_mat_ret_db.
  IF sy-subrc = 0 AND ( sy-tcode = tcode_2 OR sy-tcode = tcode_4 ).
    LOOP AT i_mat_ret_db INTO w_mat_ret_db.
      CLEAR act_qty .CLEAR ret_qty.CLEAR remqty.
      remqty = w_mat_ret_db-remqty."W_MAT_RET_DB-MENGE - W_MAT_RET_DB-RET_QTY - W_MAT_RET_DB-ACT_QTY.
      act_qty = w_mat_ret_db-act_qty."W_MAT_RET_DB-MENGE - REMQTY.
      UPDATE zgate_passi_eid SET remqty = remqty act_qty = act_qty subtype = g_inout in_out = g_retpass changeddate = sy-datum changedby = sy-uname changedtime = sy-uzeit WHERE pass_no = zst_gp_eid-pass_no
              AND pass_year  = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
              AND item_no = w_mat_ret_db-item_no AND subtype = g_inout.
    ENDLOOP.
    IF sy-tcode = tcode_2.
      MESSAGE s059 WITH matpassin..
    ELSEIF sy-tcode = tcode_4.
      MESSAGE s060 WITH matpassin.
    ENDIF.
  ELSEIF sy-subrc = 0 AND sy-tcode = tcode_4.
    MESSAGE s060 WITH matpassin.
  ENDIF.
ENDFORM.                    " SAVE_MATPASSIN
*&---------------------------------------------------------------------*
*&      Module  F4_MATPASSIN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_matpassin INPUT.
  REFRESH dynpro_values.CLEAR field_value.CLEAR matpassin.
  REFRESH dynpro_values.CLEAR field_value.  REFRESH ipassin.REFRESH ipassin1.
  field_value-fieldname = 'ZST_GP_EID-PLANT'.
  APPEND field_value TO dynpro_values.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = dynpro_values.
  READ TABLE dynpro_values INDEX 1 INTO field_value.
***FOR YEAR
  REFRESH dynpro_values1.CLEAR field_value1.CLEAR matpassin.
  REFRESH dynpro_values1.CLEAR field_value1.  REFRESH ipassin.REFRESH ipassin1.
  field_value1-fieldname = 'ZST_GP_EID-PASS_YEAR'.
  APPEND field_value1 TO dynpro_values1.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = dynpro_values1.
  READ TABLE dynpro_values1 INDEX 1 INTO field_value1.
***
**  ******
  SELECT DISTINCT plant act_mat_ret_date  pass_no matpassin FROM zmmtr_gp_ret_eid INTO TABLE ipassin WHERE plant = field_value-fieldvalue AND  subtype = g_inout AND in_out = 'NRT' AND pass_year = field_value1-fieldvalue ."AND
*DEL_IND <> 'X'." AND REVOKE1

  LOOP AT ipassin.
    CLEAR len.
    len = strlen( ipassin-matepassin ).
    IF len = 1.
      CONCATENATE '0' ipassin-matepassin INTO ipassin-matepassin.
      MODIFY ipassin TRANSPORTING matepassin.
    ENDIF.
    CLEAR ipassin.
  ENDLOOP.
  SORT ipassin ASCENDING BY matepassin ." AS TEXT."SYED0102
  CLEAR len.
  LOOP AT ipassin.
    CLEAR len.
    IF ipassin-matepassin+0(1) = '0'.
      len = strlen( ipassin-matepassin ).
      len = len - 1.
      ipassin-matepassin = ipassin-matepassin+1(len).
      MODIFY ipassin TRANSPORTING matepassin.
    ENDIF.
    CLEAR ipassin.
  ENDLOOP.
  CLEAR name_1.CLEAR dept_1.
  LOOP AT ipassin.
    CLEAR name_1.CLEAR dept_1.
    SELECT party_name department INTO ( name_1 , dept_1 ) FROM Zgate_pass_h UP TO 1 ROWS WHERE pass_no = ipassin-pass_no AND plant = field_value-fieldvalue
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    IF sy-subrc = 0.
      ipassin-department = dept_1.
      ipassin-party_name = name_1.
    ENDIF.
    MODIFY ipassin INDEX sy-tabix.
  ENDLOOP.
  LOOP AT ipassin.
    MOVE-CORRESPONDING ipassin TO ipassin1.
    APPEND ipassin1.
  ENDLOOP.
  SORT ipassin1 BY act_mat_ret_date DESCENDING matepassin DESCENDING.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield    = 'Zgate_pass_h-MATPASSIN'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'MATPASSIN'
      value_org   = 'S'
    TABLES
      value_tab   = ipassin1
      return_tab  = t_return6.

ENDMODULE.                 " F4_MATPASSIN  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0600 OUTPUT.
  SET PF-STATUS 'Z200'.
  IF sy-tcode = tcode_1.
    SET TITLEBAR 'Z1000'.
  ELSEIF sy-tcode = tcode_2.
    IF ok_100 = 'P_CREA' OR ok_100 = 'P_DISP' OR ok_100 = 'P_DEL'.
      SET TITLEBAR 'ZN1000'.
    ELSE.
      SET TITLEBAR 'Z1001'.
    ENDIF.
  ELSEIF sy-tcode = tcode_3.
    SET TITLEBAR 'Z1002'.
  ELSEIF sy-tcode = tcode_4.
    IF ok_100 = 'P_CREA' OR ok_100 = 'P_DISP' OR ok_100 = 'P_DEL'.
      SET TITLEBAR 'ZN1003'.
    ELSE.
      SET TITLEBAR 'Z1003'.
    ENDIF.
  ENDIF.

  IF sy-tcode = tcode_1.
    g_passtyp = c_nrt.
    g_inout = s_out.
    g_retpass  = ' '.

  ELSEIF sy-tcode = tcode_2.
    g_passtyp = c_rt.
    g_inout = s_out.
    g_retpass  = c_nrt.
  ELSEIF sy-tcode = tcode_3.
    g_passtyp = c_nrt.
    g_inout = s_in.
    g_retpass  = ' '.
  ELSEIF sy-tcode = tcode_4.
    g_passtyp = c_rt.
    g_inout = s_in.
    g_retpass  = c_nrt.
  ENDIF.
*****
  REFRESH it_extab1.CLEAR wa_extab1.REFRESH it_extab.CLEAR wa_extab.
  REFRESH i_mat_ret.CLEAR w_mat_ret.
ENDMODULE.                 " STATUS_0600  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_600 INPUT.
  IF ok_600 = 'EXIT' OR ok_600 = 'BACK' OR ok_600 = 'CANCEL'.
    CLEAR ans.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
*       TITLEBAR              = ' '
        text_question         = 'Do You Want To Exit ?'
        text_button_1         = 'Yes'(001)
        text_button_2         = 'No'(002)
        display_cancel_button = ' '
      IMPORTING
        answer                = ans.
    IF ans = 1.
      LEAVE TO SCREEN 0.
    ENDIF.
  ENDIF.
ENDMODULE.                 " EXIT_600  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0600 INPUT.
  IF ok_100 = 'P_DISP' OR ok_100 = 'P_DELE' OR ok_100 = 'P_CHAN'..
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = Zgate_pass_h-matpassin
      IMPORTING
        output = Zgate_pass_h-matpassin.

    SELECT * FROM zmmtr_gp_ret_eid UP TO 1 ROWS
 WHERE pass_year = zst_gp_eid-pass_year
 AND plant = zst_gp_eid-plant AND matpassin = Zgate_pass_h-matpassin AND subtype = g_inout
 ORDER BY PRIMARY KEY .
    ENDSELECT." AND PASS_TYP = G_PASSTYP.
    IF sy-subrc <> 0.
      MESSAGE 'The Material Passin Number You Have Enetered Does NOt exists' TYPE 'E'.
    ELSEIF zmmtr_gp_ret_eid-del_ind = 'X' AND ok_100 = 'P_DELE'.
      MESSAGE 'The Material passin Number You have Entered Has Already Been Deleted!!!Choose Display to View the Passin' TYPE 'E'..
    ELSE.
      IF sy-tcode = tcode_2.
        CALL SCREEN 500.
      ELSEIF sy-tcode = tcode_4.
        CALL SCREEN 900.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.                 " USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*&      Module  DISPLAY_SCREEN500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE display_screen500 OUTPUT.
  IF ok_100 = 'P_DISP' OR ok_100 = 'P_DELE' OR ok_100 = 'P_CHAN'.
    LOOP AT SCREEN.
      IF screen-group2 = 'GR2'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP   .
    IF ok_100 = 'DELE'.
      LOOP AT SCREEN.
        IF screen-name = 'ROVE'.
          screen-invisible = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF ok_100 = 'P_CREA'.
    LOOP AT SCREEN.
      IF screen-name = 'Zgate_pass_h-MATPASSIN'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'NONRET'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ROVE'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMODULE.                 " DISPLAY_SCREEN500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SHOW_ICON300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE show_icon300 OUTPUT.
  IF ok_200 = 'DISP' OR ok_200 = 'CHAN' OR ok_200 = 'DELE'.
    IF Zgate_pass_h-del_ind = 'X'.
      icon_name = 'ICON_DELETE'.
      icon_text = 'Gate Pass Deleted'.
    ELSE.
      IF Zgate_pass_h-approved_i = 'X'.
        icon_name = 'ICON_GREEN_LIGHT'.
        icon_text = 'Gate Pass Approved'.
      ELSE.
        icon_name = 'ICON_RED_LIGHT'.
        icon_text = 'Gate Pass Not Approved'.
      ENDIF.
    ENDIF.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = icon_name
        info   = icon_text
        text   = icon_text
      IMPORTING
        result = status_icon300.

  ENDIF.

ENDMODULE.                 " SHOW_ICON300  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  UPDATE_GATEPASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_gatepass .

ENDFORM.                    " UPDATE_GATEPASS
*&---------------------------------------------------------------------*
*&      Module  F4_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_date INPUT.
  CALL FUNCTION 'F4_DATE'
    EXPORTING
      date_for_first_month         = sy-datum
    IMPORTING
      select_date                  = w_material-mat_ret_date
    EXCEPTIONS
      calendar_buffer_not_loadable = 1
      date_after_range             = 2
      date_before_range            = 3
      date_invalid                 = 4
      factory_calendar_not_found   = 5
      holiday_calendar_not_found   = 6
      parameter_conflict           = 7
      OTHERS                       = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDMODULE.                 " F4_DATE  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_DEPARTMENT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_department INPUT.
*Begin of Replace IBM HANATIZATION -SAU001
*SELECT SINGLE * FROM ZPASS_DEPT_EID WHERE BUKRS in ('EID','AAA') AND WERKS = ZST_GP_EID-PLANT."Added AAA by Kannan S on 10/12/2018
  DATA : lv_bukrs1 TYPE bukrs.
  SELECT SINGLE bukrs FROM zpass_dept_eid INTO lv_bukrs1 WHERE bukrs IN ('EID','AAA') AND werks = zst_gp_eid-plant.
*End of Replace IBM HANATIZATION -SAU001
  IF sy-subrc <> 0.
    MESSAGE 'Enter A Valid Department' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_DEPARTMENT  INPUT
*&---------------------------------------------------------------------*
*&      Module  SHOW_ICON_500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE show_icon_500 OUTPUT.
  IF ok_100 <> 'P_CREA'.
    IF sy-tcode = tcode_2.
      text_icon = 'Status-'.
    ELSEIF sy-tcode = tcode_4.
      text_icon = 'Status-'.
    ENDIF.
    IF zmmtr_gp_ret_eid-del_ind  <> 'X'.
      icon_name = 'ICON_LED_GREEN'.
      CONCATENATE text_icon 'Is Active' INTO text_icon.
      icon_text = text_icon.
    ELSE.
      icon_name = 'ICON_DELETE'.
      CONCATENATE text_icon 'Has Been Deleted' INTO text_icon.

      icon_text = text_icon.
    ENDIF.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = icon_name
        info   = icon_text
        text   = icon_text
      IMPORTING
        result = status_icon500.
  ELSE.
    LOOP AT SCREEN.
      IF screen-name = 'STATUS_ICON500'.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMODULE.                 " SHOW_ICON_500  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  DELETE_MATPASSIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete_matpassin .
  UPDATE zmmtr_gp_ret_eid SET del_ind = 'X' passindeluserid = sy-uname deletedat = sy-uzeit
                deletedon = sy-datum WHERE matpassin = materialpassin AND pass_year = zst_gp_eid-pass_year
                     AND  plant = zst_gp_eid-plant AND subtype = g_inout AND in_out = g_retpass.
  IF sy-subrc = 0.
    LOOP AT i_mat_ret INTO w_mat_ret.
      CLEAR del_dum.CLEAR del_act.CLEAR del_rem.
*Begin of Replace IBM HANATIZATION -SAU001
*           SELECT SINGLE * FROM ZGATE_PASSI_EID WHERE PASS_NO = W_MAT_RET-PASS_NO AND PASS_YEAR = ZST_GP_EID-PASS_YEAR
      DATA : lv_act_qty TYPE menge_d.
      SELECT SINGLE act_qty FROM zgate_passi_eid INTO lv_act_qty WHERE pass_no = w_mat_ret-pass_no AND pass_year = zst_gp_eid-pass_year
*End of Replace IBM HANATIZATION -SAU001
             AND plant = zst_gp_eid-plant AND pass_typ = g_passtyp AND subtype = g_inout AND in_out = g_retpass AND item_no = w_mat_ret-item_no.
*Begin of Replace IBM HANATIZATION -SAU001
*                    DEL_REM = ZGATE_PASSI_EID-ACT_QTY - W_MAT_RET-RET_QTY." - W_MAT_RET-ACT_QTY.
      del_rem = lv_act_qty - w_mat_ret-ret_qty." - W_MAT_RET-ACT_QTY.
*End of Replace IBM HANATIZATION -SAU001
      del_act = w_mat_ret-menge - del_rem.
      UPDATE zgate_passi_eid SET act_qty = del_act remqty = del_rem changeddate = sy-datum changedby = sy-uname
                 changedtime = sy-uzeit WHERE pass_no = w_mat_ret-pass_no AND pass_year = zst_gp_eid-pass_year AND
                 plant = zst_gp_eid-plant AND item_no = w_mat_ret-item_no AND subtype = g_inout
                                            AND in_out = g_retpass.
    ENDLOOP.
    IF sy-tcode = tcode_2.
      MESSAGE 'The Material Passin Number Has Been Deleted' TYPE 'S'.
    ELSEIF sy-tcode = tcode_4.
      MESSAGE 'The Material Passout Number Has Been Deleted' TYPE 'S'.
    ENDIF.
  ENDIF.

ENDFORM.                    " DELETE_MATPASSIN
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PLANT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_plant INPUT.
  SELECT SINGLE * FROM t001w WHERE werks = zst_gp_eid-plant.
  IF sy-subrc <> 0.
    MESSAGE 'The Plant Does Not Exist' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " VALIDATE_PLANT  INPUT
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PASS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_pass INPUT.
  IF ok_100 = 'CHAN' OR ok_100 = 'DISP' OR ok_100 = 'DELE' OR ok_100 = 'P_CREA'.
    IF zst_gp_eid-pass_no IS INITIAL.
      MESSAGE 'Please Enter The Gate pass Number ' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDMODULE.                 " VALIDATE_PASS  INPUT
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_MATPASSIN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_matpassin INPUT.
  IF Zgate_pass_h-matpassin IS INITIAL.
    MESSAGE 'Please Enter The Material Pass Number' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " VALIDATE_MATPASSIN  INPUT
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_YEAR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_year INPUT.
  DATA : mon TYPE month,yr TYPE gjahr,yr1 TYPE gjahr.
  IF zst_gp_eid-pass_year IS INITIAL.
    MESSAGE 'Please Enter The Year' TYPE 'E'.
  ENDIF.
  IF zst_gp_eid-pass_year IS NOT INITIAL.
*CALL FUNCTION 'GM_GET_FISCAL_YEAR'
*  EXPORTING
*   I_DATE                           = SY-DATUM
*    I_FYV                           = 'V3'
* IMPORTING
*   E_FY                             = YEAR
* EXCEPTIONS
*   FISCAL_YEAR_DOES_NOT_EXIST       = 1
*   NOT_DEFINED_FOR_DATE             = 2
*   OTHERS                           = 3
*          .
    yr = sy-datum+0(4) . mon = sy-datum+4(2) .
    CALL FUNCTION 'ZSY_MON_FISCAL'
      EXPORTING
        month    = mon
        year     = yr
      IMPORTING
*       OUT_MONTH =
        out_year = yr1.
    year = yr1.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF year <> zst_gp_eid-pass_year .
      MESSAGE 'Year entered belongs to previous calendar year ' TYPE 'W'.
    ENDIF.
  ENDIF.
ENDMODULE.                 " VALIDATE_YEAR  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0903  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0903 OUTPUT.
  SET PF-STATUS 'GP_PRINT'.
*  SET TITLEBAR 'xxx'.
  tsp03-padest = 'ZLOCAL'.
ENDMODULE.                 " STATUS_0903  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_0903  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0903 INPUT.
  IF ok_code_903 = 'CANCEL'.
    CLEAR:c_ven,c_sec,c_sto,c_dep,c_cus.
    CLEAR:p_prt,p_print,p_pre.
    CLEAR tsp03.
    CLEAR ok_code_903.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.                 " EXIT_0903  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0903  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0903 INPUT.
  DATA : scno TYPE char5.
  CASE ok_code_903.
    WHEN 'PRINT' .
      w_output-tddest    = tsp03-padest.
      w_output-tdimmed   = p_print.
      w_cntrl-no_dialog = 'X'.
      w_cntrl-preview   = p_pre.
      w_cntrl-device    = 'PRINTER'.
      w_cntrl-langu     = sy-langu.
      IMPORT scno FROM MEMORY ID 'SCREEN'.
      IF scno = '9001'.
        g_inout = 'OUT'.
      ENDIF.
      PERFORM get_print_data.
      IF c_ven = c_x.
        g_text = 'Vendor Copy'(008).
        PERFORM print_gate_pass.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_sto = c_x.
        g_text = 'Stores Copy'(009).
        PERFORM print_gate_pass.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_sec = c_x.
        g_text = 'Security Copy'(010).
        PERFORM print_gate_pass.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.



      IF c_dep = c_x.
        g_text = 'Department Copy'(011).
        PERFORM print_gate_pass.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_tou = c_x.
        g_text = 'Transporter Copy'(014).
        PERFORM print_gate_pass.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_cus = c_x.
        g_text = 'Customer Copy'(012).
        PERFORM print_gate_pass.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.
      IF p_print = c_x.
        CLEAR:c_ven,c_sec,c_sto,c_dep.
        CLEAR:p_prt,p_print,p_pre.
        CLEAR tsp03.
        CLEAR ok_code_903.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN 'CANCEL'.
      CLEAR:c_ven,c_sec,c_sto,c_dep.
      CLEAR:p_prt,p_print,p_pre.
      CLEAR tsp03.
      CLEAR ok_code_903.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0903  INPUT
*&---------------------------------------------------------------------*
*&      Form  GET_PRINT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_print_data .
  REFRESH i_gate_pass_itm.
  SELECT SINGLE * FROM Zgate_pass_h INTO w_gate_pass_hdr WHERE plant = zst_gp_eid-plant AND
    pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND in_out = g_retpass
          AND subtype = g_inout AND pass_typ = g_passtyp.
  IF Zgate_pass_h-approved_i <> 'X' ."OR ZGATE_PASS_CFL-APPROVED_II <> c_x.
    MESSAGE e025 WITH Zgate_pass_h-pass_no.
    LEAVE TO SCREEN 0200.
  ELSE.
    SELECT * FROM zgate_passi_eid INTO TABLE i_gate_pass_itm WHERE plant = zst_gp_eid-plant
            AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND pass_typ = g_passtyp
      AND in_out = g_retpass AND subtype = g_inout.
  ENDIF.
ENDFORM.                    " GET_PRINT_DATA
*&---------------------------------------------------------------------*
*&      Form  PRINT_GATE_PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_gate_pass .
  DATA  g_fm_name TYPE  rs38l_fnam.                       "Smartform name
  DATA : fname TYPE tdsfname.
  IF ok_100 = 'PO_DI'.
    fname =  'ZFORM_MM_GATE_PASS_EID_PO'.
  ELSE.
    fname =  'ZFORM_MM_GATE_PASS_EID'.
  ENDIF.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = fname "'ZFORM_MM_GATE_PASS_EID'"ZFORM_MM_GATE_PASS'
    IMPORTING
      fm_name            = g_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  LOOP AT i_gate_pass_itm INTO w_mat_item.

    SHIFT w_mat_item-pass_no LEFT DELETING LEADING '0'.
    SHIFT w_mat_item-item_no LEFT DELETING LEADING '0'.
    SHIFT w_mat_item-matnr LEFT DELETING LEADING '0'.
    MODIFY i_gate_pass_itm FROM w_mat_item.
  ENDLOOP.
  CONCATENATE w_gate_pass_hdr-purpose w_gate_pass_hdr-purpose1 w_gate_pass_hdr-purpose2 INTO purtext SEPARATED BY space.
  purtext = w_gate_pass_hdr-purpose.
  purtext1 = w_gate_pass_hdr-purpose1.
  purtext2 = w_gate_pass_hdr-purpose2.
  purtext3 = w_gate_pass_hdr-purpose3.
  SHIFT w_gate_pass_hdr-pass_no LEFT DELETING LEADING '0'.
  dismode = Zgate_pass_h-dispatch_mode.
  dept = Zgate_pass_h-department.

  " Added by G.Sureshbalaji on 18.04.2017
  SELECT SINGLE bukrs FROM t001k INTO sb_bukrs WHERE bwkey = w_gate_pass_hdr-plant.
  SELECT SINGLE kverm FROM lfb1 INTO w_gate_pass_hdr-j_1ipanno WHERE lifnr = w_gate_pass_hdr-party_code AND bukrs = sb_bukrs.
  " Added by G.Sureshbalaji on 18.04.2017


  CALL FUNCTION g_fm_name
    EXPORTING
      control_parameters = w_cntrl
      output_options     = w_output
      i_gate_pass_h      = w_gate_pass_hdr
      i_text             = g_text
      purtext            = purtext
      purtext1           = purtext1
      purtext2           = purtext2
      purtext3           = purtext3
      dept               = dept
      g_inout            = g_inout
      user_settings      = ' '
    TABLES
      i_gate_pass_i      = i_gate_pass_itm
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " PRINT_GATE_PASS
*&---------------------------------------------------------------------*
*&      Module  GET_ASSET_NO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_asset_no INPUT.
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = 'ANLA'
      fieldname         = 'ANLN1'
      dynpprog          = sy-cprog
      dynpnr            = sy-dynnr
      dynprofield       = 'W_MATERIAL-ANLN1'
    TABLES
      return_tab        = i_return_tab
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDMODULE.                 " GET_ASSET_NO  INPUT
*&---------------------------------------------------------------------*
*&      Module  F4_PASS_NO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_pass_no INPUT.
  CLEAR: field_value, dynpro_values.
  REFRESH dynpro_values.CLEAR field_value.REFRESH t_return3.
  field_value-fieldname = 'ZST_GP_EID-PLANT'.
  APPEND field_value TO dynpro_values.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = dynpro_values.
  READ TABLE dynpro_values INDEX 1 INTO field_value.
  REFRESH dynpro_values1.CLEAR field_value1.
  field_value1-fieldname = 'ZST_GP_EID-PASS_YEAR'.
  APPEND field_value1 TO dynpro_values1.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = dynpro_values1.
  READ TABLE dynpro_values1 INDEX 1 INTO field_value1.

  SELECT issue_date party_name department refno pass_no  FROM Zgate_pass_h INTO TABLE ipassno WHERE plant = field_value-fieldvalue AND pass_year = field_value1-fieldvalue AND pass_typ = g_passtyp
          AND subtype = g_inout AND in_out = g_retpass.
  SORT ipassno BY issue_date DESCENDING pass_no DESCENDING.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield    = 'ZST_GP_EID-PASS_NO'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'ZST_GP_EID-PASS_NO'
      value_org   = 'S'
    TABLES
      value_tab   = ipassno
      return_tab  = t_return3.
ENDMODULE.                 " F4_PASS_NO  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_TELNO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_telno INPUT.
  IF w_lfa1-telf1 CA 'ABCDEFGHIJKLMNOQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()+?></*'.
    MESSAGE 'Please Enter Only Numbers' TYPE 'E'.
  ENDIF.
ENDMODULE.                 " CHECK_TELNO  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_PARTY_NAME  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_party_name INPUT.
  IF ok_100 = 'CREA'.
    IF w_lfa1-party_name IS INITIAL.
      MESSAGE 'Please Enter The Vendor Details' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDMODULE.                 " CHECK_PARTY_NAME  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.
  IF sy-ucomm = 'BACK' OR sy-ucomm = 'CANCEL' OR sy-ucomm = 'EXIT'.
    IF NOT g_editor IS INITIAL.
      CALL METHOD g_editor->free
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        CALL FUNCTION 'POPUP_TO_INFORM'
          EXPORTING
            titel = g_repid
            txt2  = space
            txt1  = TEXT-005.
      ENDIF.
*   free ABAP object also
      FREE g_editor.
    ENDIF.


* destroy container
    IF NOT g_editor_container IS INITIAL.
      CALL METHOD g_editor_container->free
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc <> 0.
*         MESSAGE E002 WITH F_RETURN.
      ENDIF.
*   free ABAP object also
      FREE g_editor_container.
    ENDIF.
  ENDIF.
ENDMODULE.                 " USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*&      Form  PRINT_GATEPASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_gatepass .

ENDFORM.                    " PRINT_GATEPASS
*&---------------------------------------------------------------------*
*&      Form  GET_PRINT_DATA_PASSIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_print_data_passin .
  SELECT * FROM zmmtr_gp_ret_eid INTO TABLE i_gate_pass_itm1 WHERE plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year
        AND matpassin = materialpassin.
  IF sy-subrc = 0.
    SELECT * FROM Zgate_pass_h INTO w_gate_pass_hdr UP TO 1 ROWS WHERE plant = zst_gp_eid-plant AND pass_no = zmmtr_gp_ret_eid-pass_no
 AND pass_year = zst_gp_eid-pass_year
 ORDER BY PRIMARY KEY .
    ENDSELECT.
  ENDIF.
ENDFORM.                    " GET_PRINT_DATA_PASSIN
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_801  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_801 INPUT.
  CASE ok_code_903.
    WHEN 'PRINT'.
      w_output-tddest    = tsp03-padest.
      w_output-tdimmed   = p_print.
      w_cntrl-no_dialog = 'X'.
      w_cntrl-preview   = p_pre.
      w_cntrl-device    = 'PRINTER'.
      w_cntrl-langu     = sy-langu.
      PERFORM get_print_data_passin.

      IF c_ven = c_x.
        g_text = 'Vendor Copy'(008).
        PERFORM print_gate_pass_in.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_sto = c_x.
        g_text = 'Stores Copy'(009).
        PERFORM print_gate_pass_in.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_sec = c_x.
        g_text = 'Security Copy'(010).
        PERFORM print_gate_pass_in.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.



      IF c_dep = c_x.
        g_text = 'Department Copy'(011).
        PERFORM print_gate_pass_in.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_tou = c_x.
        g_text = 'Transporter Copy'(014).
        PERFORM print_gate_pass_in.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.

      IF c_cus = c_x.
        g_text = 'Customer Copy'(012).
        PERFORM print_gate_pass_in.
        CLEAR g_text.
        l_flag = 1.
      ENDIF.
      IF p_print = c_x.
        CLEAR:c_ven,c_sec,c_sto,c_dep.
        CLEAR:p_prt,p_print,p_pre.
        CLEAR tsp03.
        CLEAR ok_code_903.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN 'CANCEL'.
      CLEAR:c_ven,c_sec,c_sto,c_dep.
      CLEAR:p_prt,p_print,p_pre.
      CLEAR tsp03.
      CLEAR ok_code_903.CLEAR ok_100.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_801  INPUT
*&---------------------------------------------------------------------*
*&      Form  PRINT_GATE_PASS_IN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_gate_pass_in .
  DATA  g_fm_name TYPE  rs38l_fnam.                       "Smartform name
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZFORM_MM_GATE_PASS_EID_PASSIN' "ZFORM_MM_GATE_PASS'
    IMPORTING
      fm_name            = g_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  LOOP AT i_gate_pass_itm1 INTO w_mat_item1.

    SHIFT w_mat_item-pass_no LEFT DELETING LEADING '0'.
    SHIFT w_mat_item-item_no LEFT DELETING LEADING '0'.
*    SHIFT W_MAT_ITEM1-MATNR LEFT DELETING LEADING '0'.
    MODIFY i_gate_pass_itm1 FROM w_mat_item1.
  ENDLOOP.
  CONCATENATE w_gate_pass_hdr-purpose w_gate_pass_hdr-purpose1 w_gate_pass_hdr-purpose2 INTO purtext SEPARATED BY space.
  purtext = w_gate_pass_hdr-purpose.
  purtext1 = w_gate_pass_hdr-purpose1.
  purtext2 = w_gate_pass_hdr-purpose2.
  purtext3 = w_gate_pass_hdr-purpose3.
  SHIFT w_gate_pass_hdr-pass_no LEFT DELETING LEADING '0'.
*  DISMODE = Zgate_pass_h-dispatch_mode.
*  DEPT = Zgate_pass_h-DEPARTMENT.
  CALL FUNCTION g_fm_name
    EXPORTING
      control_parameters = w_cntrl
      output_options     = w_output
      i_gate_pass_h      = w_gate_pass_hdr
      i_text             = g_text
      purtext            = purtext
      purtext1           = purtext1
      purtext2           = purtext2
      purtext3           = purtext3
      dept               = dept
      g_inout            = g_inout
      materialpassin     = materialpassin
      mode               = w_mat_item1-retdispatch_mode
      user_settings      = ' '
    TABLES
      i_gate_pass_i      = i_gate_pass_itm1
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " PRINT_GATE_PASS_IN
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_mail .
  CLEAR rettype.
  SELECT * FROM zpass_authority INTO TABLE iauthority WHERE werks = zst_gp_eid-plant AND usrtype = 'PH' .
  IF sy-subrc = 0.
    LOOP AT iauthority INTO wauthority.
      lt_mailrecipients-rec_type  = 'U'.
      lt_mailrecipients-receiver = wauthority-emailid.
      APPEND lt_mailrecipients .
      CLEAR lt_mailrecipients .CLEAR wauthority.
    ENDLOOP.
    IF zst_gp_eid-plant = 'EHO'.
      lt_mailrecipients-rec_type  = 'U'.
      lt_mailrecipients-copy = 'X'.
      lt_mailrecipients-receiver = 'meenakshisundaram@parry.murugappa.com'.
      APPEND lt_mailrecipients .
      lt_mailrecipients-rec_type  = 'U'.
      lt_mailrecipients-copy = 'X'.
      lt_mailrecipients-receiver = 'sathishkumarr@parry.murugappa.com'.
      APPEND lt_mailrecipients   .
    ENDIF.
***RET TYPE
    IF sy-tcode = tcode_1.
      rettype = 'Non-Returnable'.
    ELSEIF sy-tcode = tcode_2.
      rettype = 'Returnable'.
    ELSEIF sy-tcode = tcode_3.
      rettype = 'Non-Returnable'.
    ELSEIF sy-tcode = tcode_4.
      rettype = 'Returnable'.
    ENDIF.
***
    CONCATENATE 'The Gatepass Number ' g_pass_no rettype '-' g_inout 'Has Been Created and is eligible for Approval' INTO subject SEPARATED BY space.
    lt_mailsubject-obj_name = 'Gatepass'.
    lt_mailsubject-obj_langu = sy-langu.
    lt_mailsubject-obj_descr = 'Gatepass Created'.
    lt_mailtxt = subject.
    APPEND lt_mailtxt. CLEAR lt_mailtxt.
    CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = lt_mailsubject
      TABLES
        object_content             = lt_mailtxt
        receivers                  = lt_mailrecipients
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.
    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.
  ENDIF.

ENDFORM.                    " SEND_MAIL
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL_APPROVAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_mail_approval .
  CLEAR id.
  SELECT usrid_long FROM pa0105 INTO id UP TO 1 ROWS WHERE pernr = Zgate_pass_h-enteredby
 AND endda >= sy-datum AND usrid_long > ''
 ORDER BY PRIMARY KEY .
  ENDSELECT.
  IF sy-subrc = 0.
    SELECT * FROM zpass_authority INTO TABLE iauthority WHERE werks = zst_gp_eid-plant
            AND usrtype = 'CO'.
    IF sy-subrc = 0.
      lt_mailrecipients-rec_type  = 'U'.
      lt_mailrecipients-receiver = id.
      APPEND lt_mailrecipients .
      CLEAR lt_mailrecipients .CLEAR wauthority.
      LOOP AT iauthority INTO wauthority.
        lt_mailrecipients-rec_type  = 'U'.
        lt_mailrecipients-receiver = wauthority-emailid.
        lt_mailrecipients-copy = 'X'.
        APPEND lt_mailrecipients .
        CLEAR lt_mailrecipients .CLEAR wauthority.
      ENDLOOP.
    ENDIF.
    CONCATENATE 'The Gatepass Number ' g_pass_no rettype '-' g_inout 'Has Been Approved by' sy-uname 'ID' INTO subject SEPARATED BY space.
    lt_mailsubject-obj_name = 'Gatepass'.
    lt_mailsubject-obj_langu = sy-langu.
    lt_mailsubject-obj_descr = 'Gatepass Approved'.
    lt_mailtxt = subject.
    APPEND lt_mailtxt. CLEAR lt_mailtxt.
    CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = lt_mailsubject
      TABLES
        object_content             = lt_mailtxt
        receivers                  = lt_mailrecipients
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.
    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.
  ENDIF.
ENDFORM.                    " SEND_MAIL_APPROVAL

INCLUDE Zgate_pass_h_status_po_entry.

INCLUDE Zgate_pass_h_status_po_item.



*  CLEAR : EMPID,W_HEAD-ENTEREDBY.
* CLEAR: FIELD_VALUE, DYNPRO_VALUES.
*  REFRESH DYNPRO_VALUES.CLEAR FIELD_VALUE.
*  FIELD_VALUE-FIELDNAME = 'EMPID'.
*  APPEND FIELD_VALUE TO DYNPRO_VALUES.
*  CALL FUNCTION 'DYNP_VALUES_READ'
*    EXPORTING
*      DYNAME             = SY-CPROG
*      DYNUMB             = SY-DYNNR
*      TRANSLATE_TO_UPPER = 'X'
*    TABLES
*      DYNPFIELDS         = DYNPRO_VALUES.
*  READ TABLE DYNPRO_VALUES INDEX 1 INTO FIELD_VALUE.
* SELECT EMPID NAME FROM ZPLANTSSAN INTO CORRESPONDING FIELDS OF TABLE IT_EMP.
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      RETFIELD    = 'EMPID'
*      DYNPPROG    = SY-REPID
*      DYNPNR      = SY-DYNNR
*      DYNPROFIELD = 'EMPID'
*      VALUE_ORG   = 'S'
*    TABLES
*      VALUE_TAB   = IT_EMP
*      RETURN_TAB  = T_RETURN3.
*
*
**      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
**    EXPORTING
**      RETFIELD    = 'EMPID'
**      DYNPPROG    = SY-REPID
**      DYNPNR      = SY-DYNNR
**      DYNPROFIELD = 'EMPID'
**      VALUE_ORG   = 'S'
**    TABLES
**      VALUE_TAB   = IT_EMP
**      RETURN_TAB  = T_RETURN3.
*
**     READ TABLE IT_EMP INDEX SY-TABIX.
*
**
**     CALL FUNCTION 'POPUP_WITH_TABLE_DISPLAY'
**       EXPORTING
**         ENDPOS_COL         = 30
**         ENDPOS_ROW         = 30
**         STARTPOS_COL       = 1
**         STARTPOS_ROW       = 1
**         TITLETEXT          = 'EMP ID'
**      IMPORTING
**        CHOISE             = SY-TABIX
**       TABLES
**       VALUETAB           = IT_EMP.
*
**     ENDIF.
**     LOOP AT IT_EMP.
*EMPID = IT_EMP-EMPID.
*W_HEAD-ENTEREDBY = EMPID.
**ENDLOOP.
*     IF SY-SUBRC <> 0.
** Implement suitable error handling here
*     ENDIF.
*
**ENDIF.
*&---------------------------------------------------------------------*
*&      Module  GET  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get INPUT.               " R.Shrujan On 19.06.2014
*  REFRESH IT_EMP[].
*   CLEAR: FIELD_VALUE, DYNPRO_VALUES.
*  REFRESH DYNPRO_VALUES.CLEAR FIELD_VALUE.
*  FIELD_VALUE-FIELDNAME = 'EMPID'.
*  APPEND FIELD_VALUE TO DYNPRO_VALUES.
*  CALL FUNCTION 'DYNP_VALUES_READ'
*    EXPORTING
*      DYNAME             = SY-CPROG
*      DYNUMB             = SY-DYNNR
*      TRANSLATE_TO_UPPER = 'X'
*    TABLES
*      DYNPFIELDS         = DYNPRO_VALUES.
*  READ TABLE DYNPRO_VALUES INDEX 1 INTO FIELD_VALUE.
*  SELECT EMPID  FROM ZPLANTSSAN INTO CORRESPONDING FIELDS OF TABLE IT_EMP.
*                 CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*                   EXPORTING
**                    DDIC_STRUCTURE         = ' '
*                     RETFIELD               = 'EMPID'
**                    PVALKEY                = ' '
*                    DYNPPROG               = SY-REPID
*                    DYNPNR                 = SY-DYNNR
*                    DYNPROFIELD            = 'EMPID '
**                    STEPL                  = 0
**                    WINDOW_TITLE           =
**                    VALUE                  = ' '
*                    VALUE_ORG              = 'S'
**                    MULTIPLE_CHOICE        = ' '
**                    DISPLAY                = ' '
**                    CALLBACK_PROGRAM       = ' '
**                    CALLBACK_FORM          = ' '
**                    CALLBACK_METHOD        =
**                    MARK_TAB               =
**                  IMPORTING
**                    USER_RESET             =
*                   TABLES
*                     VALUE_TAB              = IT_EMP[]
**                    FIELD_TAB              =
**                    RETURN_TAB             =
**                    DYNPFLD_MAPPING        =
*                  EXCEPTIONS
*                    PARAMETER_ERROR        = 1
*                    NO_VALUES_FOUND        = 2
*                    OTHERS                 = 3
*                           .
*                 IF SY-SUBRC <> 0.
** Implement suitable error handling here
*                 ENDIF.









  SELECT empid name FROM zplantssan INTO CORRESPONDING FIELDS OF TABLE it_emp WHERE werks = zst_gp_eid-plant ORDER BY PRIMARY KEY.
  IF it_emp[] IS NOT INITIAL.
    CALL FUNCTION 'POPUP_WITH_TABLE_DISPLAY'
      EXPORTING
        endpos_col   = 30
        endpos_row   = 30
        startpos_col = 1
        startpos_row = 1
        titletext    = 'EMPLOY ID'
      IMPORTING
        choise       = sy-tabix
      TABLES
        valuetab     = it_emp
      EXCEPTIONS
        break_off    = 1
        OTHERS       = 2.
  ENDIF.
  READ TABLE it_emp INDEX sy-tabix.
  empid = it_emp-empid.
  employname = it_emp-name.
  w_head-enteredby = empid.
  employname = employname.


ENDMODULE.                 " GET  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS '998_STAT'.
  SET TITLEBAR '998_STAT'.
  g_passtyp = c_nrt.
  g_inout = s_in.
  g_retpass  = ' '.
  CLEAR text.CLEAR text1.CLEAR text2.CLEAR text3.CLEAR texted.

ENDMODULE.                 " STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  FIELDS_MODIFICATION_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE fields_modification_9000 OUTPUT.

  IF ok_100 EQ 'PO_CR'.
    LOOP AT SCREEN.
      IF screen-group1 = 'GP'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF ok_100 <> 'PO_CR'.
    LOOP AT SCREEN.
      IF screen-group1 = 'PO'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " FIELDS_MODIFICATION_9000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_9000 INPUT.

  CLEAR ans.
  CASE sy-ucomm.
    WHEN 'EXIT' OR 'CANCEL' OR 'BACK'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Leave Transaction'
*         DIAGNOSE_OBJECT       = ' '
          text_question         = 'Do You Want to Leave!!??'
          text_button_1         = 'Yes' "'Ja'(001)
*         ICON_BUTTON_1         = 'No'
          text_button_2         = 'No' "(002)
*         ICON_BUTTON_2         = ' '
*         DEFAULT_BUTTON        = '1'
          display_cancel_button = ' '
*         USERDEFINED_F1_HELP   = ' '
*         START_COLUMN          = 25
*         START_ROW             = 6
*         POPUP_TYPE            =
*         IV_QUICKINFO_BUTTON_1 = ' '
*         IV_QUICKINFO_BUTTON_2 = ' '
        IMPORTING
          answer                = ans
*     TABLES
*         PARAMETER             =
*     EXCEPTIONS
*         TEXT_NOT_FOUND        = 1
*         OTHERS                = 2
        .
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF ans = 1.
        PERFORM clear_values.
        LEAVE TO SCREEN 0.
      ENDIF.
  ENDCASE.

ENDMODULE.                 " EXIT_9000  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_ENTRY_DETAILS_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_entry_details_9000 INPUT.

*DATA : TABIX TYPE SY-TABIX.
  REFRESH : ipo_head[].
  CLEAR : tabix,w_pass.
*TABLES : SETLEAF.
  CLEAR : setleaf.
  IF ok_100 = 'PO_CR'.
    IF zst_gp_eid-plant IS NOT INITIAL.
*Begin of Replace IBM HANATIZATION -SAU001
*      SELECT SINGLE * FROM SETLEAF WHERE SETNAME = 'PO_PLANT_GATEPASS' AND SETCLASS = '0000'
      DATA : lv_setclass TYPE setclass.
      SELECT SINGLE setclass FROM setleaf INTO lv_setclass WHERE setname = 'PO_PLANT_GATEPASS' AND setclass = '0000'
*End of Replace IBM HANATIZATION -SAU001
            AND valfrom =                 "#EC CI_FLDEXT_OK[0002215424]
 zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE e062 WITH zst_gp_eid-plant.
      ELSE.
        AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
          ID 'ACTVT' FIELD '11'
          ID 'PLANT' FIELD zst_gp_eid-plant.
        IF sy-subrc <> 0.
          MESSAGE e063 WITH zst_gp_eid-plant.
        ENDIF.
      ENDIF.
      IF sy-subrc = 0.
*Begin of Replace IBM HANATIZATION -SAU001
*        SELECT SINGLE * FROM EKKO WHERE EBELN = ZST_GP_EID-EBELN AND PROCSTAT IN ('02','05').
        DATA : lv_ekko_ebeln TYPE ebeln.
        SELECT SINGLE ebeln FROM ekko INTO lv_ekko_ebeln WHERE ebeln = zst_gp_eid-ebeln AND procstat IN ('02','05').
*End of Replace IBM HANATIZATION -SAU001
        IF sy-subrc <> 0.
          MESSAGE e084 WITH zst_gp_eid-ebeln.
        ENDIF.
        SELECT * FROM ekpo INTO CORRESPONDING FIELDS OF TABLE
            ipo_head WHERE ebeln = zst_gp_eid-ebeln AND loekz <> 'L' AND werks = zst_gp_eid-plant AND pstyp NOT IN ('2','3')
             AND retpo = 'X'..
         SELECT  * FROM eket INTO table @ipo_eket  "BCS 25.04.2025
         WHERE ebeln = @zst_gp_eid-ebeln.

*--------- comment by sandhiya
        LOOP AT ipo_head INTO wpo_head.
          CLEAR : eket.
          tabix = sy-tabix.

***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*          SELECT * FROM eket UP TO 1 ROWS
* WHERE ebeln = wpo_head-ebeln AND ebelp = wpo_head-ebelp
* ORDER BY PRIMARY KEY .

 read table ipo_eket into wa_eket with key ebelp = wpo_head-ebelp .
  SELECT ebeln ebelp etenr menge wemng
    INTO CORRESPONDING FIELDS OF eket
    FROM eket
    UP TO 1 ROWS
    WHERE ebeln = wpo_head-ebeln
      AND ebelp = wpo_head-ebelp
    ORDER BY PRIMARY KEY.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
          ENDSELECT.
*-----------end comment

*SELECT ebeln,
*       ebelp,
*       etenr,
*       menge,
*       wemng,
*       eindt
*  FROM eket
*  INTO TABLE @data(lt_eket)
*  WHERE ebeln = @wpo_head-ebeln
*    AND ebelp = @wpo_head-ebelp
*    AND eindt <= @sy-datum.
*
*  loop at lt_eket into data(wa_eket1).
*  tabix = sy-tabix.
*
*  read table ipo_head into wpo_head with key ebeln = wa_eket1-ebeln ebelp = wa_eket1-ebelp.

********

          IF sy-subrc = 0.
            IF eket-wemng <= eket-menge.
              wpo_head-menge = eket-menge - eket-wemng.
            ELSE.
              wpo_head-menge = eket-wemng - eket-wemng.
            ENDIF.
          ENDIF.
          LOOP AT i_material_po INTO w_material_po WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year
                AND plant = zst_gp_eid-plant.
            wpo_head-menge = wpo_head-menge - w_material_po-ret_qty.
          ENDLOOP.
          SELECT SINGLE waers FROM ekko INTO wpo_head-waers WHERE ebeln = zst_gp_eid-ebeln.
          IF wpo_head-waers IS NOT INITIAL."= 'INR' OR wpo_head-waers = 'USD'. " SB 25.01.2018
            IF wpo_head-netwr IS NOT INITIAL.
*****Begin of Addition by Rahul C on 06.11.2019 CTS ID: SRS 2019002588*****
***              wpo_head-netwr = wpo_head-netwr / 10.
              CLEAR: int_amt, disp_amt.
              int_amt = wpo_head-netwr.
              CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_DISPLAY'
                EXPORTING
                  currency              = wpo_head-waers
                  amount_internal       = int_amt
               IMPORTING
                 amount_display        = disp_amt
*               EXCEPTIONS
*                 INTERNAL_ERROR        = 1
*                 OTHERS                = 2
                        .
              IF sy-subrc <> 0.
* Implement suitable error handling here
              ENDIF.
              wpo_head-netwr = disp_amt.
               wpo_head-eindt = wa_eket-eindt.

*************************End of Addition*************************
            ENDIF.
          ENDIF.
          MODIFY ipo_head FROM wpo_head INDEX tabix..
          CLEAR : wpo_head.
        ENDLOOP.
        DELETE ipo_head[] WHERE menge IS INITIAL.
        ipo_head_tol[] = ipo_head[].
        IF ipo_head[] IS INITIAL.
          MESSAGE e064.
        ELSE.
          CALL SCREEN 9001.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSEIF ok_100 = 'PO_DI'.
    SELECT ebeln FROM Zgate_pass_h INTO zst_gp_eid-ebeln UP TO 1 ROWS WHERE
 pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
      ID 'ACTVT' FIELD '13'
      ID 'PLANT' FIELD zst_gp_eid-plant.
    IF sy-subrc <> 0.
      MESSAGE e072 WITH zst_gp_eid-plant.
    ENDIF.
    IF zst_gp_eid-pass_no IS INITIAL.
      MESSAGE e065.
    ELSE.
      SELECT * FROM Zgate_pass_h INTO w_pass UP TO 1 ROWS WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
 AND ebeln <> ' '
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      IF sy-subrc <> 0.
        MESSAGE e066.
      ELSE.
        CALL SCREEN 9001.
      ENDIF.
    ENDIF.
  ELSEIF ok_100 = 'PO_CH'.
    SELECT ebeln FROM Zgate_pass_h INTO zst_gp_eid-ebeln UP TO 1 ROWS WHERE
 pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    SELECT * FROM ekpo INTO CORRESPONDING FIELDS OF TABLE
        ipo_head WHERE ebeln = zst_gp_eid-ebeln AND loekz <> 'L' AND werks = zst_gp_eid-plant.

    " SB 25.01.2018
   SELECT  * FROM eket INTO table @ipo_eket  "BCS 25.04.2025
         WHERE ebeln = @zst_gp_eid-ebeln.

    LOOP AT ipo_head INTO wpo_head.
      read table ipo_eket into wa_eket with key ebelp = wpo_head-ebelp .
      IF wpo_head-waers IS NOT INITIAL."= 'USD'.
            IF wpo_head-netwr IS NOT INITIAL.
*****Begin of Addition by Rahul C on 06.11.2019 CTS ID: SRS 2019002588*****
***              wpo_head-netwr = wpo_head-netwr / 10.
              CLEAR: int_amt, disp_amt.
              int_amt = wpo_head-netwr.
              CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_DISPLAY'
                EXPORTING
                  currency              = wpo_head-waers
                  amount_internal       = int_amt
               IMPORTING
                 amount_display        = disp_amt
*               EXCEPTIONS
*                 INTERNAL_ERROR        = 1
*                 OTHERS                = 2
                        .
              IF sy-subrc <> 0.
* Implement suitable error handling here
              ENDIF.
              wpo_head-netwr = disp_amt.
*************************End of Addition*************************
              ENDIF.
      ENDIF.
      wpo_head-eindt = wa_eket-eindt.
      MODIFY ipo_head FROM wpo_head INDEX sy-tabix TRANSPORTING netwr eindt.
    ENDLOOP.
    " SB 25.01.2018

    AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
      ID 'ACTVT' FIELD '12'
      ID 'PLANT' FIELD zst_gp_eid-plant.
    IF sy-subrc <> 0.
      MESSAGE e073 WITH zst_gp_eid-plant.
    ENDIF.
    ipo_head_tol[] = ipo_head[].
    IF zst_gp_eid-pass_no IS INITIAL.
      MESSAGE e065.
    ELSE.
      SELECT * FROM Zgate_pass_h INTO w_pass UP TO 1 ROWS WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
 AND del_ind <> 'X'
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      IF sy-subrc <> 0.
        MESSAGE e066.
      ELSEIF w_pass-approved_i IS NOT INITIAL.
        MESSAGE e075.
      ELSE.
        CALL SCREEN 9001.
      ENDIF.
    ENDIF.
  ELSEIF ok_100 = 'PO_DE'.
    SELECT ebeln FROM Zgate_pass_h INTO zst_gp_eid-ebeln UP TO 1 ROWS WHERE
 pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
 ORDER BY PRIMARY KEY .
    ENDSELECT.
    AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
      ID 'ACTVT' FIELD '15'
      ID 'PLANT' FIELD zst_gp_eid-plant.
    IF sy-subrc <> 0.
      MESSAGE e076 WITH zst_gp_eid-pass_no.
    ENDIF.
    IF zst_gp_eid-pass_no IS INITIAL.
      MESSAGE e065.
    ELSE.
      SELECT * FROM Zgate_pass_h INTO w_pass UP TO 1 ROWS WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year AND plant = zst_gp_eid-plant
 AND ebeln <> ' '
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      IF sy-subrc <> 0.
        MESSAGE e066.
      ELSEIF w_pass-approved_i IS NOT INITIAL.
        MESSAGE e077.
      ELSEIF w_pass-del_ind IS NOT INITIAL.
        MESSAGE e078.
      ELSE.
        CALL SCREEN 9001.
      ENDIF.
    ENDIF.

  ENDIF.

ENDMODULE.                 " CHECK_ENTRY_DETAILS_9000  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  REFRESH : it_extab.   "CLEAR EMPID.
  IF ok_100 = 'PO_DI' OR ok_100 = 'PO_DE'.
    wa_extab-fcode = 'SAVE'.
    APPEND wa_extab TO it_extab.
  ENDIF.
  IF ok_100 <> 'PO_DE' .
    wa_extab-fcode = 'DELETE'.
    APPEND wa_extab TO it_extab.
  ENDIF.
  IF ok_100 <> 'PO_DI' .
    wa_extab-fcode = 'P_PRINT'.
    APPEND wa_extab TO it_extab.
  ENDIF.
  SET PF-STATUS '999_STAT' EXCLUDING it_extab.
  SET TITLEBAR '999_STAT'.

ENDMODULE.                 " STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INITIALIZE_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE initialize_9001 OUTPUT.

* data : ZST_GP_EID_PLANT type plant.
*  TABLES : ZBL_MIGO_GPASS.
*  DATA : I102 TYPE TABLE OF ZBL_MIGO_GPASS,W102 TYPE ZBL_MIGO_GPASS,I102DUP TYPE TABLE OF ZBL_MIGO_GPASS,W102DUP TYPE ZBL_MIGO_GPASS.
  CLEAR : ekko.CLEAR: it_emp-empid.
  CASE ok_100.
    WHEN 'PO_CR'.
      IF w_head-dept_issue_date IS INITIAL.
        w_head-dept_issue_date = sy-datum.
        zst_gp_eid_plant = zst_gp_eid-plant.                  "Added By Shrujan on 09.07.2014
      ENDIF.
      IF w_head-issue_date IS INITIAL.
        w_head-issue_date = sy-datum.
      ENDIF.
      IF w_head-issue_time IS INITIAL.
        w_head-issue_time = sy-uzeit.
      ENDIF.
      REFRESH : i_material,i102.
      CLEAR : w102.
      SELECT * FROM zgate_passi_eid
         INTO CORRESPONDING FIELDS OF TABLE i_material_po
          WHERE ebeln = zst_gp_eid-ebeln AND plant = zst_gp_eid-plant "AND PASS_YEAR = ZST_GP_EID-PASS_YEAR
             ." AND MAT_DOC_REF EQ ' '."MBLNR EQ ' '." AND PASS_NO EQ
****SYED FOR 102
*  IF I_MATERIAL_PO[] IS NOT INITIAL.
*      SELECT * FROM ZBL_MIGO_GPASS INTO CORRESPONDING FIELDS OF TABLE I102
*        FOR ALL ENTRIES IN I_MATERIAL_PO WHERE PASS_NO = I_MATERIAL_PO-PASS_NO AND PASS_YEAR = I_MATERIAL_PO-PASS_YEAR
*            AND PLANT = I_MATERIAL_PO-PLANT AND ITEM_NO = I_MATERIAL_PO-ITEM_NO.
*  ENDIF.
*LOOP AT I_MATERIAL_PO INTO W_MATERIAL_PO." WHERE BWART EQ '102'.
*  TABIX = SY-TABIX.
*  READ TABLE I102 INTO W102 WITH KEY MBLNR = W_MATERIAL_PO-MAT_DOC_REF PASS_NO  = W_MATERIAL_PO-PASS_NO PASS_YEAR = W_MATERIAL_PO-PASS_YEAR
*      ITEM_NO = W_MATERIAL_PO-ITEM_NO BWART = '102'.
*  IF SY-SUBRC = 0.
*  READ TABLE I102DUP INTO W102DUP WITH KEY SMBLN = W102-MBLNR SJAHR = W102-MJAHR SMBLP = W102-ZEILE.
*  IF SY-SUBRC = 0.
*
*  ENDIF.
*  LOOP AT I102 INTO W102 WHERE PASS_NO  = W_MATERIAL_PO-PASS_NO AND PASS_YEAR = W_MATERIAL_PO-PASS_YEAR
*        AND ITEM_NO = W_MATERIAL_PO-ITEM_NO AND SMBLN = W_MATERIAL_PO-MAT_DOC_REF AND SJAHR = W_MATERIAL_PO-MAT_DOC_YEAR.
*
*  ENDLOOP.
*  ENDIF.
*ENDLOOP.
***
      LOOP AT i_material_po INTO w_material_po.
        tabix = sy-tabix.
        SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE pass_no = w_material_po-pass_no AND pass_year = w_material_po-pass_year
 AND plant = zst_gp_eid-plant AND del_ind EQ 'X'
 ORDER BY PRIMARY KEY .
        ENDSELECT.
        IF sy-subrc = 0.
          DELETE i_material_po INDEX tabix.
        ENDIF.
        IF w_material_po-mat_doc_ref IS NOT INITIAL.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*          SELECT * FROM zbl_migo_gpass UP TO 1 ROWS
* WHERE mblnr = w_material_po-mat_doc_ref AND zeile = w_material_po-zeile AND mjahr = w_material_po-mat_doc_yr
* AND bwart IN ( '122' , '102' )
* ORDER BY PRIMARY KEY .

  SELECT pass_no pass_year item_no mblnr mjahr zeile plant bwart
    INTO CORRESPONDING FIELDS OF zbl_migo_gpass
    FROM zbl_migo_gpass
    UP TO 1 ROWS
    WHERE mblnr = w_material_po-mat_doc_ref
      AND zeile = w_material_po-zeile
      AND mjahr = w_material_po-mat_doc_yr
      AND bwart IN ( '122' , '102' )
    ORDER BY PRIMARY KEY.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
          ENDSELECT.
          IF sy-subrc <> 0.
            DELETE i_material_po INDEX tabix.
          ELSE.
            IF zbl_migo_gpass-bwart NE '102'.
              DELETE i_material_po INDEX tabix.
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR : w_material_po.
      ENDLOOP.
      SELECT * FROM Zgate_pass_h INTO CORRESPONDING FIELDS OF
 w_head UP TO 1 ROWS WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      IF sy-subrc <> 0.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*        SELECT SINGLE * FROM ekko WHERE ebeln = zst_gp_eid-ebeln.

  SELECT SINGLE ebeln lifnr waers knumv
    INTO CORRESPONDING FIELDS OF ekko
    FROM ekko
    WHERE ebeln = zst_gp_eid-ebeln.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
        IF sy-subrc = 0.
          SELECT SINGLE lifnr name1 ort01 ort02 pstlz land1 stras telf1 telfx FROM lfa1 INTO w_lfa1 WHERE lifnr = ekko-lifnr.
          MOVE-CORRESPONDING w_lfa1 TO w_head.
        ENDIF.
      ENDIF.
      CLEAR : cnt,marm.
      IF ipo_head[] IS NOT INITIAL AND itm_po[] IS INITIAL.
        LOOP AT ipo_head INTO wpo_head.
          CLEAR : marm.
          cnt = cnt + 1.
          witm_po-matnr = wpo_head-matnr.
          witm_po-maktx = wpo_head-txz01.
          witm_po-ebelp = wpo_head-ebelp.
          witm_po-meins = wpo_head-meins.
          witm_po-currency = wpo_head-waers.
          witm_po-item_no = cnt.
          witm_po-menge = wpo_head-menge.
          LOOP AT i_material_po INTO w_material_po WHERE ebeln = zst_gp_eid-ebeln AND ebelp = witm_po-ebelp.
            IF sy-subrc = 0 AND w_material_po-meins <> wpo_head-meins.
              SELECT * FROM t006a UP TO 1 ROWS
 WHERE spras = 'EN' AND mseh3 = w_material_po-meins
 ORDER BY PRIMARY KEY .
              ENDSELECT.
              IF sy-subrc = 0.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*                SELECT SINGLE * FROM marm WHERE matnr = w_material_po-matnr AND meinh = t006a-msehi.

  SELECT SINGLE matnr meinh umrez umren
    INTO CORRESPONDING FIELDS OF marm
    FROM marm
    WHERE matnr = w_material_po-matnr
      AND meinh = t006a-msehi.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064

*          SELECT SINGLE * FROM MARM WHERE MATNR = WITM_PO-MATNR AND MEINH = W_MATERIAL_PO-MEINS.
                witm_po-menge = witm_po-menge - ( w_material_po-menge * marm-umrez / marm-umren ).
              ENDIF.
            ELSE.
              witm_po-menge = witm_po-menge - w_material_po-menge.
            ENDIF.
            CLEAR : w_material_po.
          ENDLOOP.

***SYED ON 04.03.2012
          IF witm_po-menge < 0.
            witm_po-menge = 0.
          ENDIF.
***
          witm_po-value "#EC CI_FLDEXT_OK[0002610650]
 = wpo_head-netpr * witm_po-menge.
****SYED ON 10.06.2013
          CLEAR : v_konv_cds,ekko.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*          SELECT SINGLE * FROM ekko WHERE ebeln = wpo_head-ebeln.

  SELECT SINGLE ebeln waers knumv
    INTO CORRESPONDING FIELDS OF ekko
    FROM ekko
    WHERE ebeln = wpo_head-ebeln.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
          IF sy-subrc = 0.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*            SELECT * FROM V_KONV_CDS UP TO 1 ROWS
* WHERE knumv = ekko-knumv AND kposn = wpo_head-ebelp AND kschl LIKE 'PB%'
* ORDER BY PRIMARY KEY .

  SELECT knumv kposn stunr zaehk kpein
    INTO CORRESPONDING FIELDS OF v_konv_cds
    FROM v_konv_cds
    UP TO 1 ROWS
    WHERE knumv = ekko-knumv
      AND kposn = wpo_head-ebelp
      AND kschl LIKE 'PB%'
    ORDER BY PRIMARY KEY.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
            ENDSELECT.
            IF sy-subrc = 0 AND v_konv_cds-kpein > 1.
              witm_po-value = witm_po-value / v_konv_cds-kpein.
            ENDIF.

            " SB - Start - 19.01.2018
            IF ekko-waers IS NOT INITIAL."= 'USD'.
***              witm_po-value = witm_po-value / 10.
*****Begin of Addition by Rahul C on 06.11.2019 CTS ID: SRS 2019002588*****
***              wpo_head-netwr = wpo_head-netwr / 10.
              CLEAR: int_amt, disp_amt.
              int_amt = witm_po-value.
              CALL FUNCTION 'CURRENCY_AMOUNT_SAP_TO_DISPLAY'
                EXPORTING
                  currency              = ekko-waers
                  amount_internal       = int_amt
               IMPORTING
                 amount_display        = disp_amt
*               EXCEPTIONS
*                 INTERNAL_ERROR        = 1
*                 OTHERS                = 2
                        .
              IF sy-subrc <> 0.
* Implement suitable error handling here
              ENDIF.
              witm_po-value = disp_amt.
*************************End of Addition*************************
            ENDIF.
            " SB - End - 19.01.2018

          ENDIF.
***
          APPEND witm_po TO itm_po.
          CLEAR : witm_po,wpo_head.
        ENDLOOP.
      ENDIF.
    WHEN 'PO_DI' OR 'PO_CH' OR 'PO_DE'.
      IF w_head IS INITIAL.
        SELECT * FROM Zgate_pass_h INTO CORRESPONDING FIELDS OF w_head UP TO 1 ROWS WHERE
 plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year
 ORDER BY PRIMARY KEY .
        ENDSELECT.
      ENDIF.
      IF ok_100 = 'PO_CH'.
        SELECT * FROM zgate_passi_eid
           INTO CORRESPONDING FIELDS OF TABLE i_material_po
            WHERE ebeln = zst_gp_eid-ebeln AND plant = zst_gp_eid-plant "AND PASS_YEAR = ZST_GP_EID-PASS_YEAR
                ."AND MAT_DOC_REF EQ ' '."MBLNR EQ ' '." AND PASS_NO EQ
        LOOP AT i_material_po INTO w_material_po.
          tabix = sy-tabix.
          SELECT * FROM Zgate_pass_h UP TO 1 ROWS
 WHERE pass_no = w_material_po-pass_no AND pass_year = w_material_po-pass_year
 AND plant = zst_gp_eid-plant AND del_ind EQ 'X'
 ORDER BY PRIMARY KEY .
          ENDSELECT.
          IF sy-subrc = 0.
            DELETE i_material_po INDEX tabix.
          ENDIF.
          IF w_material_po-mat_doc_ref IS NOT INITIAL.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*            SELECT * FROM zbl_migo_gpass UP TO 1 ROWS
* WHERE mblnr = w_material_po-mat_doc_ref AND zeile = w_material_po-zeile AND mjahr = w_material_po-mat_doc_yr
* AND bwart IN ( '102' , '122' )
* ORDER BY PRIMARY KEY .

  SELECT pass_no pass_year item_no mblnr mjahr zeile plant bwart
    INTO CORRESPONDING FIELDS OF zbl_migo_gpass
    FROM zbl_migo_gpass
    UP TO 1 ROWS
    WHERE mblnr = w_material_po-mat_doc_ref
      AND zeile = w_material_po-zeile
      AND mjahr = w_material_po-mat_doc_yr
      AND bwart IN ( '102' , '122' )
    ORDER BY PRIMARY KEY.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
            ENDSELECT.
            IF sy-subrc = 0.
              DELETE i_material_po INDEX tabix.
*            ELSE. "shyam 10.10.2014

            ENDIF.
          ENDIF.
****SYED ON 10.06.2013
          CLEAR : v_konv_cds,ekko.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*          SELECT SINGLE * FROM ekko WHERE ebeln = w_material_po-ebeln.

  SELECT SINGLE ebeln waers knumv
    INTO CORRESPONDING FIELDS OF ekko
    FROM ekko
    WHERE ebeln = w_material_po-ebeln.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
          IF sy-subrc = 0.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*            SELECT * FROM V_KONV_CDS UP TO 1 ROWS
* WHERE knumv = ekko-knumv AND kposn = w_material_po-ebelp AND kschl LIKE 'PB%'
* ORDER BY PRIMARY KEY .

  SELECT knumv kposn stunr zaehk kpein
    INTO CORRESPONDING FIELDS OF v_konv_cds
    FROM v_konv_cds
    UP TO 1 ROWS
    WHERE knumv = ekko-knumv
      AND kposn = w_material_po-ebelp
      AND kschl LIKE 'PB%'
    ORDER BY PRIMARY KEY.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
            ENDSELECT.
            IF sy-subrc = 0 AND v_konv_cds-kpein > 1.
              w_material_po-value = w_material_po-value / v_konv_cds-kpein.
              MODIFY i_material_po FROM w_material_po INDEX tabix TRANSPORTING value.
            ENDIF.
          ENDIF.
***
          CLEAR : w_material_po.
        ENDLOOP.
      ENDIF.
      IF sy-subrc = 0 AND itm_po[] IS INITIAL.
        SELECT * FROM zgate_passi_eid INTO CORRESPONDING FIELDS OF TABLE itm_po WHERE
          plant = zst_gp_eid-plant AND pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year.
      ENDIF.
  ENDCASE.

ENDMODULE.                 " INITIALIZE_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  FIELD_MODIFICATION_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE field_modification_9001 OUTPUT.

* TABLES : T001K,T001,MARV.
*  DATA : OMON TYPE MONTH,OYEAR TYPE GJAHR,ODATE TYPE DATS, BDATE TYPE DATS,EDATE TYPE DATS.
  CLEAR : t001k,t001,marv,omon,oyear,bdate,edate.


  IF zst_gp_eid-pass_no IS INITIAL.
    LOOP AT SCREEN.
      IF screen-group1 = 'GP'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF zst_gp_eid-pass_no IS NOT INITIAL AND zst_gp_eid-ebeln IS INITIAL.
    SELECT ebeln FROM Zgate_pass_h INTO zst_gp_eid-ebeln UP TO 1 ROWS WHERE pass_no = zst_gp_eid-pass_no
 AND pass_year = zst_gp_eid-pass_year
 ORDER BY PRIMARY KEY .
    ENDSELECT.
  ENDIF.

*  IF W_MATERIAL_PO-VALUE IS NOT INITIAL AND W_MATERIAL_PO-CURRENCY IS NOT INITIAL.



  IF ok_100 = 'PO_DI' OR ok_100 = 'PO_DE'.
    LOOP AT SCREEN.
      IF screen-group1 = 'GRH'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'APPROVE'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF ok_100 = 'PO_DI' OR ok_100 = 'PO_CH' OR ok_100 = 'PO_CR'.
    LOOP AT SCREEN.
      IF screen-name = 'DELETE'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " FIELD_MODIFICATION_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SHOW_ICON_PO_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE show_icon_po_9001 OUTPUT.

  IF ok_100 = 'PO_CH' OR ok_100 = 'PO_DI' OR ok_100 = 'PO_DE'.
    IF w_pass-del_ind = 'X'.
      icon_name = 'ICON_DELETE'.
      icon_text = 'Gate Pass Deleted'.
    ELSE.
      IF w_pass-approved_i = 'X'.
        icon_name = 'ICON_GREEN_LIGHT'.
        icon_text = 'Gate Pass Approved'.
      ELSE.
        icon_name = 'ICON_RED_LIGHT'.
        icon_text = 'Gate Pass Not Approved'.
      ENDIF.
    ENDIF.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = icon_name
        info   = icon_text
        text   = icon_text
      IMPORTING
        result = po_st_icon.

  ENDIF.

ENDMODULE.                 " SHOW_ICON_PO_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  TC_P_CHANGE_TC_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE tc_p_change_tc_9001 OUTPUT.

  DESCRIBE TABLE itm_po LINES tc_p-lines.

ENDMODULE.                 " TC_P_CHANGE_TC_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_HEAD_VEND_DET_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_head_vend_det_9001 INPUT.

  CLEAR : ekko.

  IF ok_100 EQ 'PO_CR' ."AND W_HEAD-ENTEREDBY IS NOT INITIAL.

    IF w_head-enteredby IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = w_head-enteredby
        IMPORTING
          output = w_head-enteredby.

      SELECT SINGLE pernr FROM pa0000 INTO pernr WHERE pernr = w_head-enteredby AND stat2 = '3' AND endda >= sy-datum.
      IF sy-subrc <> 0.
*        MESSAGE 'Please enter a Valid Employee Number' TYPE 'E'.
      ELSE.
        SELECT nachn vorna FROM pa0002 INTO ( name1 , name2 ) UP TO 1 ROWS WHERE pernr = w_head-enteredby
 ORDER BY PRIMARY KEY .
        ENDSELECT.
        CONCATENATE name1 name2 INTO w_head-enteredbyname SEPARATED BY space.
      ENDIF.
*   IF ZPLANTSSAN-EMPID IS NOT INITIAL.
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          INPUT  = ZPLANTSSAN-EMPID
*        IMPORTING
*          OUTPUT = ZPLANTSSAN-EMPID.
*
*
*    SELECT SINGLE EMPID  FROM ZPLANTSSAN INTO IT_EMP.
*
*      ENDIF.

    ELSE.
      MESSAGE 'Please enter the Employee Number ' TYPE 'E'.
    ENDIF.




****CHECK IF THE RECEIVED DATE IS IN THE MM PERIOD
    IF w_head-dept_issue_date IS NOT INITIAL.
***   BOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
**Error msg: CL_CI_TEST_ANALYZE_SELECT_HANA - FEW

*      SELECT SINGLE * FROM ekko WHERE ebeln = zst_gp_eid-ebeln.

  SELECT SINGLE ebeln waers bedat knumv
    INTO CORRESPONDING FIELDS OF ekko
    FROM ekko
    WHERE ebeln = zst_gp_eid-ebeln.
***   EOC for HANAtization by SNEHA on 25.07.2019 in TR ESDK900122 in Run 064
      IF w_head-dept_issue_date < ekko-bedat.
        MESSAGE e081.
      ENDIF.
      IF w_head-dept_issue_date+0(4) <> zst_gp_eid-pass_year.
        MESSAGE e082.
      ENDIF.
      SELECT SINGLE * FROM t001k WHERE bwkey = zst_gp_eid-plant.
      IF sy-subrc = 0.
        SELECT SINGLE * FROM marv WHERE bukrs = t001k-bukrs.
        CALL FUNCTION 'ZSY_MON_FISCAL_CAL'
          EXPORTING
            month     = marv-lfmon
            year      = marv-lfgja
          IMPORTING
            out_month = omon
            out_year  = oyear.
        CONCATENATE oyear omon '01' INTO bdate.
        CALL FUNCTION 'LAST_DAY_OF_MONTHS'
          EXPORTING
            day_in            = bdate
          IMPORTING
            last_day_of_month = bdate
*         EXCEPTIONS
*           DAY_IN_NO_DATE    = 1
*           OTHERS            = 2
          .
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
        CLEAR : omon,oyear,odate.
        CALL FUNCTION 'ZSY_MON_FISCAL_CAL'
          EXPORTING
            month     = marv-vmmon
            year      = marv-vmgja
          IMPORTING
            out_month = omon
            out_year  = oyear.
        CONCATENATE oyear omon '01' INTO edate.
*        CALL FUNCTION 'LAST_DAY_OF_MONTHS'
*          EXPORTING
*            DAY_IN                  = ODATE
*          IMPORTING
*            LAST_DAY_OF_MONTH       = EDATE
**         EXCEPTIONS
**           DAY_IN_NO_DATE          = 1
**           OTHERS                  = 2
*                  .
*        IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ENDIF.
      ENDIF.
      IF w_head-dept_issue_date > sy-datum.
        MESSAGE 'Received date should not be future date' TYPE 'E'.
      ENDIF.
      IF w_head-dept_issue_date NOT BETWEEN edate AND bdate.
        MESSAGE e067 WITH edate bdate.
      ENDIF.
    ENDIF.
    IF w_head-issue_date IS INITIAL.
      MESSAGE e069 WITH 'Issue Date'.
    ENDIF.
    IF w_head-issued_to IS INITIAL.
      MESSAGE e069 WITH 'Issued To'.
    ENDIF.
***
    IF w_head-dispatch_mode = 'A' AND w_head-vehicle_no  IS INITIAL.
*      MESSAGE 'Please enter Vehicle Number' TYPE 'E'.
    ENDIF.
    IF Zgate_pass_h-landline IS NOT INITIAL.
*      IF Zgate_pass_h-LANDLINE CA 'ABCDEFGHIJKLMNOQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()+?></*+'.
*        MESSAGE 'Please Enter Only Numbers' TYPE 'E'.
*      ENDIF.
    ENDIF.
**********ELSE

  ENDIF.

ENDMODULE.                 " CHECK_HEAD_VEND_DET_9001  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.
*DATA : SCNO TYPE char5.
  CLEAR : line1.
  CASE ok_999.
    WHEN 'SAVE'.
      IF ok_100 = 'PO_CR'.
        LOOP AT itm_po INTO witm_po WHERE chk = 'X'.
          line1 = line1 + 1.
        ENDLOOP.
        IF line1 = 0.
          MESSAGE e070.
        ELSEIF totlines = 0.
          CLEAR : ok_999.
          MESSAGE e071.
        ELSE.
          PERFORM save_gatepass_po_9001.
        ENDIF.
      ELSEIF ok_100 = 'PO_CH'.
        IF totlines = 0.
          CLEAR : ok_999.
          MESSAGE e071.
        ELSE.
          PERFORM save_gatepass_po_9001.
        ENDIF.
      ENDIF.
    WHEN 'APPR'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
        ID 'ACTVT' FIELD '14'
        ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE e074 WITH zst_gp_eid-plant.
      ENDIF.
      IF ok_100 = 'PO_CR'.
        LOOP AT itm_po INTO witm_po WHERE chk = 'X'.
          line1 = line1 + 1.
        ENDLOOP.
        IF line1 = 0.
          MESSAGE e070.
        ELSEIF totlines = 0.
          CLEAR : ok_999.
          MESSAGE e071.
        ENDIF.
      ENDIF.
      PERFORM save_gatepass_po_9001.
    WHEN 'P_DEL'.
      IF totlines = 0.
        CLEAR : ok_999.
        MESSAGE e071.
      ENDIF.
      PERFORM save_gatepass_po_9001.

    WHEN 'P_PRINT'.
      scno = '9001'.
      EXPORT scno TO MEMORY ID 'SCREEN'.
      AUTHORITY-CHECK OBJECT 'ZEID_GPASS'
               ID 'ACTVT'  FIELD '16'
               ID 'PLANT' FIELD zst_gp_eid-plant.
      IF sy-subrc <> 0.
        MESSAGE e035 WITH zst_gp_eid-plant.
      ELSE.
        SELECT * FROM Zgate_pass_h UP TO 1 ROWS

 WHERE pass_no = zst_gp_eid-pass_no AND plant = zst_gp_eid-plant AND pass_year = zst_gp_eid-pass_year AND pass_typ = g_passtyp
 ORDER BY PRIMARY KEY .
        ENDSELECT.

        IF Zgate_pass_h-approved_i <> 'X'.
          MESSAGE e025 WITH Zgate_pass_h-pass_no.
        ELSE.
          CALL SCREEN 0800 STARTING AT 12 2 ENDING AT 100 20.
        ENDIF.
      ENDIF.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*&      Form  SAVE_GATEPASS_PO_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_gatepass_po_9001 .

  g_passtyp = c_nrt.
  g_inout = s_in.
  g_retpass  = ' '.
  CLEAR Zgate_pass_h.
  IF ok_100 = 'PO_CR'.
    g_nr_obj =  c_nrobj_nrt_in.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = c_objnr
        object                  = 'ZXX_GP_NRT'
        subobject               = zst_gp_eid-plant
        toyear                  = zst_gp_eid-pass_year
      IMPORTING
        number                  = g_pass_no
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    Zgate_pass_h-pass_no = g_pass_no.
    Zgate_pass_h-pass_year = zst_gp_eid-pass_year.
    Zgate_pass_h-plant = zst_gp_eid-plant.
    Zgate_pass_h-pass_typ = g_passtyp.
    Zgate_pass_h-in_out = g_retpass.
    Zgate_pass_h-subtype = 'OUT'. "G_INOUT.
    Zgate_pass_h-ebeln = zst_gp_eid-ebeln.
  ELSE.
    SELECT SINGLE *
          FROM Zgate_pass_h
          WHERE pass_no = zst_gp_eid-pass_no AND pass_year = zst_gp_eid-pass_year
          AND plant = zst_gp_eid-plant.                 "#EC CI_NOORDER
  ENDIF.
  MOVE-CORRESPONDING w_head TO Zgate_pass_h.

  IF ok_999 = 'APPR'.
    Zgate_pass_h-approved_i = 'X'.
    Zgate_pass_h-approved_date = sy-datum.
    Zgate_pass_h-approved_by = sy-uname.
  ELSEIF ok_999 = 'P_DEL'.
    Zgate_pass_h-del_ind = 'X'.
    Zgate_pass_h-deleted_date = sy-datum.
    Zgate_pass_h-deleted_by = sy-uzeit.
  ENDIF.
  Zgate_pass_h-changedby = sy-uname.
  Zgate_pass_h-changeddate = sy-datum.
  Zgate_pass_h-changedtime = sy-uzeit.
  Zgate_pass_h-purpose = text.
  Zgate_pass_h-purpose1 = text1.
  Zgate_pass_h-purpose2 = text2.
  Zgate_pass_h-purpose3 = text3.
  LOOP AT itm_po INTO witm_po WHERE chk = 'X'.
    MOVE-CORRESPONDING Zgate_pass_h TO w_mat_item.
    MOVE-CORRESPONDING witm_po TO w_mat_item.
    APPEND w_mat_item TO i_gate_pass_itm.
    CLEAR : w_mat_item,witm_po.
  ENDLOOP.
  IF ok_100 = 'PO_DE'.
  ELSE.
    IF sy-subrc <> 0.
      MESSAGE 'No Item has been selected' TYPE 'E'.
    ENDIF.
  ENDIF.
  IF ok_100 = 'PO_CR'.
    INSERT Zgate_pass_h.
*Begin of Addition by Rahul C on 28.11.2019 CTS ID: EID 2019002701*
      LOOP AT i_gate_pass_itm INTO w_mat_item.
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input                =  w_mat_item-meins
           language             = sy-langu
         IMPORTING
           output               = w_mat_item-meins
         EXCEPTIONS
           unit_not_found       = 1
           OTHERS               = 2
                  .
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        MODIFY i_gate_pass_itm FROM w_mat_item TRANSPORTING meins.
      CLEAR w_mat_item.
      ENDLOOP.
*****************End of Addition*****************
    INSERT zgate_passi_eid FROM TABLE i_gate_pass_itm.
    IF sy-subrc = 0.
      IF ok_999 = 'APPR'.
        PERFORM send_mail_approval.
        PERFORM clear_values_999.
        MESSAGE s005 WITH Zgate_pass_h-pass_no.
        LEAVE TO SCREEN 0.
      ELSEIF ok_999 = 'SAVE'.
        PERFORM send_mail.
        PERFORM clear_values_999.
        MESSAGE s005 WITH Zgate_pass_h-pass_no.
        LEAVE TO SCREEN 0.
      ENDIF.
    ENDIF.
  ELSEIF ok_100 = 'PO_CH'.
    MODIFY Zgate_pass_h.
    MODIFY zgate_passi_eid FROM TABLE i_gate_pass_itm.
    IF ok_999 = 'APPR'.
      PERFORM send_mail_approval.
      PERFORM clear_values_999.
      MESSAGE s005 WITH Zgate_pass_h-pass_no.
      LEAVE TO SCREEN 0.
    ELSEIF ok_999 = 'SAVE'.
      PERFORM send_mail.
      PERFORM clear_values_999.
      MESSAGE s005 WITH Zgate_pass_h-pass_no.
      LEAVE TO SCREEN 0.
    ENDIF.
  ELSEIF ok_100 = 'PO_DE'.
    PERFORM delete_gatepass.
    PERFORM clear_values_999.
    LEAVE TO SCREEN 0.
  ENDIF.
*ENDIF.

ENDFORM.                    " SAVE_GATEPASS_PO_9001
* BCS SUPPORT
*&---------------------------------------------------------------------*
*&      Module  CHECK_SEZ_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sez_gp_no INPUT.

SELECT SINGLE bukrs
    FROM t001k
    INTO @DATA(lv_bukrs_srs1)
     WHERE bwkey = @zst_gp_eid-plant.
   IF sy-subrc EQ 0.
     IF lv_bukrs_srs1 EQ 'SRS'.
        IF Zgate_pass_h-sez_gp_no IS INITIAL.
    MESSAGE 'Please Enter SEZ_GP_NO' TYPE 'E'.
    ENDIF.

  ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_SEZ_GP_DT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sez_gp_dt INPUT.
SELECT SINGLE bukrs
    FROM t001k
    INTO @DATA(lv_bukrs_srs2)
     WHERE bwkey = @zst_gp_eid-plant.
   IF sy-subrc EQ 0.
     IF lv_bukrs_srs2 EQ 'SRS'.
    IF Zgate_pass_h-sez_gp_dt  IS INITIAL.
       MESSAGE 'Please Enter SEZ_GP_DT ' TYPE 'E'.
      ENDIF.
  ENDIF.
  ENDIF.
ENDMODULE.
