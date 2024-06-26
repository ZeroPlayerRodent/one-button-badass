; Upgrade costs
(defvar speed-cost 80)
(defvar damage-cost 100)
(defvar firerate-cost 250)
(defvar health-cost 500)
(defvar upgrade-input)

; Function that lets players buy upgrades between rounds
(defun buy-upgrades ()
  (terpri)
  (format t "Wave survived... Welcome to the shop!")
  (terpri)
  (format t (concatenate 'string "Your money: $" (write-to-string score)))
  (terpri)
  (format t (concatenate 'string "Buy LATEST RUNNING SHOES for $" (write-to-string speed-cost) "? (y/n)"))
  (finish-output)
  (setf upgrade-input (read-line))
  (when (equal upgrade-input "y")
    (if (>= score speed-cost)
      (progn
        (setf score (- score speed-cost))
        (setf ps (+ ps 2))
        (setf speed-cost (* speed-cost 4))
        (format t "Speed upgraded.")
      )
      (format t "Not enough money!!!")
    )
  )
  (terpri)
  (terpri)
  (format t (concatenate 'string "Your money: $" (write-to-string score)))
  (terpri)
  (format t (concatenate 'string "Buy BULLET SHARPENERS for $" (write-to-string damage-cost) "? (y/n)"))
  (finish-output)
  (setf upgrade-input (read-line))
  (when (equal upgrade-input "y")
    (if (>= score damage-cost)
      (progn
        (setf score (- score damage-cost))
        (setf bullet-damage (+ bullet-damage 2))
        (setf damage-cost (* damage-cost 3))
        (format t "Damage upgraded.")
      )
      (format t "Not enough money!!!")
    )
  )
  (terpri)
  (terpri)
  (format t (concatenate 'string "Your money: $" (write-to-string score)))
  (terpri)
  (format t (concatenate 'string "Buy JITTERMAX MEGASPRESSO for $" (write-to-string firerate-cost) "? (y/n)"))
  (finish-output)
  (setf upgrade-input (read-line))
  (when (equal upgrade-input "y")
    (if (>= score firerate-cost)
      (progn
        (setf score (- score firerate-cost))
        (setf firerate (- firerate 5))
        (setf firerate-cost (* firerate-cost 5))
        (format t "Fire-rate upgraded.")
        (when (>= 0 firerate)
          (setf firerate 5)
          (terpri)
          (format t "FIRERATE MAXXED OUT!")
        )
      )
      (format t "Not enough money!!!")
    )
  )
  (terpri)
  (terpri)
  (format t (concatenate 'string "Your money: $" (write-to-string score)))
  (terpri)
  (format t (concatenate 'string "Buy STRAIGHT UP STEROIDS for $" (write-to-string health-cost) "? (y/n)"))
  (finish-output)
  (setf upgrade-input (read-line))
  (when (equal upgrade-input "y")
    (if (>= score health-cost)
      (progn
        (setf score (- score health-cost))
        (setf health (+ health 1))
        (setf health-cost (* health-cost 7))
        (format t "Health upgraded.")
      )
      (format t "Not enough money!!!")
    )
  )
  (terpri)
  (terpri)
  (format t "PRESS ENTER TO BEGIN ONSLAUGHT")
  (finish-output)
  (read-line)
)
