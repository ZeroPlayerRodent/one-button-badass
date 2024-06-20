; Function that slices a string into a list
(defun slice (foo)
  (let ((i 0)(l (list 'list)))
    (loop
      (when (>= i (length foo))(return))
      (setf l (concatenate 'list l (list (string (char foo i)))))
      (setf i (+ i 1))
    )
    (pop l)
    l
  )
)

; List of keys that can be used as player controls
(defvar keys
  (slice "_qwertyuiop____asdfghjkl_____zxcvbnm")
)

; Function that finds a key in the list
(defun get-key-code (letter)
  (+ (position letter keys :test #'equalp) 23)
)