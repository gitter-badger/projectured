;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured.test)

;;;;;;
;;; Widget

(def function make-test-document/document (content)
  (document/document ()
    (document/clipboard ()
      content)))

(def function make-test-document/shell (content)
  (widget/shell ()
    content))

(def function make-test-document/plain (content)
  (widget/shell ()
    (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
      content)))

(def function make-test-document/selection (content)
  (widget/split-pane ()
    (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 640 720) :margin (make-inset :all 5))
      content)
    (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 640 720) :margin (make-inset :all 5))
      content)))

(def function make-test-document/split (content-1 content-2)
  (widget/shell ()
    (widget/split-pane ()
      (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 640 720) :margin (make-inset :all 5))
        content-1)
      (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 640 720) :margin (make-inset :all 5))
        content-2))))

(def function make-test-document/generic (content)
  (widget/shell ()
    (widget/split-pane ()
      (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 640 720) :margin (make-inset :all 5))
        content)
      (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 640 720) :margin (make-inset :all 5))
        content))))

(def function make-test-document/reflection (content projection)
  (widget/shell ()
    (widget/tabbed-pane ()
      ((widget/label (:location (make-2d 5 5) :margin (make-inset :all 5))
         (text/text ()
           (text/string "Document in Domain Specific Notation" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
       (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
         content))
      ((widget/label (:location (make-2d 5 5) :margin (make-inset :all 5))
         (text/text ()
           (text/string "Document in Generic Notation" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
       (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
         content))
      ((widget/label (:location (make-2d 5 5) :margin (make-inset :all 5))
         (text/text ()
           (text/string "Projection in Generic Notation" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
       (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
         projection))
      ((widget/label (:location (make-2d 5 5) :margin (make-inset :all 5))
         (text/text ()
           (text/string "Intermediate Documents in Generic Notation" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
       (make-widget/tabbed-pane
        (when (typep projection 'sequential)
          (iter (for element-projection :in-sequence (elements-of projection))
                ;; TODO:
                (repeat 1)
                (collect (list
                          (widget/label (:location (make-2d 5 5) :margin (make-inset :all 5))
                            (text/text ()
                              (text/string (object-class-symbol-name element-projection) :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
                          (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
                            content)))))
        0)))))

(def function make-test-document/ide (content)
  (widget/shell ()
    (widget/split-pane ()
      (make-file-system/pathname (asdf:system-relative-pathname :projectured "test/"))
      (widget/tabbed-pane ()
        ((widget/label (:location (make-2d 5 5) :margin (make-inset :all 5))
           (text/text ()
             (text/string "Document" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
         (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
           content))))))

;;;;;;
;;; Debug

(def document test/debug ()
  ((content :type t)
   (last-commands :type sequence)))

(def macro test/debug (() &body content)
  `(make-instance 'test/debug :content ,(first content) :last-commands nil))

(def function make-test-document/debug (content)
  (test/debug ()
    content))

;;;;;;
;;; Graphics

(def function make-test-document/graphics/empty ()
  (make-graphics/canvas nil (make-2d 0 0)))

(def function make-test-document/graphics ()
  (make-graphics/canvas (list (make-graphics/viewport (make-graphics/canvas (list (make-graphics/point (make-2d 50 150) :stroke-color *color/red*)
                                                                                  (make-graphics/line (make-2d 150 300) (make-2d 50 400) :stroke-color *color/blue*)
                                                                                  (make-graphics/rectangle (make-2d 200 200) (make-2d 100 100) :stroke-color *color/green*)
                                                                                  (make-graphics/rounded-rectangle (make-2d 120 180) (make-2d 50 50) 10 :fill-color *color/dark-yellow*)
                                                                                  (make-graphics/polygon (list (make-2d 150 100) (make-2d 160 160) (make-2d 100 150)) :stroke-color *color/black*)
                                                                                  (make-graphics/circle (make-2d 50 250) 50 :stroke-color *color/black* :fill-color *color/blue*)
                                                                                  (make-graphics/ellipse (make-2d 50 50) (make-2d 100 50) :stroke-color *color/red*)
                                                                                  (make-graphics/text (make-2d 200 150) "hello world" :font *font/default* :font-color *color/default* :fill-color *color/light-cyan*)
                                                                                  (make-graphics/image (make-2d 300 0) (make-image/image (asdf:system-relative-pathname :projectured "etc/projectured.png"))))
                                                                            (make-2d 0 0))
                                                      (make-2d 50 50)
                                                      (make-2d 700 400))
                              (make-graphics/rectangle (make-2d 50 50)
                                                       (make-2d 700 400)
                                                       :stroke-color *color/red*))
                        (make-2d 0 0)))

;;;;;;
;;; String

(def function make-test-document/string/empty ()
  "")

(def function make-test-document/string ()
  "just a simple string")

;;;;;;
;;; Styled string

(def function make-test-document/text ()
  (text/text ()
    (text/string "Hello" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/red*)
    (text/spacing 10 :unit :space)
    ;;(image/image () (asdf:system-relative-pathname :projectured "etc/lisp-flag.jpg"))
    (text/string "World" :font *font/ubuntu/monospace/bold/18* :font-color *color/solarized/green*)
    (text/newline)
    (text/string "New line" :font *font/ubuntu/bold/24* :font-color *color/solarized/blue*)))

;;;;;;
;;; Text

(def function make-test-document/text/empty ()
  (text/text ()
    (text/string "")))

;;;;;;
;;; Widget

(def function make-test-document/widget/menu ()
  (widget/menu ()
    (widget/menu-item ()
      (text/text ()
        (text/string "Open")))
    (widget/menu-item ()
      (text/text ()
        (text/string "Save")))
    (widget/menu-item ()
      (text/text ()
        (text/string "Quit")))))

;;;;;;
;;; List

(def function make-test-document/list/empty ()
  (list/list ()))

(def function make-test-document/list ()
  (list/list ()
    (list/element ()
      (text/text ()
        (text/string "first element in a list")))
    (list/element ()
      (text/text ()
        (text/string "second element in a list")))))

;;;;;;
;;; Table

(def function make-test-document/table/empty ()
  (table/table ()))

(def function make-test-document/table ()
  (table/table ()
    (table/row ()
      (table/cell ()
        (text/text ()
          (text/string "1st row 1st cell 1st line (padding)" :font *font/default* :font-color *color/default*)
          (text/newline)
          (text/string "1st row 1st cell 2nd line" :font *font/default* :font-color *color/default*)))
      (table/cell ()
        (text/text ()
          (text/string "1st row 2nd cell 1st line" :font *font/default* :font-color *color/default*))))
    (table/row ()
      (table/cell ()
        (text/text ()
          (text/string "2nd row 1st cell 1st line" :font *font/default* :font-color *color/default*)))
      (table/cell ()
        (text/text ()
          (text/string "2nd row 2nd cell 1st line" :font *font/default* :font-color *color/default*)
          (text/newline)
          (text/string "2nd row 1st cell 2nd line (padding)" :font *font/default* :font-color *color/default*))))))

(def function make-test-document/table/nested ()
  (table/table ()
    (table/row ()
      (table/cell ()
        (table/table ()
          (table/row ()
            (table/cell ()
              (text/text ()
                (text/string "Inner A1" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner B1" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner C1" :font *font/default* :font-color *color/default*))))
          (table/row ()
            (table/cell ()
              (text/text ()
                (text/string "Inner A2" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner B2" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner C2" :font *font/default* :font-color *color/default*))))
          (table/row ()
            (table/cell ()
              (text/text ()
                (text/string "Inner A3" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner B3" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner C3" :font *font/default* :font-color *color/default*))))))
      (table/cell ()
        (text/text ()
          (text/string "Outer top right cell" :font *font/default* :font-color *color/default*))))
    (table/row ()
      (table/cell ()
        (text/text ()
          (text/string "Outer bottom left cell" :font *font/default* :font-color *color/default*)))
      (table/cell ()
        (table/table ()
          (table/row ()
            (table/cell ()
              (text/text ()
                (text/string "Inner A1" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner B1" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner C1" :font *font/default* :font-color *color/default*))))
          (table/row ()
            (table/cell ()
              (text/text ()
                (text/string "Inner A2" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner B2" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner C2" :font *font/default* :font-color *color/default*))))
          (table/row ()
            (table/cell ()
              (text/text ()
                (text/string "Inner A3" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner B3" :font *font/default* :font-color *color/default*)))
            (table/cell ()
              (text/text ()
                (text/string "Inner C3" :font *font/default* :font-color *color/default*)))))))))

;;;;;;
;;; Tree

(def function make-test-document/tree/empty ()
  nil)

(def function make-test-document/tree/leaf ()
  (tree/leaf (:opening-delimiter (text/text () (text/string "\"")) :closing-delimiter (text/text () (text/string "\"")))
    (text/text ()
      (text/string "Hello"))))

(def function make-test-document/tree/node ()
  (tree/node ()))

(def function make-test-document/tree ()
  (tree/node (:opening-delimiter (text/text () (text/string "(")) :closing-delimiter (text/text () (text/string ")")) :separator (text/text () (text/string " ")))
    (tree/leaf ()
      (text/text ()
        (text/string "first")))
    (tree/node (:opening-delimiter (text/text () (text/string "(")) :closing-delimiter (text/text () (text/string ")")) :separator (text/text () (text/string " ")) :indentation 1)
      (tree/leaf ()
        (text/text ()
          (text/string "second")))
      (tree/leaf ()
        (text/text ()
          (text/string "third"))))
    (tree/leaf (:indentation 1)
      (text/text ()
        (text/string "fourth")))
    (tree/node (:opening-delimiter (text/text () (text/string "(")) :closing-delimiter (text/text () (text/string ")")) :separator (text/text () (text/string " ")) :indentation 1)
      (tree/leaf ()
        (text/text ()
          (text/string "fifth")))
      (tree/node (:opening-delimiter (text/text () (text/string "(")) :closing-delimiter (text/text () (text/string ")")) :separator (text/text () (text/string " ")) :indentation 1)
        (tree/leaf ()
          (text/text ()
            (text/string "sixth")))
        (tree/leaf ()
          (text/text ()
            (text/string "seventh"))))
      (tree/leaf (:indentation 1)
        (text/text ()
          (text/string "eigth"))))
    (tree/leaf (:indentation 1)
      (text/text ()
        (text/string "nineth")))))

;;;;;;
;;; Graph

(def function make-test-document/graph ()
  (bind ((vertex1 (make-graph/vertex "A"))
         (vertex2 (make-graph/vertex "B"))
         (vertex3 (make-graph/vertex "C"))
         (edge12 (make-graph/edge vertex1 vertex2))
         (edge13 (make-graph/edge vertex1 vertex3))
         (edge23 (make-graph/edge vertex2 vertex3)))
    (make-graph/graph (list vertex1 vertex2 vertex3) (list edge12 edge13 edge23))))

;;;;;;
;;; State machine

(def function make-test-document/state-machine ()
  (bind ((start-state (make-state-machine/state "Start"))
         (a-state (make-state-machine/state "A"))
         (b-state (make-state-machine/state "B"))
         (fail-state (make-state-machine/state "Fail")))
    (make-state-machine/state-machine "AB"
                                      (list start-state a-state b-state fail-state)
                                      (list (make-state-machine/transition "Start->A" "a" start-state a-state)
                                            (make-state-machine/transition "Start->B" "b" start-state b-state)
                                            (make-state-machine/transition "A->B" "b" a-state b-state)
                                            (make-state-machine/transition "B->A" "a" b-state a-state)
                                            (make-state-machine/transition "A->Fail" "a" a-state fail-state)
                                            (make-state-machine/transition "B->Fail" "b" b-state fail-state)))))

;;;;;;
;;; Book

(def function make-test-document/book/empty ()
  (book/book (:title"")))

(def function make-test-document/book ()
  (book/book (:title "Lorem ipsum" :authors (list "me"))
    (book/chapter (:title "Chapter 1")
      (book/paragraph ()
        (text/text ()
          (text/string "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras eu nunc nibh. Cras imperdiet faucibus tortor ac dictum. Aliquam sit amet justo nec ligula lobortis ornare. Aenean a odio id dolor adipiscing interdum. Maecenas nec nisl neque. Suspendisse interdum rutrum neque, in volutpat orci varius in. Praesent a ipsum ac erat pulvinar adipiscing quis sit amet magna. Etiam semper vulputate mi ac interdum. Nunc a tortor non purus fringilla aliquam."))))
    (book/chapter (:title "Chapter 2")
      (book/paragraph ()
        (text/text ()
          (text/string "Morbi scelerisque, felis a viverra pharetra, arcu enim aliquet urna, mollis suscipit felis elit in neque. Aenean vel tempus nulla. Vestibulum magna nisi, cursus vel auctor eu, suscipit sit amet purus. Donec ligula purus, pulvinar id tristique ut, suscipit ornare diam. Maecenas sed justo turpis. Vivamus eu scelerisque dui. Pellentesque mollis rutrum est ac tempus. Sed venenatis, erat id elementum semper, nisl tortor malesuada orci, ac venenatis elit ipsum non augue. Praesent blandit purus est, id venenatis eros. Phasellus non dui dolor. Duis magna erat, pulvinar sed aliquam vitae, porta vel quam."))))))

;;;;;;
;;; XML

(def function make-test-document/xml/empty ()
  nil)

(def function make-test-document/xml/text ()
  (xml/text () "The beginning"))

(def function make-test-document/xml/attribute ()
  (xml/attribute () "name" "levy"))

(def function make-test-document/xml ()
  (xml/element ("person" ((xml/attribute () "name" "levy")
                          (xml/attribute () "sex" "male")))
    (xml/text () "The beginning")
    (xml/element ("children" ())
      (xml/element ("person" ((xml/attribute () "name" "John")
                              (xml/attribute () "sex" "female"))))
      (xml/element ("person" ((xml/attribute () "name" "Mary")
                              (xml/attribute () "sex" "male")))))
    (xml/element ("pets" ()))
    (xml/text () "The end")))

;;;;;;
;;; JSON

(def function make-test-document/json/empty ()
  (json/nothing ()))

(def function make-test-document/json/null ()
  (json/null ()))

(def function make-test-document/json/boolean ()
  (json/boolean () #f))

(def function make-test-document/json/number ()
  (json/number () 42))

(def function make-test-document/json/string ()
  (json/string () "Hello World"))

(def function make-test-document/json/array ()
  (json/array ()
    (json/null ())
    (json/boolean () #f)
    (json/boolean ()#t)
    (json/number () 42)
    (json/string () "Hello World")))

(def function make-test-document/json/object ()
  (json/object ()
    ("null" (json/null ()))
    ("false" (json/boolean () #f))
    ("true" (json/boolean ()#t))
    ("number" (json/number () 42))
    ("string" (json/string () "Hello World"))))

(def function make-test-document/json ()
  (json/array ()
    (json/null ())
    (json/boolean () #f)
    (json/boolean ()#t)
    (json/number () 42)
    (json/string () "Hello World")
    (json/object ()
      ("null" (json/null ()))
      ("false" (json/boolean () #f))
      ("true" (json/boolean ()#t))
      ("number" (json/number () 42))
      ("string" (json/string () "Hello World"))
      ("array" (json/array ()
                 (json/null ())
                 (json/boolean () #f)
                 (json/boolean ()#t)
                 (json/number () 42)
                 (json/string () "Hello World"))))))

;;;;;;
;;; File system

(def function make-test-document/file-system ()
  (make-file-system/pathname (asdf:system-relative-pathname :projectured "source/")))

;;;;;;
;;; Java

(def function make-test-document/java/empty ()
  nil)

(def function make-test-document/java ()
  (make-java/definition/method (make-java/definition/qualifier "public")
                                (make-java/definition/type "int")
                                "factorial"
                                (list (make-java/definition/argument "n" (make-java/definition/type "int")))
                                (make-java/statement/block (list (make-java/statement/if (make-java/expression/infix-operator "==" (list (make-java/expression/variable-reference "n")
                                                                                                                                         (make-java/literal/number 0)))
                                                                                         (make-java/statement/return (make-java/literal/number 1))
                                                                                         (make-java/statement/return (make-java/expression/infix-operator "*" (list (make-java/expression/variable-reference "n")
                                                                                                                                                                    (make-java/expression/method-invocation "factorial"
                                                                                                                                                                                                            (list (make-java/expression/infix-operator "-" (list (make-java/expression/variable-reference "n")
                                                                                                                                                                                                                                                                 (make-java/literal/number 1)))))))))))))

;;;;;;
;;; Javascript

(def function make-test-document/javascript ()
  (make-javascript/statement/top-level
   (list (make-javascript/expression/method-invocation
          (make-javascript/expression/variable-reference "google")
          "load"
          (list (make-javascript/literal/string "visualization")
                (make-javascript/literal/string "1")))
         (make-javascript/expression/method-invocation
          (make-javascript/expression/variable-reference "google")
          "setOnLoadCallback"
          (list (make-javascript/expression/variable-reference "drawPieChart")))
         (make-javascript/definition/function
          "drawPieChart"
          nil
          (make-javascript/statement/block
           (list (make-javascript/definition/variable
                  "json"
                  (make-javascript/expression/property-access
                   (make-javascript/expression/method-invocation
                    (make-javascript/expression/variable-reference "$")
                    "ajax" nil)
                   "responseText"))
                 (make-javascript/definition/variable
                  "data"
                  (make-javascript/expression/constuctor-invocation
                   (make-javascript/expression/property-access
                    (make-javascript/expression/property-access
                     (make-javascript/expression/variable-reference "google")
                     "visualization")
                    "DataTable")
                   (list (make-javascript/expression/variable-reference "json"))))
                 (make-javascript/definition/variable
                  "chart"
                  (make-javascript/expression/constuctor-invocation
                   (make-javascript/expression/property-access
                    (make-javascript/expression/property-access
                     (make-javascript/expression/variable-reference "google")
                     "visualization")
                    "PieChart")
                   (list (make-javascript/expression/method-invocation
                          (make-javascript/expression/variable-reference "document")
                          "getElementById"
                          (list (make-javascript/literal/string "pie"))))))
                 (make-javascript/expression/method-invocation
                  (make-javascript/expression/variable-reference "chart")
                  "draw"
                  (list (make-javascript/expression/variable-reference "data")))))))))

;;;;;;
;;; Lisp form

(def function make-test-document/lisp-form/empty ()
  nil)

(def function make-test-document/lisp-form ()
  (make-lisp-form/list (list (make-lisp-form/string "quoted list")
                             (make-lisp-form/number 3.1415)
                             (make-lisp-form/list (list (make-lisp-form/symbol "sub" nil)
                                                        (make-lisp-form/list (list (make-lisp-form/symbol "deep" nil) (make-lisp-form/symbol "list" nil)))
                                                        (make-lisp-form/number 42)
                                                        (make-lisp-form/number 43)))
                             (make-lisp-form/object (make-string-output-stream)))))

;;;;;;
;;; Common lisp

(def function test-dynamic-environment-provider (thunk)
  (hu.dwim.stefil::with-new-global-context* (:debug-on-assertion-failure-p #f :debug-on-unexpected-error-p #f :print-test-run-progress-p #f :record-success-descriptions-p #t)
    (bind ((test-result (nth-value 1 (hu.dwim.stefil::run-test-body (make-instance 'hu.dwim.stefil::test :name (gensym) :package *package*) thunk nil t nil))))
      (make-test/result (map 'list 'hu.dwim.stefil::form-of (remove-if (of-type 'hu.dwim.stefil::unexpected-error) (hu.dwim.stefil::failure-descriptions-of test-result)))
                        (map 'list 'hu.dwim.stefil::form-of (hu.dwim.stefil::success-descriptions-of test-result))
                        (awhen (find-if (of-type 'hu.dwim.stefil::unexpected-error) (hu.dwim.stefil::failure-descriptions-of test-result))
                          (hu.dwim.stefil::condition-of it))))))

(def function make-test-document/common-lisp/empty ()
  nil)

(def function make-test-document/common-lisp (&optional faulty)
  (bind ((factorial-argument (make-common-lisp/required-function-argument (make-lisp-form/symbol* 'n)))
         (factorial-function (make-common-lisp/function-definition (make-lisp-form/symbol (if faulty "FACTORAL" "FACTORIAL") "PROJECTURED.TEST")
                                                                   (list factorial-argument)
                                                                   nil
                                                                   :allow-other-keys #f
                                                                   :documentation "Computes the factorial of N")))
    (setf (body-of factorial-function)
          (list (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* '<)
                                                                   (list (make-common-lisp/variable-reference factorial-argument)
                                                                         (make-common-lisp/constant (if faulty 3 2))))
                                     (make-common-lisp/constant 1)
                                     (make-common-lisp/application (make-lisp-form/symbol* (if faulty '+ '*))
                                                                   (list (make-common-lisp/variable-reference factorial-argument)
                                                                         (make-common-lisp/application (make-common-lisp/function-reference factorial-function)
                                                                                                       (list (make-common-lisp/application
                                                                                                              (make-lisp-form/symbol* '-)
                                                                                                              (list (make-common-lisp/variable-reference factorial-argument)
                                                                                                                    (make-common-lisp/constant 1))))))))))
    factorial-function))

(def function make-test-document/common-lisp/test (&optional (faulty #t))
  (bind ((factorial-function (make-test-document/common-lisp faulty)))
    (book/book (:title "Literate programming with continuous testing")
      (book/chapter (:title "Specification")
        (book/paragraph ()
          (text/text ()
            (text/string "The factorial of a non-negative integer " :font *font/liberation/serif/regular/24*)
            (text/string "N" :font *font/liberation/serif/italic/24* :font-color *color/solarized/violet*)
            (text/string " is the product of all positive integers less than or equal to " :font *font/liberation/serif/regular/24*)
            (text/string "N" :font *font/liberation/serif/italic/24* :font-color *color/solarized/violet*)
            (text/string "." :font *font/liberation/serif/regular/24*))))
      (book/chapter (:title "Implementation")
        (book/paragraph ()
          (text/text ()
            (text/string "The " :font *font/liberation/serif/regular/24*)
            (text/string "Common Lisp" :font *font/liberation/serif/italic/24* :font-color *color/solarized/violet*)
            (text/string " factorial function computes the result using recursion." :font *font/liberation/serif/regular/24*)))
        (make-evaluator/evaluator factorial-function))
      (book/chapter (:title "Test")
        (book/paragraph ()
          (text/text ()
            (text/string "The " :font *font/liberation/serif/regular/24*)
            (text/string "Common Lisp" :font *font/liberation/serif/italic/24* :font-color *color/solarized/violet*)
            (text/string " test program checks the result for all integers between " :font *font/liberation/serif/regular/24*)
            (text/string "0" :font *font/liberation/serif/regular/24* :font-color *color/solarized/magenta*)
            (text/string " and " :font *font/liberation/serif/regular/24*)
            (text/string "10" :font *font/liberation/serif/regular/24* :font-color *color/solarized/magenta*)
            (text/string "." :font *font/liberation/serif/regular/24*)))
        (bind ((evaluator (make-evaluator/evaluator nil :dynamic-environment-provider 'test-dynamic-environment-provider)))
          (setf (form-of evaluator) (make-common-lisp/progn (append (iter (for i :from 0 :to 8)
                                                                          (collect (make-test/check (make-common-lisp/application (make-lisp-form/symbol* '=)
                                                                                                                                  (list (make-common-lisp/application (make-common-lisp/function-reference factorial-function)
                                                                                                                                                                      (list (make-common-lisp/constant i)))
                                                                                                                                        (make-common-lisp/constant (alexandria::factorial i))))
                                                                                                    evaluator)))
                                                                    (list (make-test/check (make-common-lisp/application (make-lisp-form/symbol* '=)
                                                                                                                         (list (make-common-lisp/application (make-common-lisp/function-reference factorial-function)
                                                                                                                                                             (list (make-common-lisp/constant 9)))
                                                                                                                               (make-common-lisp/constant 3628800)))
                                                                                           evaluator)
                                                                          (make-test/check (make-common-lisp/application (make-lisp-form/symbol* '=)
                                                                                                                         (list (make-common-lisp/application (make-common-lisp/function-reference factorial-function)
                                                                                                                                                             (list (make-common-lisp/constant 10)))
                                                                                                                               (make-common-lisp/constant 3628800)))
                                                                                           evaluator)))))
          evaluator)))))

(def function make-test-document/common-lisp/search ()
  (document/search ()
    (make-test-document/common-lisp)))

(def function make-test-document/common-lisp/split ()
  (bind ((test-document (make-test-document/common-lisp/test #f)))
    (make-test-document/split (document/search () test-document) test-document)))

;;;;;;
;;; Evaluator

(def function make-test-document/evaluator ()
  ;; TODO:
  #+nil
  (hu.dwim.walker:walk-form '(* 2 (+ 3 4) (- 5 6))))

;;;;;;
;;; Test

(def function factorial (n)
  (if (< n 2)
      1
      (* n (factorial (- n 1)))))

(def test test/factorial ()
  (is (= 1 (factorial 0)))
  (is (= 1 (factorial 1)))
  (is (= 2 (factorial 2)))
  (is (= 6 (factorial 3)))
  (is (= 24 (factorial 4))))

(def function make-test-document/test ()
  (find-test 'test/factorial))

;;;;;;
;;; T

(def function make-test-document/t/null ()
  nil)

(def function make-test-document/t/cons ()
  (cons "Hello World" nil))

(def class* test-object ()
  ((test-instance-slot)
   (test-class-slot :allocation :class)))

(def function make-test-document/t/object ()
  (make-instance 'test-object :test-class-slot "class slot value" :test-instance-slot "instance slot value"))

(def function make-test-document/t/object/nested ()
  (make-instance 'test-object
                 :test-class-slot "class slot value"
                 :test-instance-slot (make-instance 'test-object :test-class-slot "class slot value" :test-instance-slot "instance slot value")))

;;;;;;
;;; Inspector

(def function make-test-document/inspector/object ()
  (make-inspector/object (make-test-document/t/object)))

(def function make-test-document/inspector/object/nested ()
  (make-inspector/object (make-test-document/t/object/nested)))

;;;;;;
;;; Demo

(def function make-test-document/introduction ()
  (text/text ()
    (text/string "ProjecturEd is a generic purpose projectional editor written in Common Lisp. It provides editing for different problem domains represented in unrestricted arbitrary data structures. It uses multiple bidirectional projections providing different notations varying from textual to graphics." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
    (text/newline)
    (image/image () (asdf:system-relative-pathname :projectured "etc/lisp-boxed-alien.jpg"))
    (text/newline)
    (text/string "Visit " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
    (text/string "http://projectured.org" :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*)
    (text/string " or " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
    (text/string "http://github.com/projectured/projectured" :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*)
    (text/string " for more information." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))

(def function make-test-document/demo ()
  (bind ((chart-page-path (make-adjustable-string "/page"))
         (chart-css-path (make-adjustable-string "/style"))
         (chart-data-path (make-adjustable-string "/data"))
         (chart-script-path (make-adjustable-string "/script"))
         (trace-amounts (make-common-lisp/comment
                         (text/text ()
                           (text/string "This part contains trace amounts of " :font projectured::*font/ubuntu/regular/18* :font-color *color/solarized/gray*)
                           (image/image () (asdf:system-relative-pathname :projectured "etc/lisp-flag.jpg")))))
         (chart-script (make-javascript/statement/top-level
                        (list (make-javascript/expression/method-invocation
                               (make-javascript/expression/variable-reference "google")
                               "load"
                               (list (make-javascript/literal/string "visualization")
                                     (make-javascript/literal/string "1")
                                     (json/object ()
                                       ("packages" (json/array () (json/string () "corechart"))))))
                              (make-javascript/expression/method-invocation
                               (make-javascript/expression/variable-reference "google")
                               "setOnLoadCallback"
                               (list (make-javascript/expression/variable-reference "drawPieChart")))
                              (make-javascript/definition/function
                               "drawPieChart"
                               nil
                               (make-javascript/statement/block
                                (list (make-javascript/definition/variable
                                       "json"
                                       (make-javascript/expression/property-access
                                        (make-javascript/expression/method-invocation
                                         (make-javascript/expression/variable-reference "$")
                                         "ajax"
                                         (list (json/object ()
                                                 ("async" (json/boolean () #f))
                                                 ("url" (json/string () chart-data-path))
                                                 ("dataType" (json/string () "json")))))
                                        "responseText"))
                                      (make-javascript/definition/variable
                                       "data"
                                       (make-javascript/expression/constuctor-invocation
                                        (make-javascript/expression/property-access
                                         (make-javascript/expression/property-access
                                          (make-javascript/expression/variable-reference "google")
                                          "visualization")
                                         "DataTable")
                                        (list (make-javascript/expression/variable-reference "json"))))
                                      (make-javascript/definition/variable
                                       "chart"
                                       (make-javascript/expression/constuctor-invocation
                                        (make-javascript/expression/property-access
                                         (make-javascript/expression/property-access
                                          (make-javascript/expression/variable-reference "google")
                                          "visualization")
                                         "PieChart")
                                        (list (make-javascript/expression/method-invocation
                                               (make-javascript/expression/variable-reference "document")
                                               "getElementById"
                                               (list (make-javascript/literal/string "pie"))))))
                                      (make-javascript/expression/method-invocation
                                       (make-javascript/expression/variable-reference "chart")
                                       "draw"
                                       (list (make-javascript/expression/variable-reference "data")
                                             (json/object ()
                                               ("title" (json/string () "Daily Activities"))
                                               ("is3D" (json/boolean () #t)))))))))))
         (dispatch-table (table/table ()
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string "HTTP request" :font *font/ubuntu/monospace/bold/18* :font-color *color/solarized/gray*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "HTTP response" :font *font/ubuntu/monospace/bold/18* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-page-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the HTML page that contains the pie chart" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-css-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the CSS stylesheet that contains the page style" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-script-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the JavaScript that dynamically creates the pie chart" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-data-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the JSON data that is displayed by the pie chart" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string "<otherwise>" :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the HTML error page" :font *font/default* :font-color *color/solarized/gray*))))))
         (chart-css (css/rule ("h1")
                      (css/attribute () "color" "#DC322F")
                      (css/attribute () "text-align" "center")))
         (chart-page (xml/element ("html" ())
                       (xml/element ("head" ())
                         (xml/element ("title" nil)
                           (xml/text () "Pie Chart Demo"))
                         (xml/element ("link" ((xml/attribute () "type" "text/css") (xml/attribute () "rel" "stylesheet") (xml/attribute () "href" chart-css-path))))
                         (xml/element ("script" ((xml/attribute () "type" "text/javascript") (xml/attribute () "src" "https://www.google.com/jsapi"))))
                         (xml/element ("script" ((xml/attribute () "type" "text/javascript") (xml/attribute () "src" "https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"))))
                         (xml/element ("script" ((xml/attribute () "type" "text/javascript") (xml/attribute () "src" chart-script-path)))))
                       (xml/element ("body" ())
                         (xml/element ("h1" ())
                           (xml/text () "Pie Chart Demo"))
                         (xml/element ("div" ((xml/attribute () "id" "pie") (xml/attribute () "style" "width: 800px; height: 600px;")))))))
         (chart-data (json/object ()
                       ("cols" (json/array ()
                                 (json/object ()
                                   ("label" (json/string () "Task"))
                                   ("type" (json/string () "string")))
                                 (json/object ()
                                   ("label" (json/string () "Hours per Day"))
                                   ("type" (json/string () "number")))))
                       ("rows" (json/array ()
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Work")))
                                          (json/object ()
                                            ("v" (json/number () 11))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Eat")))
                                          (json/object ()
                                            ("v" (json/number () 2))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Commute")))
                                          (json/object ()
                                            ("v" (json/number () 2))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Watch TV")))
                                          (json/object ()
                                            ("v" (json/number () 2))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Sleep")))
                                          (json/object ()
                                            ("v" (json/number () 7))))))))))
         (request-variable (make-common-lisp/required-function-argument (make-lisp-form/symbol* 'request)))
         (path-variable (make-common-lisp/lexical-variable-binding (make-lisp-form/symbol* 'path) (make-common-lisp/application (make-lisp-form/symbol "RAW-URI-OF" "HU.DWIM.WEB-SERVER")
                                                                                                                                (list (make-common-lisp/variable-reference request-variable)))))
         (error-page (xml/element ("html" ())
                       (xml/element ("head" ())
                         (xml/element ("title" ())
                           (xml/text () "Error 404 (Not Found)")))
                       (xml/element ("body" ())
                         (xml/element ("p" ())
                           (xml/text () "We are sorry, the '")
                           (xml/element ("i" ()) (make-common-lisp/progn (list trace-amounts (make-common-lisp/application (make-lisp-form/symbol* 'write-string) (list (make-common-lisp/variable-reference path-variable))))))
                           (xml/text () "' page is not found.")))))
         (server-variable (make-common-lisp/special-variable-definition (make-lisp-form/symbol "*DEMO-SERVER*" "PROJECTURED.TEST")
                                                                        (make-common-lisp/application (make-lisp-form/symbol* 'make-instance)
                                                                                                      (list (make-common-lisp/constant (find-symbol "SERVER" "HU.DWIM.WEB-SERVER"))
                                                                                                            (make-common-lisp/constant :host) (make-common-lisp/variable-reference (make-common-lisp/special-variable-definition (make-lisp-form/symbol "+ANY-HOST+" "IOLIB.SOCKETS") nil))
                                                                                                            (make-common-lisp/constant :port) (make-common-lisp/constant 8080)
                                                                                                            (make-common-lisp/constant :handler)
                                                                                                            (make-common-lisp/lambda-function nil (list (make-common-lisp/application (make-lisp-form/symbol "SEND-RESPONSE" "HU.DWIM.WEB-SERVER")
                                                                                                                                                                                      (list (make-common-lisp/application (make-lisp-form/symbol "MAKE-FUNCTIONAL-RESPONSE*" "HU.DWIM.WEB-SERVER")
                                                                                                                                                                                                                          (list (make-common-lisp/lambda-function nil (list (make-common-lisp/application (make-lisp-form/symbol* 'process-http-request) (list (make-common-lisp/variable-reference (make-common-lisp/special-variable-definition (make-lisp-form/symbol "*REQUEST*" "HU.DWIM.WEB-SERVER") nil))))))))))))))))
         (process-http-function (make-common-lisp/function-definition (make-lisp-form/symbol* 'process-http-request)
                                                                      (list request-variable)
                                                                      (list (make-common-lisp/comment
                                                                             (text/text ()
                                                                               (text/string "dispatch on the path of the incoming HTTP request according to the following table" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*)
                                                                               (text/newline)))
                                                                            dispatch-table
                                                                            (make-common-lisp/let (list path-variable (make-common-lisp/lexical-variable-binding (make-lisp-form/symbol* '*standard-output*) (make-common-lisp/application (make-lisp-form/symbol "CLIENT-STREAM-OF" "HU.DWIM.WEB-SERVER")
                                                                                                                                                                                                                                           (list (make-common-lisp/variable-reference request-variable)))))
                                                                                                  (list (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                           (list (make-common-lisp/constant chart-page-path)
                                                                                                                                                                 (make-common-lisp/variable-reference path-variable)))
                                                                                                                             chart-page
                                                                                                                             (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                                                (list (make-common-lisp/constant chart-css-path)
                                                                                                                                                                                      (make-common-lisp/variable-reference path-variable)))
                                                                                                                                                  chart-css
                                                                                                                                                  (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                                                                     (list (make-common-lisp/constant chart-script-path)
                                                                                                                                                                                                           (make-common-lisp/variable-reference path-variable)))
                                                                                                                                                                       chart-script
                                                                                                                                                                       (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                                                                                          (list (make-common-lisp/constant chart-data-path)
                                                                                                                                                                                                                                (make-common-lisp/variable-reference path-variable)))
                                                                                                                                                                                            chart-data
                                                                                                                                                                                            error-page)))))))
                                                                      :allow-other-keys #f
                                                                      :documentation nil)))
    (book/book (:title "A Web Service Demo" :authors (list "Levente Mészáros"))
      (book/chapter (:title "Introduction to ProjecturEd")
        (book/paragraph ()
          (make-test-document/introduction)))
      (book/chapter (:title "Problem Description")
        (book/paragraph ()
          (text/text ()
            (text/string "This example demonstrates mixing multiple different problem domains in the same document. The document contains" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " Common Lisp, HTML, CSS, JavaScript, JSON, table, image and styled text" :font projectured::*font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string " nested into each other. It describes a web service implemented as a single Common Lisp function that processes HTTP requests. When the function receives a request to the '" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string chart-page-path :font *font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string "' path it sends an HTML page in response. This page contains a pie chart that utilizes the Google Charts JavaScript API. When the browser displays the pie chart it sends another request to the '" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string chart-data-path :font *font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string "' path using JavaScript. For this request the web service returns another document in JSON format that provides the data for the pie chart. For all other unknown requests the web service sends an HTML error page. The following screenshot shows how the pie chart should look like." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/newline)
            (image/image () (asdf:system-relative-pathname :projectured "etc/pie.png"))
            (text/newline)
            (text/string "This example uses a compound projection that displays all used domains in their natural notation. Proper indentation and syntax highlight are automatically provided without inserting escape sequences that would make reading harder. Note that the edited document" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " is not text" :font projectured::*font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string " even though it looks like. It's a complex domain specific data structure that precisely captures the intentions. The projections keep track of what is what to make navigation and editing possible." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
      (book/chapter (:title "Chart Page")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the chart page" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-page)
      (book/chapter (:title "Stylesheet")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the stylesheet" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-css)
      (book/chapter (:title "JavaScript Program")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the client side program" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-script)
      (book/chapter (:title "Chart Data")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the chart data" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-data)
      (book/chapter (:title "Error Page")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the error page" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        error-page)
      (book/chapter (:title "Dispatch Table")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the server side dispatch table" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        dispatch-table)
      (book/chapter (:title "Web Server")
        (book/paragraph ()
          (text/text ()
            (text/string "Evaluating the following Common Lisp code creates the web server and stores it in a global variable." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator server-variable :on-demand #t)
        (book/paragraph ()
          (text/text ()
            (text/string "Evaluating the following Common Lisp code starts up the web server." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator (make-common-lisp/application (make-lisp-form/symbol "STARTUP-SERVER" "HU.DWIM.WEB-SERVER") (list (make-common-lisp/variable-reference server-variable))) :on-demand #t)
        (book/paragraph ()
          (text/text ()
            (text/string "Evaluating the following Common Lisp code shuts down the web server." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator (make-common-lisp/application (make-lisp-form/symbol "SHUTDOWN-SERVER" "HU.DWIM.WEB-SERVER") (list (make-common-lisp/variable-reference server-variable))) :on-demand #t))
      (book/chapter (:title "Putting Together the Server Program")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the server side program" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator process-http-function :on-demand #t))
      (book/chapter (:title "Resources")
        (book/paragraph ()
          (text/text ()
            (text/string "You can read more about" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " ProjecturEd" :font *font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string " at" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " http://projectured.org" :font *font/ubuntu/regular/18* :font-color *color/solarized/violet*)))))))

;;;;;;
;;; Documentation

(def function make-test-document/documentation ()
  (bind ((json-document (make-test-document/json))
         (xml-document (make-test-document/xml)))
    (book/book (:title "ProjecturEd, the Projectional Editor" :authors (list "Levente Mészáros"))
      (book/chapter (:title "Introduction")
        (book/paragraph ()
          (make-test-document/introduction)))
      (book/chapter (:title "Domains")
        #+nil
        (book/chapter (:title "Graphics" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some graphics")))
          (make-test-document/graphics))
        (book/chapter (:title "Text")
          (book/paragraph ()
            (text/text ()
              (text/string "This domain provides styled text with " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
              (text/string "fonts" :font *font/liberation/serif/italic/24* :font-color *color/solarized/content/darker*)
              (text/string " and colors." :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*))))
        #+nil
        (book/chapter (:title "List" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some list")))
          (make-test-document/list))
        #+nil
        (book/chapter (:title "Tree" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some tree")))
          (make-test-document/tree))
        #+nil
        (book/chapter (:title "Table")
          (book/paragraph ()
            (text/text ()
              (text/string "This domain provides tables with aligned columns and rows." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          (make-test-document/table/nested))
        (book/chapter (:title "JSON")
          (book/paragraph ()
            (text/text ()
              (text/string "This domain provides the elements of the well known JSON data format." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          json-document)
        (book/chapter (:title "XML")
          (book/paragraph ()
            (text/text ()
              (text/string "This domain provides the elements of well known XML data format." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          xml-document)
        #+nil
        (book/chapter (:title "Java" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some Java code")))
          (make-test-document/java))
        #+nil
        (book/chapter (:title "Javascript" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some Javascript code")))
          (make-test-document/javascript))
        (book/chapter (:title "S-expression" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some Lisp S-expression")))
          (make-test-document/lisp-form))
        #+nil
        (book/chapter (:title "Common Lisp" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some Common Lisp code")))
          (make-test-document/common-lisp))
        #+nil
        (book/chapter (:title "Object" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "Some object")))
          (make-test-document/t/object))
        (book/chapter (:title "Mixed")
          (book/paragraph ()
            (text/text ()
              (text/string "This feature allowes mixing documents in arbitrary ways." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          (xml/element ("mixed" ())
            (xml/element ("something" ((xml/attribute () "extra" "true"))))
            json-document
            xml-document)))
      (book/chapter (:title "Projections")
        (book/chapter (:title "Sorting" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "This projection allows sorting arbitrary document parts based on arbitrary criteria and editing the result." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          json-document)
        (book/chapter (:title "Filtering" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "This projection allows filtering out arbitrary document parts based on arbitrary criteria and editing the result." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          json-document)
        (book/chapter (:title "Selecting" :expanded #f)
          (book/paragraph ()
            (text/text ()
              (text/string "This projection allows selecting arbitrary document parts based on arbitrary criteria and editing the result." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
          json-document)))))

;;;;;;
;;; Test

(def suite* (test/content :in test))

(def test test/content/print-document (document)
  (finishes (print-document document (make-string-output-stream))))

(def test test/content/graphics ()
  (test/content/print-document (make-test-document/graphics)))

(def test test/content/string ()
  (test/content/print-document (make-test-document/string)))

(def test test/content/text ()
  (test/content/print-document (make-test-document/text)))

(def test test/content/list ()
  (test/content/print-document (make-test-document/list)))

(def test test/content/table ()
  (test/content/print-document (make-test-document/table)))

(def test test/content/tree ()
  (test/content/print-document (make-test-document/tree)))

(def test test/content/book ()
  (test/content/print-document (make-test-document/book)))

(def test test/content/xml ()
  (test/content/print-document (make-test-document/xml)))

(def test test/content/json ()
  (test/content/print-document (make-test-document/json)))

(def test test/content/java ()
  (test/content/print-document (make-test-document/java)))

(def test test/content/javascript ()
  (test/content/print-document (make-test-document/javascript)))

(def test test/content/lisp-form ()
  (test/content/print-document (make-test-document/lisp-form)))

(def test test/content/common-lisp ()
  (test/content/print-document (make-test-document/common-lisp)))

(def test test/content/evaluator ()
  (test/content/print-document (make-test-document/evaluator)))

(def test test/content/test ()
  (test/content/print-document (make-test-document/test)))
