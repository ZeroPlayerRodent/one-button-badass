; Import libraries and external files
(require "clx")
(load "keycodes.lisp")
(load "sprites.lisp")
(load "macros.lisp")
(load "bullet.lisp")
(load "player.lisp")
(load "badguys.lisp")
(load "upgrades.lisp")

; wave number and display list
(defvar wave 1)
(defvar wave-display (slice "1"))

; Screen scale
(defvar scale 1)

; Game outcome
(defvar outcome "died")

; Amount of extra zombies to spawn each wave
(defvar extra-zombies 0)

; Score number and display list
(defvar score 0)
(defvar score-display (list "0"))

; Function that determines if a zombie collided with a player
(defun if-collided (posx posy plx ply)
  (if (and(and (<= posx (+ plx 12.5))(>= (+ posx 50) (+ plx 12.5)))
          (and (<= posy (+ ply 12.5))(>= (+ posy 50) (+ ply 12.5))))
    t
    nil
  )
)

; Function that resets the game between waves
(defun reset-game ()
  (setf speed-timer 150)
  (setf score-display (slice (write-to-string score)))
  (setf z-list
    (list
      (make-zombie :id 0 :hp zh :hp-display (slice (write-to-string zh)))
      (make-zombie :id 1 :hp zh :hp-display (slice (write-to-string zh)))
      (make-zombie :id 2 :hp zh :hp-display (slice (write-to-string zh)))
      (make-zombie :id 3 :hp zh :hp-display (slice (write-to-string zh)))
      (make-zombie :id 4 :hp zh :hp-display (slice (write-to-string zh)))
      (make-zombie :id 5 :hp zh :hp-display (slice (write-to-string zh)))
    )
  )
  (let ((i 0))
    (loop
      (when (>= i extra-zombies)(return))
      (nconc z-list (list (make-zombie :id (+ i 6) :hp zh :hp-display (slice (write-to-string zh)))))
      (incf i)
    )
  )
)

; Macro that creates graphics contexts for colors
(defmacro make-color (color)
  `(xlib:create-gcontext :drawable root-window :foreground ,color)
)

; Main gameplay function
(defun start (controls &optional (host ""))
  (let* ((display (xlib:open-display host))
	 (screen (first (xlib:display-roots display)))
	 (black 0)
	 (white 16777215)
         (green 2120736)
         (yellow 16579688)
         (red 8656896)
	 (root-window (xlib:screen-root screen))
	 (badguy (make-color green))
	 (scoreboard (make-color white))
	 (my-window (xlib:create-window
		     :parent root-window
		     :x 0
		     :y 0
		     :width (* 800 scale)
		     :height (* 500 scale)
		     :background black
		     :event-mask (xlib:make-event-mask :exposure
						       :button-press
                                                       :key-press
                                                       :key-release))))
    ; Initialize player list
    (setf players (list 0))
    (let ((i 0))
      (loop
        (when (>= i (length controls))(return))
        (nconc players
          (list
            (make-playa :x 250 :y 250 :d "right" :k (get-key-code (elt controls i)) :n i
                        :hp health :hp-display (slice (write-to-string health))
                        :c (make-color (elt player-colors (mod i (length player-colors)))))
          )
        )
        (incf i)
      )
      (pop players)
    )

    ; Map main window
    (xlib:map-window my-window)
    
    ; Main gameplay loop
    (loop
      (move)
      (process-zombies)
      ; Clear the screen
      (xlib:clear-area my-window :x 0 :y 0 :width (* 800 scale) :height (* 500 scale))
      (process-bullets)
      ; Process players
      (let ((i 0))
        (loop
          (when (>= i (length players))(return))
          (draw-sprite (px) (py) 5 (playa-c (elt players i)) dude)
          (setf (pf) (- (pf) 1))
          (when (>= 0 (pf))
            (setf (pf) firerate)
            (let ((the-bullet (make-bullet :x (+ (px) 12) :y (+ (py) 12) :life 2 :dir (pd))))
              (when (equal (pd) "right")
                (setf (bullet-w the-bullet) 800)
                (setf (bullet-h the-bullet) 2)
              )
              (when (equal (pd) "left")
                (setf (bullet-w the-bullet) 800)
                (setf (bullet-h the-bullet) 2)
                (setf (bullet-x the-bullet) (- (bullet-x the-bullet) 800))
              )
              (when (equal (pd) "down")
                (setf (bullet-w the-bullet) 2)
                (setf (bullet-h the-bullet) 800)
              )
              (when (equal (pd) "up")
                (setf (bullet-w the-bullet) 2)
                (setf (bullet-h the-bullet) 800)
                (setf (bullet-y the-bullet) (- (bullet-y the-bullet) 800))
              )
              (nconc bullets (list the-bullet))
            )
          )
          (if (>= 0 (playa-hp (elt players i)))
            (setf players (remove (elt players i) players))
            (write-number (px) (+ (py) 48) 2 (playa-hp-display (elt players i)) (playa-c (elt players i)))
          )
          (incf i)
        )
      )
      ; Process zombies
      (let ((i 0))
        (loop
          (when (>= i (length z-list))(return))
          (draw-sprite (zx) (zy) 5 badguy ghoul)
          (write-number (zx) (+ (zy) 52) 2 (zombie-hp-display (elt z-list i)) badguy)
          (let ((x 0))
            (loop
              (when (>= x (length players))(return))
              (if (if-collided (zx) (zy) (playa-x (elt players x)) (playa-y (elt players x)))
                (when (not (playa-hit (elt players x)))
                  (setf (playa-hp (elt players x)) (- (playa-hp (elt players x)) 1))
                  (setf (playa-hp-display (elt players x)) (slice (write-to-string (playa-hp (elt players x)))))
                  (setf (playa-hit (elt players x)) (zombie-id (elt z-list i)))
                )
                (when (equal (playa-hit (elt players x)) (zombie-id (elt z-list i)))
                  (setf (playa-hit (elt players x)) nil)
                )
              )
              (incf x)
            )
          )
          (incf i)
        )
      )
      ; Draw scoreboard and wave number
      (write-number 5 5 5 score-display scoreboard)
      (write-number 550 5 5 wave-display scoreboard)
      (xlib:display-finish-output display)
      ; Sleep so the game doesn't run too fast
      (sleep 0.02)
      ; Process player input
      (xlib:event-case (display :timeout 0.02)
        (:key-press (code)(rotate code) t)
      )
      ; Return from loop if players won or lost
      (unless players (setf outcome "died") (return))
      (unless z-list (setf outcome "won") (return))
    )
    (terpri)
    (when (equal outcome "died")
      (format t "YOU DIED")
      (terpri)
      (terpri)
      (format t (concatenate 'string "WAVE " (write-to-string wave)))
    )
    (xlib:destroy-window my-window)
    (xlib:close-display display)
  )
)

; Main game function
(defun main ()
  (terpri)
  (terpri)
  (format t "WELCOME TO ONE-BUTTON-BADASS!!!")
  (terpri)
  (format t "ENTER YOUR SCREEN SIZE, 'small' OR 'large': ")
  (finish-output)
  (if (equal (read-line) "large")
    (setf scale 2)
    (setf scale 1)
  )
  (terpri)
  (format t "ENTER YOUR CONTROLS WITH KEYS 'a' TO 'z'.")
  (terpri)
  (format t "ENTER EMPTY STRING TO BEGIN GAME.")
  (terpri)
  ; Get player controls
  (let ((i 0)(controls (list 0))(input ""))
    (loop
      (format t (concatenate 'string "ENTER KEY FOR P" (write-to-string (+ i 1)) ": "))
      (finish-output)
      (setf input (read-line))
      (when (equal input "")(return))
      (setf controls (concatenate 'list controls (list input)))
      (incf i)
    )
    (pop controls)
    ; Main game and upgrade loop
    (loop
      (reset-game)
      (start controls)
      (terpri)
      (when (equal outcome "won")
        ; Upgrade zombies
        (setf zh (+ zh 6))
        (setf zs (+ zs 1))
        (when (equal (mod wave 2) 0)(incf extra-zombies))
        (buy-upgrades)
        (incf wave)
        (setf wave-display (slice (write-to-string wave)))
      )
      (when (equal outcome "died")
        (return)
      )
    )
  )
)
