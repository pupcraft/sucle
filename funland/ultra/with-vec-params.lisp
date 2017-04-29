(in-package :fuktard)
(export (quote with-vec-params))
(defmacro with-vec-params ((&rest bufvars) (buf &optional (offset 0)) &body body)
  (let ((letargs nil)
	(counter 0))
    (dolist (sym bufvars)
      (if (consp sym)
	  (let ((var (car sym)))
	    (unless (null var)
	      (push `(,var (aref ,buf (the fixnum (+ ,offset ,(second sym))))) letargs)))  
	  (progn
	    (unless (null sym)
	      (push `(,sym (aref ,buf (the fixnum (+ ,offset ,counter))))
		    letargs))
	    (incf counter))))
    `(let ,letargs 
       ,@body)))