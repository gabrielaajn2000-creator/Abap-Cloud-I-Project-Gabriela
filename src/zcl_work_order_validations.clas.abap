class zcl_work_order_validations definition
  public
  final
  create public .

  public section.

    methods validateCreateOrder
      importing
        iv_customer_id   type zde_ot_customer_id
        iv_technician_id type zde_ot_technician_id
        iv_priority      type zde_ot_priority
      returning
        value(rv_valid)  type abap_bool.

    methods validateUpdateOrder
      importing
        iv_work_order_id type zde_ot_work_order_id
        iv_status        type zde_ot_status
      returning
        value(rv_valid)  type abap_bool.

    methods validateDeleteOrder
      importing
        iv_work_order_id type zde_ot_work_order_id
        iv_status        type zde_ot_status
      returning
        value(rv_valid)  type abap_bool.

    methods validateStatusAndPriority
      importing
        iv_status       type zde_ot_status
        iv_priority     type zde_ot_priority
      returning
        value(rv_valid) type abap_bool.

    methods validateAuthority
      importing
        iv_actvt        type zde_ot_actvt
      returning
        value(rv_valid) type abap_bool.

  protected section.
  private section.

    constants:
      c_status_pending   type zde_ot_status   value 'PE',
      c_status_completed type zde_ot_status   value 'CO',
      c_priority_high    type zde_ot_priority value 'A',
      c_priority_low     type zde_ot_priority value 'B'.


endclass.


class zcl_work_order_validations implementation.

  method validateCreateOrder.
    rv_valid = abap_false.

    "Validate CUSTOMER_ID
    select single customer_id
          from zot_customer
          where customer_id = @iv_customer_id
          into @data(lv_customer_id).

    if sy-subrc = 0.

    else.
      return.
    endif.

    " Validate TECHNICIAN_ID
    select single technician_id
          from zot_technician
          where technician_id = @iv_technician_id
          into @data(lv_technician_id).

    if sy-subrc = 0.

    else.
      return.
    endif.

    " Validate PRIORITY
    if iv_priority <> c_priority_high
       and iv_priority <> c_priority_low.
      return.
    endif.

    " If all validations pass
    rv_valid = abap_true.

  endmethod.


  method validateUpdateOrder.
    rv_valid = abap_false.

    " Check if work order exists
    select single work_order_id
           from zot_work_order
           where work_order_id = @iv_work_order_id
           into @data(lv_work_order_id).

    if sy-subrc = 0.
    else.
      return.
    endif.

    " Check if status is editable (PE)
    if iv_status <> c_status_pending.
      return.
    endif.

    rv_valid = abap_true.

  endmethod.


  method validateDeleteOrder.
    rv_valid = abap_false.
    " Check if work order exists
    select single work_order_id
              from zot_work_order
              where work_order_id = @iv_work_order_id
              into @data(lv_work_order_id).

    if sy-subrc = 0.
    else.
      return.
    endif.

    " Check if status is PE
    if iv_status <> c_status_pending.
      return.
    endif.

    " Check if order has history
    select single history_id
              from zot_work_hist
              where work_order_id = @iv_work_order_id
              into @data(lv_history_id).

    if sy-subrc = 0.
      return.
    endif.

    rv_valid = abap_true.

  endmethod.


  method validateStatusAndPriority.
    rv_valid = abap_false.

    " Validate STATUS
    if iv_status = c_status_pending
        or iv_status = c_status_completed.
    else.
      return.
    endif.

    " Validate PRIORITY
    if iv_priority = c_priority_high
       or iv_priority = c_priority_low.
    else.
      return.
    endif.

    " If both validations pass
    rv_valid = abap_true.
  endmethod.


  method validateAuthority.

    rv_valid = abap_false.

    authority-check object 'ZOT_WO'
      id 'ACTVT' field iv_actvt.

    if sy-subrc = 0.
      rv_valid = abap_true.
    else.
      rv_valid = abap_false.
    endif.

  endmethod.


endclass.
