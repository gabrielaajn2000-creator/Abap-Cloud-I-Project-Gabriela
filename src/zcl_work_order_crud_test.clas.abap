class zcl_work_order_crud_test definition
  public
  final
  create public .

  public section.
    interfaces if_oo_adt_classrun.

    methods test_create_work_order
      returning value(rv_success) type abap_bool.

    methods test_read_work_order
      returning value(rv_found) type abap_bool.

    methods test_update_work_order
      returning value(rv_success) type abap_bool.

    methods test_delete_work_order
      returning value(rv_success) type abap_bool.

  protected section.
  private section.
endclass.

class zcl_work_order_crud_test implementation.


  method if_oo_adt_classrun~main.

    out->write( '====================================' ).
    out->write( '   WORK ORDER CRUD – TEST EXECUTION  ' ).
    out->write( '====================================' ).

    out->write( cl_abap_char_utilities=>newline ).
    out->write( '--- TEST CREATE WORK ORDER ---' ).

    data(lv_success) = test_create_work_order( ).

    if lv_success = abap_true.
      out->write( 'Result: CREATE WORK ORDER -> OK' ).
    else.
      out->write( 'Result: CREATE WORK ORDER -> FAILED' ).
    endif.

    out->write( cl_abap_char_utilities=>newline  ).
    out->write( '--- TEST READ WORK ORDER ---' ).

    if test_read_work_order( ) = abap_true.
      out->write( 'Result: READ WORK ORDER -> OK' ).
    else.
      out->write( 'Result: READ WORK ORDER -> FAILED' ).
    endif.

    out->write( cl_abap_char_utilities=>newline  ).
    out->write( '--- TEST UPDATE WORK ORDER ---' ).

    if test_update_work_order( ) = abap_true.
      out->write( 'Result: UPDATE WORK ORDER -> OK' ).
    else.
      out->write( 'Result: UPDATE WORK ORDER -> FAILED' ).
    endif.

    out->write( cl_abap_char_utilities=>newline  ).
    out->write( '--- TEST DELETE WORK ORDER ---' ).

    if test_delete_work_order( ) = abap_true.
      out->write( 'Result: DELETE WORK ORDER -> OK' ).
    else.
      out->write( 'Result: DELETE WORK ORDER -> FAILED' ).
    endif.

    out->write( cl_abap_char_utilities=>newline  ).
    out->write( '=========== END OF TESTS ===========' ).

  endmethod.

  method test_create_work_order.



    data lo_crud type ref to zcl_work_order_crud_handler.
    data lv_success type abap_bool.

    lo_crud = new zcl_work_order_crud_handler( ).

    lv_success = lo_crud->create_work_order(
      iv_customer_id   = '00000001'
      iv_technician_id = '00000001'
      iv_priority      = 'A'
    ).


  endmethod.

  method test_read_work_order.

    data lo_crud  type ref to zcl_work_order_crud_handler.
    data lv_found type abap_bool.

    lo_crud = new zcl_work_order_crud_handler( ).

    lv_found = lo_crud->read_work_order(
      iv_work_order_id = '00000001'
    ).

  endmethod.

  method test_update_work_order.

    data lo_crud    type ref to zcl_work_order_crud_handler.
    data lv_success type abap_bool.

    lo_crud = new zcl_work_order_crud_handler( ).

    lv_success = lo_crud->update_work_order(
      iv_work_order_id = '00000001'
      iv_status        = 'PE'
    ).

  endmethod.

  method test_delete_work_order.

    data lo_crud    type ref to zcl_work_order_crud_handler.
    data lv_success type abap_bool.

    lo_crud = new zcl_work_order_crud_handler( ).

    lv_success = lo_crud->delete_work_order(
      iv_work_order_id = '00000001'
      iv_status        = 'PE'
    ).

  endmethod.



endclass.
