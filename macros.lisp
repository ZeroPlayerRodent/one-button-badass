; Simple shortcut macros

(defmacro zx ()
  '(zombie-x (elt z-list i))
)

(defmacro zy ()
  '(zombie-y (elt z-list i))
)

(defmacro zd ()
  '(zombie-d (elt z-list i))
)

(defmacro zw ()
  '(zombie-w (elt z-list i))
)

(defmacro px ()
  '(playa-x (elt players i))
)

(defmacro py ()
  '(playa-y (elt players i))
)

(defmacro pd ()
  '(playa-d (elt players i))
)

(defmacro pk ()
  '(playa-k (elt players i))
)

(defmacro pf ()
  '(playa-f (elt players i))
)

(defmacro bx ()
  '(bullet-x (elt bullets i))
)

(defmacro by ()
  '(bullet-y (elt bullets i))
)

(defmacro bd ()
  '(bullet-dir (elt bullets i))
)

(defmacro bl ()
  '(bullet-life (elt bullets i))
)

(defmacro bw ()
  '(bullet-w (elt bullets i))
)

(defmacro bh ()
  '(bullet-h (elt bullets i))
)

(defmacro ba ()
  '(bullet-atk (elt bullets i))
)