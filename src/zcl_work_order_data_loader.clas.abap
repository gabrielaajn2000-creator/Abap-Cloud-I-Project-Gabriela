class zcl_work_order_data_loader definition
  public
  final
  create public .

  public section.
    interfaces if_oo_adt_classrun.
  protected section.
  private section.
endclass.


class zcl_work_order_data_loader implementation.
  method if_oo_adt_classrun~main.

    out->write( '--- START DATA LOAD ---' ).

    " 1. CUSTOMER
    data lt_customer type standard table of zot_customer.

    lt_customer = value #(
      ( client = sy-mandt
        customer_id = '00000001'
        name = 'Maria Perez'
        address = 'calle 1.'
        phone = '54710566' )

      ( client = sy-mandt
        customer_id = '00000002'
        name = 'Carla Botero'
        address = 'calle 4'
        phone = '58413810' )

      ( client = sy-mandt
        customer_id = '00000003'
        name = 'Luis Andrade'
        address = 'calle 6'
        phone = '61234567' )
    ).

    delete from zot_customer.
    insert zot_customer from table @lt_customer.

    if sy-subrc = 0.
      out->write( 'CUSTOMERS: OK' ).
    else.
      out->write( 'CUSTOMERS: ERROR' ).
    endif.

    " 2. TECHNICIAN
    data lt_technician type standard table of zot_technician.

    lt_technician = value #(
      ( client = sy-mandt
        technician_id = '00000001'
        name = 'Juan Lopez'
        specialty = 'Electrician' )

      ( client = sy-mandt
        technician_id = '00000002'
        name = 'Ana Torres'
        specialty = 'Plumber' )
    ).

    delete from zot_technician.
    insert zot_technician from table @lt_technician.

    if sy-subrc = 0.
      out->write( 'TECHNICIANS: OK' ).
    else.
      out->write( 'TECHNICIANS: ERROR' ).
    endif.

    " 3. WORK ORDER
    data lt_work_order type standard table of zot_work_order.

    lt_work_order = value #(
      ( client = sy-mandt
        work_order_id = '00000001'
        customer_id = '00000001'
        technician_id = '00000001'
        priority = 'A'
        status = 'PE' )

      ( client = sy-mandt
        work_order_id = '00000002'
        customer_id = '00000002'
        technician_id = '00000002'
        priority = 'B'
        status = 'PE' )
    ).

    delete from zot_work_order.
    insert zot_work_order from table @lt_work_order.

    if sy-subrc = 0.
      out->write( 'WORK ORDERS: OK' ).
    else.
      out->write( 'WORK ORDERS: ERROR' ).
    endif.

    " 4. WORK ORDER HISTORY
    data lt_history type standard table of zot_work_hist.

    lt_history = value #(
      ( client = sy-mandt
        history_id = '00000001'
        work_order_id = '00000001'
        modification_date = cl_abap_context_info=>get_system_date( )
        change_description = 'Order created' )

      ( client = sy-mandt
        history_id = '00000002'
        work_order_id = '00000002'
        modification_date = cl_abap_context_info=>get_system_date( )
        change_description = 'Order created' )
    ).

    delete from zot_work_hist.
    insert zot_work_hist from table @lt_history.

    if sy-subrc = 0.
      out->write( 'WORK ORDER HISTORY: OK' ).
    else.
      out->write( 'WORK ORDER HISTORY: ERROR' ).
    endif.

  endmethod.
endclass.
