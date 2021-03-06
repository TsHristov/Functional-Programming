;; accumulate: Accumulator function:
(define (accumulate initial accumulator start next end-condition? term)
  (define (linear-accumulator result current)
    (if (end-condition? current)
	result
	(linear-accumulator (accumulator result (term current)) (next current))))
  (linear-accumulator initial start))

;; factorial: Computes factorial (via accumulate):
(define (factorial n)
  (accumulate 1 * 1
	      (lambda (x) (+ x 1))
	      (lambda (x) (> x n))
	      (lambda (x) x))) 

;; range-sum: Computes the sum of the numbers between 1 and 100 (via accumulate):
(define (range-sum)
  (accumulate 0 + 1
	      (lambda (x) (+ x 1))
	      (lambda (x) (> x 100))
	      (lambda (x) x)))

;; prime?: Checks if number is prime (via accumulate):
(define (divisor? x number) (and (> x 0) (= (remainder number x) 0)))
(define (prime? number)
  (cond
   ((< number 2) #f)
   (else
    (let ((square-root (floor (sqrt number))))
      (accumulate #t (lambda (x y) (and x y)) square-root
		     (lambda (x) (- x 1))
	             (lambda (x) (< x 2))
	             (lambda (x) (not (divisor? x number))))))))

;; primes-count: Finds the count of prime numbers in a given interval [a, b] (via accumulate):
(define (primes-count a b)
  (accumulate 0 + a
	      (lambda (x) (+ x 1))
	      (lambda (x) (> x b))
	      (lambda (x) (if (prime? x) 1 0))))

;; e: Calculates the value of e, using Brothers` formulae with 6 steps:
(define (e)
  (define up-to 6)
  (define (term n) ( / (+ (* 2 n) 2) (factorial (+ (* 2 n) 1))))
  (+ (accumulate 0 + 0
		 (lambda (x) (+ x 1))
		 (lambda (x) (> x up-to))
		 (lambda (x) (term x))) 0.0))

;; e^x: Calculates the value of e^x:
;; (define (e^x x)
;;   (define (term x n) (/ (expt x n) (factorial n)))
;;   (accumulate 0 + (cons 0 1)
;; 	      (lambda (x) (cons (+ 1 (car x)) (term (cdr x) (car x))))
;; 	      (lambda (x) (> (car x) 1000000))
;; 	      (lambda (x) (cdr x))))

;; divisors-sum: Calculates the sum of divisors of a given number:
(define (divisors-sum n)
  (accumulate 0 + 1
	      (lambda (x) (+ x 1))
	      (lambda (x) (> x n))
	      (lambda (x) (if (divisor? x n) x 0))))

;; perfect-3: Finds the first three perfect numbers (trivial way):
(define (perfect-3)
  (define (aliquot-sum n) (- (divisors-sum n) n))
  (define (ends-with-6-or-8? n)
    (case (remainder n 10)
      ((6 8) #t)
      (else #f)))
  (accumulate '() append 1
	      (lambda (x) (+ x 1))
	      (lambda (x) (> x 1000))
	      (lambda (x) (if (and (ends-with-6-or-8? x) (= x (aliquot-sum x))) (list x) '()))))

;;perfect-numbers: Finds perfect numbers using coefficient k (using Euclid-Euler theorem):
(define (perfect-numbers k)
  (define (marsenne-prime p) (- (expt 2 p) 1))
  (define (perfect p) (* (expt 2 (- p 1)) (marsenne-prime p)))
  (define (even? x) (= (remainder x 2) 0))
  (accumulate '() append 2
	      (lambda (x) (if (even? x) (+ x 1) (+ x 2)))
	      (lambda (x) (> x k))
	      (lambda (x) (if (prime? (marsenne-prime x)) (list (perfect x)) '()))))

;;reverse-int: Reverses the digits of a given number:
(define (reverse-int number)
  (define (reverse number reversed)
    (if (= number 0) reversed
	(reverse (quotient number 10) (+ (* reversed 10) (remainder number 10)))))
  (reverse number 0))

;;palindrome?: Checks if a number is a palindrome:
(define (palindrome? number)
  (= number (reverse-int number)))

;;increasing?: Checks if the digits of a number are in increasing order, read from left to right:
(define (increasing? number)
  (define (last number)(remainder number 10))
  (define (last-but-one number)(remainder (quotient number 100) 10))
  (define (broken-relation? number)
    (<= (last number) (last-but-one number)))
  (if (or (broken-relation? number) (= number 0))
      #f
      (or #t (increasing? (quotient number 10)))))

;;to-binary: Converts given number to binary:
(define (to-binary number)
  (define (binary number step)
    (if (= number 0) 0
	(+ (* (remainder number 2) (expt 10 step)) (binary (quotient number 2) (+ step 1)))))
  (binary number 0))

;;to-decimal: Converts given binary number to decimal:
(define (to-decimal number)
  (define (decimal number step)
    (if (= number 0) 0
	(+ (* (remainder number 10) (expt 2 step)) (decimal (quotient number 10) (+ step 1)))))
  (decimal number 0))
