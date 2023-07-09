*"* use this source file for your ABAP unit test classes

CLASS game_test DEFINITION DEFERRED.
CLASS zgol_game DEFINITION LOCAL FRIENDS game_test.

CLASS game_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS test_state_formatter FOR TESTING RAISING cx_static_check.

    METHODS setup.
    METHODS teardown.

    DATA cut TYPE REF TO zgol_game.
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

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    FREE cut.
  ENDMETHOD.
ENDCLASS.
