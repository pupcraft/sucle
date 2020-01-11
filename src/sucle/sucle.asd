(asdf:defsystem #:sucle
  :author "terminal625"
  :license "MIT"
  :description "Cube Demo Game, physics part,The voxel backend for testbed"
  :depends-on (
	       ;;;sucle
	       #:application
	       #:utility
	       #:text-subsystem


	       ;;<TESTBED>
	       ;;<SANDBOX>
	       #:cl-opengl
	       ;;#:utility
	       #:scratch-buffer
	       #:reverse-array-iterator
	       #:glhelp
	       #:nsb-cga
	       #:quads

	       
	       #:sucle-serialize
	       #:sucle-multiprocessing

	       #:aabbcc ;;for occlusion culling
	       
	       ;;</SANDBOX>
	      
	       #:image-utility
	       #:reverse-array-iterator
	       #:uncommon-lisp
	       #:fps-independent-timestep
	       ;;#:aabbcc
	       #:control
	       #:camera-matrix
	       #:alexandria
	       
	       ;;for world-generation
	       #:black-tie

	       ;;for the terrain picture
	       #:sucle-temp
	       ;;</TESTBED>

	       )
  :serial t
  :components 
  (
   ;;<SANDBOX>
   (:file "queue")
   (:file "package")
   (:file "world")
   (:file "persist-world") ;;world <-> filesystem
   (:file "block-data") ;;block data
   ;;(:file "block-light") ;;light propogation
   (:file "block-meshing");;world data -> mesh 
   (:file "change-world")
   ;;</SANDBOX>
   
   ;;<TESTBED>
   (:file "sandbox-subsystem")
   (:file "testbed")
   ;;</TESTBED>
   
   (:file "sucle")))