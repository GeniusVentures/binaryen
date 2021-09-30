;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_test.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --vtable-to-indexes -all -S -o - | filecheck %s

(module
  ;; These types have nothing we need to change.
  (type $ignore-1 (struct (field i32) (field f32)))
  (type $ignore-2 (struct (field anyref)))

  ;; This type should have its field changed to an i32.
  (type $modify-1 (struct (field funcref)))

  ;; Keep the types alive.
  (func $func
   (param $x (ref $ignore-1))
   (param $y (ref $ignore-2))
   (param $y (ref $modify-1))
  )
)

;; Don't crash on an empty module
(module
)