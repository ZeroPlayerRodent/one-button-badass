; Macro that draws ASCII art as a sprite
(defmacro draw-sprite (posx posy width color sprite)
  `(let ((index 1)(x (* ,posx scale))(y (* ,posy scale))(size 0))
     (loop
       (when (>= index (length ,sprite))(return))
       (when (equal "#" (elt ,sprite index))
         (incf size)
       )
       (when (or (equal "." (elt ,sprite index)) (equal (string #\Newline) (elt ,sprite index)))
         (if (> size 0)
           (progn
             (xlib:draw-rectangle my-window ,color x y (* ,width (* scale size)) (* ,width scale) t)
             (setf x (+ x (* ,width (* scale size))))
             (setf x (+ x (* ,width scale)))
           )
           (setf x (+ x (* ,width scale)))
         )
         (setf size 0)
       )
       (when (equal (string #\Newline) (elt ,sprite index))
         (setf y (+ y (* ,width scale)))
         (setf x (* ,posx scale))
       )
       (incf index)
    )
   )
)

; Zombie sprite
(defvar ghoul
(slice
"
....##....
....##....
..######..
.#.####.#.
.#.####.#.
.#.####.#.
...####...
...#..#...
...#..#...
..##..##..
"
)
)

; Player sprite
(defvar dude
(slice
"
#####
#.#.#
#####
#####
.#.#.
"
)
)

; List of numbers 0-9 as sprites
(defvar numbers
(list

(slice
"
#####
#...#
#...#
#...#
#####
"
)

(slice
"
....#
....#
....#
....#
....#
"
)

(slice
"
#####
....#
#####
#....
#####
"
)

(slice
"
#####
....#
#####
....#
#####
"
)

(slice
"
#...#
#...#
#####
....#
....#
"
)

(slice
"
#####
#....
#####
....#
#####
"
)

(slice
"
#####
#....
#####
#...#
#####
"
)

(slice
"
#####
....#
....#
....#
....#
"
)

(slice
"
#####
#...#
#####
#...#
#####
"
)

(slice
"
#####
#...#
#####
....#
#####
"
)
)
)

; Macro that writes a number to the screen
(defmacro write-number (x y w n c)
  `(let ((index2 0))
    (loop
      (when (>= index2 (length ,n))(return))
      (draw-sprite (+ ,x (* (* ,w 6) index2)) ,y ,w ,c (elt numbers (parse-integer (string (elt ,n index2)))))
      (incf index2)
    )
  )
)
