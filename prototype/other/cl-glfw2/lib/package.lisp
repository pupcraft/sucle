(defpackage #:cl-glfw
  (:nicknames #:glfw)
  (:use #:cl #:cffi #:cl-glfw-types)
  (:shadowing-import-from #:cl-glfw-types #:boolean #:byte #:float #:char #:string)
  (:shadow #:sleep
	   #:cond
	   #:enable #:disable)
  (:export #:%get-desktop-mode #:%get-gl-version #:%get-joystick-buttons #:%get-joystick-pos #:%get-mouse-pos #:%get-version #:%get-video-modes #:%get-window-size #:%init #:%open-window #:%set-char-callback #:%set-key-callback #:%set-mouse-button-callback #:%set-mouse-pos-callback #:%set-mouse-wheel-callback #:%set-window-close-callback #:%set-window-refresh-callback #:%set-window-size-callback #:%terminate #:+alpha-map-bit+ #:+build-mipmaps-bit+ #:+false+ #:+fullscreen+ #:+infinity+ #:+no-rescale-bit+ #:+origin-ul-bit+ #:+true+ #:+window+ #:broadcast-cond #:close-window #:create-cond #:create-mutex #:create-thread #:def-char-callback #:def-mouse-button-callback #:def-mouse-pos-callback #:def-mouse-wheel-callback #:def-set-key-callback #:def-window-close-callback #:def-window-refresh-callback #:def-window-size-callback #:destroy-cond #:destroy-mutex #:destroy-thread #:disable #:do-open-window #:do-window #:enable #:extension-supported #:free-image #:get-desktop-mode #:get-gl-version #:get-joystick-buttons #:get-joystick-param #:get-joystick-pos #:get-key #:get-mouse-button #:get-mouse-pos #:get-mouse-wheel #:get-number-of-processors #:get-proc-address #:get-thread-id #:get-time #:get-version #:get-video-modes #:get-window-param #:get-window-size #:iconify-window #:init #:load-memory-texture-2d #:load-texture-2d #:load-texture-image-2d #:lock-mutex #:open-window #:open-window-hint #:poll-events #:read-image #:read-memory-image #:restore-window #:set-char-callback #:set-key-callback #:set-mouse-button-callback #:set-mouse-pos #:set-mouse-pos-callback #:set-mouse-wheel #:set-mouse-wheel-callback #:set-time #:set-window-close-callback #:set-window-pos #:set-window-refresh-callback #:set-window-size #:set-window-size-callback #:set-window-title #:signal-cond #:sleep #:swap-buffers #:swap-interval #:terminate #:unlock-mutex #:wait-cond #:wait-events #:wait-thread #:with-init #:with-init-window #:with-lock-mutex #:with-open-window))


;;exports generated by this, after the package is loaded:
(quote
 (format t "~{#:~a~^ ~}" 
	 (sort (mapcar #'(lambda (s) (string-downcase (format nil "~a" s)))
		       (remove-if-not #'(lambda (s)
					  (and (eql (symbol-package s) (find-package '#:glfw))
					       (or (constantp s) (fboundp s) (macro-function s))))
				      (loop for s being each symbol in '#:glfw collecting s)))
	       #'string<)))
