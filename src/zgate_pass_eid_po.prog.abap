*&---------------------------------------------------------------------*
*& Include          ZGATE_PASS_EID_PO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZGATE_PASS_EID_PO                                *
*&---------------------------------------------------------------------*

*&spwizard: declaration of tablecontrol 'TC_P' itself
CONTROLS: TC_P TYPE TABLEVIEW USING SCREEN 0999.

*&spwizard: lines of tablecontrol 'TC_P'
DATA:     G_TC_P_LINES  LIKE SY-LOOPC.

*&spwizard: output module for tc 'TC_P'. do not change this line!
*&spwizard: update lines for equivalent scrollbar
MODULE TC_P_CHANGE_TC_ATTR OUTPUT.
  DESCRIBE TABLE ITM_PO LINES TC_P-LINES.
ENDMODULE.

*&spwizard: output module for tc 'TC_P'. do not change this line!
*&spwizard: get lines of tablecontrol
MODULE TC_P_GET_LINES OUTPUT.
  G_TC_P_LINES = SY-LOOPC.
ENDMODULE.

*&spwizard: input module for tc 'TC_P'. do not change this line!
*&spwizard: modify table
MODULE TC_P_MODIFY INPUT.
  MODIFY ITM_PO
    FROM WITM_PO
    INDEX TC_P-CURRENT_LINE.
ENDMODULE.

*&spwizard: input modul for tc 'TC_P'. do not change this line!
*&spwizard: mark table
MODULE TC_P_MARK INPUT.
  DATA: G_TC_P_WA2 LIKE LINE OF ITM_PO.
    IF TC_P-LINE_SEL_MODE = 1
    AND WITM_PO-SEL = 'X'.
     LOOP AT ITM_PO INTO G_TC_P_WA2
       WHERE SEL = 'X'.
       G_TC_P_WA2-SEL = ''.
       MODIFY ITM_PO
         FROM G_TC_P_WA2
         TRANSPORTING SEL.
     ENDLOOP.
  ENDIF.
  MODIFY ITM_PO
    FROM WITM_PO
    INDEX TC_P-CURRENT_LINE
    TRANSPORTING SEL.
ENDMODULE.

*&spwizard: input module for tc 'TC_P'. do not change this line!
*&spwizard: process user command
MODULE TC_P_USER_COMMAND INPUT.
  OK_999 = SY-UCOMM.
  PERFORM USER_OK_TC USING    'TC_P'
                              'ITM_PO'
                              'SEL'
                     CHANGING OK_999.
  SY-UCOMM = OK_999.
ENDMODULE.
