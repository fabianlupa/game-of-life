*"* use this source file for your ABAP unit test classes

CLASS output_double DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun_out PARTIALLY IMPLEMENTED.

    DATA lines TYPE string_table READ-ONLY.
ENDCLASS.


CLASS output_double IMPLEMENTATION.
  METHOD if_oo_adt_classrun_out~write.
    DATA(data_as_string) = EXACT string( data ).
    SPLIT data_as_string AT |\n| INTO TABLE DATA(split_lines).
    APPEND LINES OF split_lines TO lines.
    output = me.
  ENDMETHOD.
ENDCLASS.

CLASS game_test DEFINITION DEFERRED.
CLASS zgol_game DEFINITION LOCAL FRIENDS game_test.

CLASS game_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS test_state_formatter FOR TESTING RAISING cx_static_check.
    METHODS test_1x1_output      FOR TESTING RAISING cx_static_check.
    METHODS test_3x3_output      FOR TESTING RAISING cx_static_check.

    METHODS given_the_board       IMPORTING board  TYPE zgol_game=>board.

    METHODS when_board_is_output.

    METHODS then_output_should_be IMPORTING !lines TYPE string_table.

    METHODS setup.
    METHODS teardown.

    DATA cut    TYPE REF TO zgol_game.
    DATA output TYPE REF TO output_double.
ENDCLASS.


CLASS game_test IMPLEMENTATION.
  METHOD test_state_formatter.
    cl_abap_unit_assert=>assert_equals( msg = 'ALIVE = X'
                                        exp = `X`
                                        act = cut->format_state_for_output( zgol_game=>alive ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'DEAD = space'
                                        exp = ` `
                                        act = cut->format_state_for_output( zgol_game=>dead ) ).
  ENDMETHOD.

  METHOD test_1x1_output.
    DATA(board) = VALUE zgol_game=>board( ( VALUE #( ( zgol_game=>alive ) ) ) ).
    given_the_board( board ).
    when_board_is_output( ).
    then_output_should_be( VALUE #( ( `  1` )
                                    ( `1 X` ) ) ).
  ENDMETHOD.

  METHOD test_3x3_output.
    DATA(board) = VALUE zgol_game=>board( ( VALUE #( ( zgol_game=>dead ) ( zgol_game=>dead ) ( zgol_game=>dead ) ) )
                                          ( VALUE #( ( zgol_game=>dead ) ( zgol_game=>alive ) ( zgol_game=>dead ) ) )
                                          ( VALUE #( ( zgol_game=>dead ) ( zgol_game=>dead ) ( zgol_game=>dead ) ) ) ).
    given_the_board( board ).
    when_board_is_output( ).
    then_output_should_be( VALUE #( ( `  1 2 3` )
                                    ( `1      ` )
                                    ( `2   X  ` )
                                    ( `3      ` ) ) ).
  ENDMETHOD.

  METHOD given_the_board.
    cut->current_board = board.
  ENDMETHOD.

  METHOD when_board_is_output.
    cut->output_board( ).
  ENDMETHOD.

  METHOD then_output_should_be.
    cl_abap_unit_assert=>assert_equals( exp = lines act = output->lines ).
  ENDMETHOD.

  METHOD setup.
    cut = NEW #( ).
    output = NEW output_double( ).
    cut->out = output.
  ENDMETHOD.

  METHOD teardown.
    FREE cut.
    FREE output.
  ENDMETHOD.
ENDCLASS.
