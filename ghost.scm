#!/usr/bin/env guile
!#

;;; ghost in the guile shell
;;; Implementation of OEIS A000081: Number of rooted trees with n nodes
;;; 
;;; Sequence: {0,1,1,2,4,9,20,48,115,286,719,...}
;;;
;;; Recurrence relation:
;;; a(n+1) = (1/n) * sum_{k=1}^{n} (sum_{d|k} d * a(d)) * a(n-k+1)
;;; 
;;; Where a(0) = 0, a(1) = 1

(use-modules (ice-9 format))

;; Initialize memoization table for the sequence
(define *memo* (make-hash-table))

;; Base cases
(hash-set! *memo* 0 0)
(hash-set! *memo* 1 1)

;; Helper function to find all divisors of n (optimized)
(define (divisors n)
  "Return a list of all divisors of n"
  (if (<= n 0)
      '()
      (let loop ((d 1) (divs '()))
        (cond
          ((> (* d d) n) (sort divs <))
          ((zero? (modulo n d))
           (if (= d (/ n d))
               (loop (+ d 1) (cons d divs))
               (loop (+ d 1) (cons d (cons (/ n d) divs)))))
          (else (loop (+ d 1) divs))))))

;; Compute sum_{d|k} d * a(d)
(define (divisor-sum k)
  "Compute the weighted sum of a(d) over all divisors d of k"
  (let ((divs (divisors k)))
    (apply + (map (lambda (d) (* d (rooted-trees d))) divs))))

;; Main function to compute a(n) using the recurrence relation
(define (rooted-trees n)
  "Compute the number of rooted trees with n nodes"
  (cond
    ((not (and (integer? n) (>= n 0)))
     (error "rooted-trees: argument must be a non-negative integer" n))
    ((hash-ref *memo* n) => (lambda (val) val))
    (else
     (let* ((n-1 (- n 1))
            (sum (let loop ((k 1) (acc 0))
                   (if (> k n-1)
                       acc
                       (loop (+ k 1)
                             (+ acc (* (divisor-sum k)
                                      (rooted-trees (- n k))))))))
            (result (/ sum n-1)))
       (hash-set! *memo* n result)
       result))))

;; Function to generate the sequence up to n terms
(define (generate-sequence n)
  "Generate the first n terms of the rooted trees sequence"
  (map rooted-trees (iota n)))

;; Function to display the sequence
(define (display-sequence n)
  "Display the first n terms of the sequence"
  (let ((seq (generate-sequence n)))
    (format #t "Sequence T(n) for n = 0 to ~a:~%" (- n 1))
    (format #t "{~{~a~^,~}}~%" seq)))
