(define-module (pixelflut)
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-1))

(define server-url "127.0.0.1")
(define server-port 1234)

(define *socket* #f)

(define (pf-connect url port)
  (let ((socket (socket PF_INET SOCK_STREAM 0)))
    (connect socket AF_INET (inet-pton AF_INET url) port)
    socket))

(define (pf-init)
  (set! *socket* (pf-connect server-url server-port))
  (set! *random-state* (random-state-from-platform)))

(define (pf-disconnect)
  (close *socket*))

;; Objects
;; lists of tuples that represent pixels (x . y)

(define (set-px triple)
  (let ((t triple))
    (simple-format *socket* "PX ~A ~A ~A\n"
                   (car t) (cadr t) (caddr t))))

(define (line:simple x y len dir)
  (let* ((tup (case dir
                ((up n) '(0 . -1))
                ((down s) '(0 . 1))
                ((left w) '(-1 . 0))
                ((right e) '(1 . 0))
                ((nw) '(-1 . -1))
                ((ne) '(1 . -1))
                ((sw) '(-1 . 1))
                ((se) '(1 . 1))))
         (xdir (car tup))
         (ydir (cdr tup)))
    (map cons
         (iota len x xdir)
         (iota len y ydir))))

;; (define (randomwalk x y len)
;;   (if (zero? len)
;;       '()
;;       (append
;;        (do ((i len (- 1 i))
;;             (dir (case (random 4)
;;                     ((0) 'ne
;;                      (1) 'nw
;;                      (2) 'se
;;                      (3) 'sw)))
;;              (line (line-simple x y 100)))
;;          (apppend
;;           line-simple (randomwalk (TODO)))))))

(define (rect x y xlen ylen)
  (let ((res '()))
    (for-each
     (lambda (line-no)
       (set! res (append
                  (line:simple x (+ y line-no) xlen 'e)
                  res)))
     (iota ylen))
    (reverse res)))

;; Triples
;; Points that have been colored
;; Objects can be colored and then painted

(define (triple x y rgb)
  (list x y rgb))

(define (color obj col)
  (map (lambda (pix)
         (triple (car pix) (cdr pix) col))
       obj))

(define (paint triples)
  (for-each (lambda (t) (set-px t))
            triples))

(define (paint:random triples)
  (let* ((len (length triples))
         (rand (list-tail triples (random len)))
         (rest (cdr rand)))
    (set-px (car rand))
    (cond
     ((not (null-list? rest))
      (set-car! rand (car rest))
      (set-cdr! rand (cdr rest))
      (paint-random triples))
     ((> len 1)
      (set! rest '())
      (paint-random triples)))))

;; (define (paint-random triples)
;;   (do ()))

;; (define (line dc x0 y0 x1 y1)
;;   (define dx (abs (- x1 x0)))
;;   (define dy (abs (- y1 y0)))
;;   (define sx (if (> x0 x1) -1 1))
;;   (define sy (if (> y0 y1) -1 1))
;;   (define res (list))
;;   (cond
;;     [(> dx dy)
;;      (let loop ([x x0] [y y0] [err (/ dx 2.0)])
;;        (unless (= x x1)
;;          (define newerr (- err dy))
;;          (cons (cons x y) res)
;;          (if (< newerr 0)
;;              (loop (+ x sx) (+ y sy) (+ newerr dx))
;;              (loop (+ x sx)    y        newerr))))]
;;     [else
;;      (let loop ([x x0] [y y0] [err (/ dy 2.0)])
;;        (unless (= y y1)
;;          (define newerr (- err dy))
;;          (cons (cons x y) res)
;;          (if (< newerr 0)
;;              (loop (+ x sx) (+ y sy)    newerr)
;;              (loop    x     (+ y sy) (+ newerr dy)))))]))

