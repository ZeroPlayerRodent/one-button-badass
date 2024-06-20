; Player speed
(defvar ps 6)

; Player structure
(defstruct playa
  x
  y
  d
  k
  n
  c
  hp
  hp-display
  (hit nil)
  (f 30)
)

; Player health
(defvar health 2)

; Player firerate
(defvar firerate 20)

; List of colors that a player can be
(defvar player-colors
  (list
    16579688
    8656896
    3691688
    2120736
  )
)

; Initial player list
(defvar players)

; Function that makes players move
(defun move ()
  (let ((i 0))
    (loop
      (when (>= i (length players))(return))
      (cond ((equal "right" (pd))(setf (px) (+ (px) ps)))
            ((equal "down" (pd))(setf (py) (+ (py) ps)))
            ((equal "up" (pd))(setf (py) (- (py) ps)))
            ((equal "left" (pd))(setf (px) (- (px) ps)))
      )
      (if (> (px) 800)(setf (px) -50))
      (if (< (px) -50)(setf (px) 800))
      (if (> (py) 500)(setf (py) -50))
      (if (< (py) -50)(setf (py) 500))
      (incf i)
    )
  )
)

; Function that makes players rotate
(defun rotate (key-code)
  (let ((i 0))
    (loop
      (when (>= i (length players))(return))
      (when (equal key-code (pk))
        (cond ((equal "right" (pd))(setf (pd) "down"))
              ((equal "down" (pd))(setf (pd) "left"))
              ((equal "left" (pd))(setf (pd) "up"))
              ((equal "up" (pd))(setf (pd) "right"))
        )
      )
      (incf i)
    )
  )
)
