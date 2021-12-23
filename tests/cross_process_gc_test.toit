// Copyright (C) 2020 Toitware ApS. All rights reserved.

import expect show *

ON_DEVICE ::= platform == "FreeRTOS"

main:
  10.repeat:
    if ON_DEVICE:
      allocate_too_much
    else:
      20.repeat:
        hatch_:: allocate_too_much

allocate_too_much:
  if not ON_DEVICE: set_max_heap_size_ 30_000
  error ::= catch:
    10.repeat:
      x := "foo"
      25.repeat: x += x
  expect_equals "ALLOCATION_FAILED" error