class zcl_work_order_crud_handler definition
  public
  final
  create public .

  public section.

    methods create_work_order
      importing
        iv_customer_id    type zde_ot_customer_id
        iv_technician_id  type zde_ot_technician_id
        iv_priority       type zde_ot_priority
      returning
        value(rv_success) type abap_bool.

    methods read_work_order
      importing
        iv_work_order_id type zde_ot_work_order_id
      returning
        value(rv_found)  type abap_bool.

    methods update_work_order
      importing
        iv_work_order_id  type zde_ot_work_order_id
        iv_status         type zde_ot_status
      returning
        value(rv_success) type abap_bool.

    methods delete_work_order
      importing
        iv_work_order_id  type zde_ot_work_order_id
        iv_status         type zde_ot_status
      returning
        value(rv_success) type abap_bool.

  protected section.
  private section.
    constants:
      c_status_pending type zde_ot_status value 'PE'.
endclass.


class zcl_work_order_crud_handler implementation.

  method create_work_order.

    rv_success = abap_false.

    " 0. AUTHORITY CHECK – CREATE (ACTVT = '01')

    authority-check object 'ZOT_WO'
      id 'ACTVT' field '01'.

    if sy-subrc <> 0.
      return.
    endif.

    " 1. Business validations

    data(lo_validator) = new zcl_work_order_validations( ).

    data(lv_valid) = lo_validator->validateCreateOrder(
      iv_customer_id   = iv_customer_id
      iv_technician_id = iv_technician_id
      iv_priority      = iv_priority
    ).

    if lv_valid = abap_false.
      return.
    endif.

    " 2. Insert new work order

    insert zot_work_order from @(
      value zot_work_order(
        customer_id   = iv_customer_id
        technician_id = iv_technician_id
        priority      = iv_priority
        status        = c_status_pending   " constante (PE)
      )
    ).

    if sy-subrc <> 0.
      return.
    endif.

    rv_success = abap_true.

  endmethod.


  method read_work_order.

    authority-check object 'ZOT_WO'
    id 'ACTVT' field '03'.

    if sy-subrc <> 0.
      return.
    endif.

    rv_found = abap_false.

    select single work_order_id
       from zot_work_order
       where work_order_id = @iv_work_order_id
       into @data(lv_work_order_id).

    if sy-subrc = 0.
      rv_found = abap_true.
    else.
      return.
    endif.


  endmethod.

  method update_work_order.
    authority-check object 'ZOT_WO'
          id 'ACTVT' field '02'.

    if sy-subrc <> 0.
      return.
    endif.
    rv_success = abap_false.

    " 1. Validations
    data(lo_validator) = new zcl_work_order_validations( ).

    data(lv_valid) = lo_validator->validateUpdateOrder(
      iv_work_order_id = iv_work_order_id
      iv_status        = iv_status
    ).

    if lv_valid = abap_false.
      return.
    endif.

    " 2. Update order
    update zot_work_order
      set status = @iv_status
      where work_order_id = @iv_work_order_id.

    if sy-subrc = 0.
      rv_success = abap_true.
    else.
      return.
    endif.

  endmethod.

  method delete_work_order.

    authority-check object 'ZOT_WO'
        id 'ACTVT' field '06'.

    if sy-subrc <> 0.
      return.
    endif.

    rv_success = abap_false.

    " 1. Validations
    data(lo_validator) = new zcl_work_order_validations( ).

    data(lv_valid) = lo_validator->validateDeleteOrder(
      iv_work_order_id = iv_work_order_id
      iv_status        = iv_status
    ).

    if lv_valid = abap_false.
      return.
    endif.

    " 2. Delete work order
    delete from zot_work_order
      where work_order_id = @iv_work_order_id.

    if sy-subrc = 0.
      rv_success = abap_true.
    else.
      return.
    endif.

  endmethod.

endclass.
