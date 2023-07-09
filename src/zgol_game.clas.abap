CLASS zgol_game DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES: BEGIN OF ENUM state,
             alive,
             dead,
           END OF ENUM state.
    TYPES cell  TYPE state.
    TYPES cells TYPE STANDARD TABLE OF cell WITH EMPTY KEY.
    TYPES rows  TYPE STANDARD TABLE OF cells WITH EMPTY KEY.
    TYPES board TYPE rows.

    DATA current_board TYPE board READ-ONLY.

  PRIVATE SECTION.
    DATA out TYPE REF TO if_oo_adt_classrun_out.

    METHODS initialize_board IMPORTING !rows         TYPE i
                                       !columns      TYPE i
                                       initial_state TYPE state DEFAULT dead.

    METHODS output_board.

    METHODS format_state_for_output IMPORTING !state        TYPE state
                                    RETURNING VALUE(result) TYPE string.
ENDCLASS.


CLASS zgol_game IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    me->out = out.

    initialize_board( rows = 10 columns = 10 initial_state = alive ).

    current_board[ 2 ][ 2 ] = dead.

    output_board( ).
  ENDMETHOD.

  METHOD initialize_board.
    current_board = VALUE #( FOR r = 1 UNTIL r > rows
                             ( VALUE #( FOR c = 1 UNTIL c > columns
                                        ( initial_state ) ) ) ).
  ENDMETHOD.

  METHOD output_board.
    DATA(row_count) = lines( current_board ).
    DATA(max_row_label_width) = strlen( |{ row_count NUMBER = USER }| ).
    DATA(column_count) = lines( current_board[ 1 ] ).
    DATA(max_column_label_width) = strlen( |{ column_count NUMBER = USER }| ).

    DATA(column_header) = REDUCE string(
        INIT h = repeat( occ = max_row_label_width + 1 val = ` ` ) &&
                 |{ 1 NUMBER = USER WIDTH = max_column_label_width ALIGN = RIGHT }|
        FOR c = 2 UNTIL c > column_count
        NEXT h = |{ h } { c NUMBER = USER WIDTH = max_column_label_width ALIGN = RIGHT }| ).

    DATA(row_data) = REDUCE string(
      INIT h = ``
      FOR r = 1 UNTIL r > row_count
      NEXT h = |{ h }{ r NUMBER = USER WIDTH = max_row_label_width ALIGN = RIGHT }| &&
               REDUCE string(
                 INIT a = `` FOR c = 1 UNTIL c > column_count
                 NEXT a = |{ a } { format_state_for_output( current_board[ r ][ c ] )
                                   WIDTH = max_column_label_width ALIGN = RIGHT }| ) &&
               |\n| ).

    out->write( column_header && |\n| && row_data ).
  ENDMETHOD.

  METHOD format_state_for_output.
    result = SWITCH #( state
                       WHEN alive THEN `X`
                       WHEN dead  THEN ` ` ).
  ENDMETHOD.
ENDCLASS.
