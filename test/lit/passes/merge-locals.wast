;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --merge-locals -all -S -o - \
;; RUN:   | filecheck %s

(module
  ;; CHECK:      (func $subtype-to-copy
  ;; CHECK-NEXT:  (local $0 anyref)
  ;; CHECK-NEXT:  (local $1 anyref)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $subtype-to-copy
    (local $0 anyref)
    (local $1 anyref) ;; should be func
    (local.set $0
      (local.get $1)
    )
    ;; Test that merge-locals support subtyping. Merge-locals wants to use the
    ;; same local in as many places, which simplies the pattern of local usage
    ;; and allows more opts later.
    ;; In this case, both gets can use $0.
    (drop
      (local.get $1)
    )
    (drop
      (local.get $0)
    )
  )

  ;; CHECK:      (func $subtype-test (param $param i32)
  ;; CHECK-NEXT:  (local $0 anyref)
  ;; CHECK-NEXT:  (local $1 anyref)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $param)
  ;; CHECK-NEXT:   (local.set $1
  ;; CHECK-NEXT:    (ref.null func)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $subtype-test (param $param i32)
    (local $0 anyref)
    (local $1 anyref) ;; should be func
    (local.set $0
      (local.get $1)
    )
    ;; Another possible set exists to $1, which prevents using $0 for both of
    ;; the gets. However, we can use $1 for them both.
    (drop
      (local.get $0)
    )
    (if
      (local.get $param)
      (local.set $1
        (ref.null func)
      )
    )
    (drop
      (local.get $1)
    )
  )
)
