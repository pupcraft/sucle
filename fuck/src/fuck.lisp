(in-package :fuck)


(progn
  (defparameter *backup* (make-hash-table :test 'eq))
  (defparameter *stuff* (make-hash-table :test 'eq))
  (defun bornfnc (name func)
    (namexpr *backup* name func))
  (defun getfnc (name)
    (get-stuff name *stuff* *backup*)))

(progn
  (defun namexpr (hash name func)
    (setf (gethash name hash) func))
  (defmacro ensure (place otherwise)
    (let ((value-var (gensym))
	  (exists-var (gensym)))
      `(or ,place
	   (multiple-value-bind (,value-var ,exists-var) ,otherwise
	     (if ,exists-var
		 (values (setf ,place ,value-var) ,exists-var))))))
  (defun get-stuff (name stuff otherwise)
    (ensure (gethash name stuff)
	    (let ((genfunc (gethash name otherwise)))
	      (when (functionp genfunc)
		(values (funcall genfunc) t))))))

(defparameter *sandbox-on* t)

(defun handoff-five ()
  (setf %gl:*gl-get-proc-address* (window:get-proc-address))
  (let ((hash *stuff*))
    (maphash (lambda (k v)
	       (if (integerp v)
		   (remhash k hash)))
	     hash))
  (window:set-vsync t)
  (when *sandbox-on*
    (sandbox::build-deps #'getfnc
			 #'bornfnc)
    (sandbox::initialization1))

  (injection3)) 

(defparameter *control-state* (window::make-control-state
			       :curr window::*input-state*))

(defun wasd-mover (w? a? s? d?)
  (let ((x 0)
	(y 0))
    (when w?
      (decf x))
    (when a?
      (decf y))
    (when s?
      (incf x))
    (when d?
      (incf y))
    (if (and (zerop x)
	     (zerop y))
	nil
	(atan y x))))

(defparameter *yaw* 0.0)
(defparameter *pitch* 0.0)

(defparameter *player-farticle* (sandbox::make-farticle))

(defparameter *farticles*
  (let ((array (make-array 10)))
    (map-into array (lambda () (sandbox::make-farticle)))
    array))


(defun num-key-jp (control-state)
  (let ((ans nil))
    (macrolet ((k (number-key)
		 (let ((symb (intern (write-to-string number-key) :keyword)))
		   `(when (window::skey-j-p (window::keyval ,symb) control-state)
		      (setf ans ,number-key)))))
      (k 1)
      (k 2)
      (k 3)
      (k 4)
      (k 5)
      (k 6)
      (k 7)
      (k 8)
      (k 9)
      (k 0))
    ans))

(defparameter *paused* nil)
(defun physss ()
  (window:poll)
  (window::update-control-state *control-state*)


  (when *sandbox-on*
    (let* ((player-farticle *player-farticle*)
	   (pos (sandbox::farticle-position player-farticle))
	   (control-state *control-state*))
      (let ((num (num-key-jp *control-state*)))
	(when num
	  (setf *player-farticle* (aref *farticles* num))))
      (sandbox::meta-controls control-state
			      pos)
      (when (window::skey-j-p (window::keyval :x) control-state)
	(toggle *paused*))
      (unless *paused*
	(sandbox::physics control-state *yaw*
			  (wasd-mover
			   (window::skey-p (window::keyval :w) control-state)
			   (window::skey-p (window::keyval :a) control-state)
			   (window::skey-p (window::keyval :s) control-state)
			   (window::skey-p (window::keyval :d) control-state))
			  player-farticle)
	(let ((backwardsbug (load-time-value (cg-matrix:vec 0.0 0.0 0.0))))
	  (cg-matrix:%vec* backwardsbug (sandbox::camera-vec-forward *camera*) -4.0)
	  (sandbox::use-fists control-state backwardsbug
			      pos))))))

(defparameter *ticker* nil)
(defparameter *realthu-nk* (lambda () (throw :end (values))))

(defparameter *camera* (sandbox::make-camera))
(defun set-render-cam-pos (camera partial curr prev)
  (let ((vec (sandbox::camera-vec-position camera))
	(cev (sandbox::camera-vec-noitisop camera)))
    (cg-matrix:%vec-lerp vec prev curr partial)
    (cg-matrix:%vec* cev vec -1.0)))

(progn
  (defun actual-stuuff ()
    (when window:*status*
      (throw :end (values)))
    (let ((ticker *ticker*))
      (tick-update ticker (fine-time))
      (tick-physics ticker (function physss))
      (let ((fraction (float (/ (ticker-accumulator ticker)
				(ticker-dt ticker)))))
	(gl:viewport 0 0 window:*width* window:*height*)
	(gl:clear
	 :color-buffer-bit
	 :depth-buffer-bit)
	(when *sandbox-on*
	  (progn
	    (dotimes (x 4) (window:poll))
	    (remove-spurious-mouse-input)
	    (window:poll)
	    (let ((camera *camera*))
	      (when (window:mice-locked-p)
		(multiple-value-bind (newyaw newpitch)
		    (multiple-value-call
			#'look-around
		      *yaw* *pitch*
		      (delta))
		  (when newyaw
		    (setf *yaw* newyaw))
		  (when newpitch
		    (setf *pitch* newpitch))))
	      (sandbox::unit-pitch-yaw (sandbox::camera-vec-forward camera)
				       (coerce *pitch* 'single-float)
				       (coerce *yaw* 'single-float))
	      (setf (sandbox::camera-aspect-ratio camera)
		    (/ window:*width* window:*height* 1.0))
	      (let* ((player-farticle *player-farticle*)
		     (pos (sandbox::farticle-position player-farticle))
		     (old (sandbox::farticle-position-old player-farticle)))
		
		(set-render-cam-pos camera fraction pos old))
	      (let ((defaultfov
		     (load-time-value ((lambda (deg)
					 (* deg (coerce (/ pi 180.0) 'single-float)))
				       70))))
		(setf (sandbox::camera-fov camera)
		      defaultfov))
	      (sandbox::update-matrices camera)
	      (sandbox::render camera
			       #'getfnc)))))
      (window:update-display)))
  (setf *realthu-nk* (function actual-stuuff)))

(defun injection3 ()
  (setf *ticker* (make-ticker :dt (floor 1000000 20)
		  :current-time (fine-time)))
  (catch (quote :end)
    (loop
       (funcall *realthu-nk*))))

(defparameter *thread* nil)
(defun main3 ()
  (setf *thread*
	(sb-thread:make-thread   
	 (lambda (stdo)
	   (let ((window::*iresizable* t)
		 (window::*iwidth* 256)
		 (window::*iheight* 256)
		 (*standard-output* stdo))
	     (window::wrapper #'handoff-five)))
	 :arguments  (list *standard-output*))))


;;;time in microseconds
(defun fine-time ()
  (multiple-value-bind (s m) (sb-ext:get-time-of-day)
    (+ (* (expt 10 6) (- s 1506020000)) m)))

#+nil
(defun define-time ()
  (eval
   `(defun fine-time ()
      (/ (%glfw::get-timer-value)
	 ,(/ (%glfw::get-timer-frequency) (float (expt 10 6)))))))




#+nil
(dotimes (x 128)
  (when (e::skey-j-p x *control-state*)
    (let ((char (code-char x)))
      (when (typep char 'standard-char)
	(princ char)))))


#+nil
((defparameter *old-scroll-y* 0.0)
 (defparameter net-scroll 0)
 (let ((new-scroll window::*scroll-y*))
   (setf *old-scroll-y* net-scroll)
   (setf net-scroll new-scroll)
   #+nil
   (let ((value (- new-scroll *old-scroll-y*)))
     (unless (zerop value)
					;(print value)
       ))))
