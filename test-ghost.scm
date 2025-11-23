#!/usr/bin/env guile
!#

;;; Test suite for ghost in the guile shell
;;; Validates the rooted trees sequence implementation

(use-modules (ice-9 format))

;; Load the main implementation
(load "ghost.scm")

;; Expected values from OEIS A000081 and the problem statement
(define expected-values
  '(0 1 1 2 4 9 20 48 115 286 719 1842 4766 12486 32973))

;; Test counter
(define tests-passed 0)
(define tests-failed 0)

;; Test helper
(define (test-case name actual expected)
  (if (equal? actual expected)
      (begin
        (format #t "✓ PASS: ~a~%" name)
        (set! tests-passed (+ tests-passed 1)))
      (begin
        (format #t "✗ FAIL: ~a~%  Expected: ~a~%  Got: ~a~%" name expected actual)
        (set! tests-failed (+ tests-failed 1)))))

;; Run tests
(define (run-tests)
  (format #t "~%Running tests for ghost in the guile shell~%")
  (format #t "==========================================~%~%")
  
  ;; Test individual values
  (let loop ((n 0) (expected expected-values))
    (when (not (null? expected))
      (test-case (format #f "T(~a)" n)
                 (rooted-trees n)
                 (car expected))
      (loop (+ n 1) (cdr expected))))
  
  ;; Test sequence generation
  (test-case "generate-sequence(10)"
             (generate-sequence 10)
             (list-head expected-values 10))
  
  ;; Test divisors helper function
  (test-case "divisors(6)"
             (divisors 6)
             '(1 2 3 6))
  
  (test-case "divisors(12)"
             (divisors 12)
             '(1 2 3 4 6 12))
  
  ;; Print summary
  (format #t "~%==========================================~%")
  (format #t "Tests passed: ~a~%" tests-passed)
  (format #t "Tests failed: ~a~%" tests-failed)
  (format #t "==========================================~%~%")
  
  (if (> tests-failed 0)
      (exit 1)
      (exit 0)))

;; Run the tests
(run-tests)
