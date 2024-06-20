; Zombie speed
(defvar zs 5)

; Zombie health
(defvar zh 2)

; Zombie structure
(defstruct zombie
  (x 0)
  (y 0)
  (d "right")
  (w 10)
  (hp 2)
  (hp-display (slice "2"))
  (id 0)
)

; Initial list of zombies
(defvar z-list
  (list
    (make-zombie :id 0)
    (make-zombie :id 1)
    (make-zombie :id 2)
    (make-zombie :id 3)
    (make-zombie :id 4)
    (make-zombie :id 5)
  )
)

; Function that processes zombie movement
(defun process-zombies ()
  (let ((i 0))
    (loop
      (when (>= i (length z-list))(return))
      (cond ((equal "right" (zd))(setf (zx) (+ (zx) zs)))
            ((equal "down" (zd))(setf (zy) (+ (zy) zs)))
            ((equal "left" (zd))(setf (zx) (- (zx) zs)))
            ((equal "up" (zd))(setf (zy) (- (zy) zs)))
      )

      (if (> (zx) 800)(setf (zx) -50))
      (if (< (zx) -50)(setf (zx) 800))
      (if (> (zy) 500)(setf (zy) -50))
      (if (< (zy) -50)(setf (zy) 500))

      (setf (zw)(- (zw) 1))
      (when (>= 0 (zw))
        (setf (zw) (+ (random 50 (make-random-state t)) 1))
        (cond ((equal "right" (zd))(setf (zd) "down"))
             ((equal "down" (zd))(setf (zd) "left"))
              ((equal "left" (zd))(setf (zd) "up"))
              ((equal "up" (zd))(setf (zd) "right"))
        )
      )
      (incf i)
    )
  )
)
