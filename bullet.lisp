; Bullet structure
(defstruct bullet
  x
  y
  w
  h
  dir
  life
)

; Bullet damage variable
(defvar bullet-damage 1)

; Initial bullet list
(defvar bullets (list 0))

; Horrible macro that determines if a bullet hit a zombie or not
(defmacro bullet-hit ()
  `(let ((return nil))
    (when (equal "right" (bd))
          (when (and (<= (zombie-y (elt z-list x)) (by))
                     (>= (+ (zombie-y (elt z-list x)) 50) (by))
                     (>= (zombie-x (elt z-list x)) (bx))
                )
            (setf return t)
          )
    )
    (when (equal "left" (bd))
          (when (and (<= (zombie-y (elt z-list x)) (by))
                     (>= (+ (zombie-y (elt z-list x)) 50) (by))
                     (<= (zombie-x (elt z-list x)) (+ (bx) 800))
                )
            (setf return t)
          )
    )
    (when (equal "up" (bd))
          (when (and (<= (zombie-x (elt z-list x)) (bx))
                     (>= (+ (zombie-x (elt z-list x)) 50) (bx))
                     (<= (zombie-y (elt z-list x)) (+ (by) 800))
                )
            (setf return t)
          )
    )
    (when (equal "down" (bd))
          (when (and (<= (zombie-x (elt z-list x)) (bx))
                     (>= (+ (zombie-x (elt z-list x)) 50) (bx))
                     (>= (zombie-y (elt z-list x)) (by))
                )
            (setf return t)
          )
    )
    return
  )
)

; Macro that processes logic relating to bullets
(defmacro process-bullets ()
  '(let ((i 1))
    (loop
      (when (>= i (length bullets))(return))
      (xlib:draw-rectangle my-window scoreboard (* (bx) scale) (* (by) scale) (* (bw) scale) (* (bh) scale) t)
      (let ((x 0))
        (loop
          (when (>= x (length z-list))(return))
          (when (bullet-hit)
            (setf score (+ score (* (+ (random 25 (make-random-state t)) 1) bullet-damage)))
            (setf score-display (slice (write-to-string score)))
            (setf (zombie-hp (elt z-list x)) (- (zombie-hp (elt z-list x)) bullet-damage))
            (setf (zombie-hp-display (elt z-list x)) (slice (write-to-string (zombie-hp (elt z-list x)))))
            (when (>= 0 (zombie-hp (elt z-list x))) (setf z-list (remove (elt z-list x) z-list :test #'eql)))
          )
          (incf x)
        )
      )
      (setf (bl) (- (bl) 1))
      (when (>= 0 (bl)) (setf bullets (remove (elt bullets i) bullets)))
      (incf i)
    )
  )
)