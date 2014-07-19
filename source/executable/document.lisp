;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Document

(def function make-initial-document ()
  (widget/shell ()
    (widget/scroll-pane (:location (make-2d 0 0) :size (make-2d 1280 720) :margin (make-inset :all 5))
      (document/document ()
        (document/clipboard ()
          (book/book (:title "Welcome to ProjecturEd" :selection '((the string (subseq (the string document) 0 0)) (the string (title-of (the book/book document)))) :authors (list "Levente Mészáros"))
            (book/chapter (:title "Introduction")
              (book/paragraph ()
                (text/text ()
                  (text/string "ProjecturEd is a generic purpose projectional editor that allows you to naturally edit a combination of different domains. " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
                  (text/newline)
                  (text/string "Visit " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
                  (text/string "http://projectured.org" :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*)
                  (text/string " or " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
                  (text/string "http://github.com/projectured/projectured" :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*)
                  (text/string " for more information." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
            (book/chapter (:title "Cheat Sheet")
              (book/paragraph ()
                (text/text ()
                  (text/string "Use the CURSOR keys to navigate around as you would do in a text editor. Use the mouse wheel to scroll vertically and SHIFT + mouse wheel to scroll horizontally. Type in text where you feel it is appropriate and press ESC to quit. Press CONTROL + H to get context sensitive help. Press INSERT to insert new parts into the document in a generic way." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
            (book/chapter (:title "Examples")
              (book/chapter (:title "XML")
                (book/paragraph ()
                  (text/text ()
                    (text/string "Here is a simple HTML web page." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
                (xml/element ("html" ())
                  (xml/element ("head" ())
                    (xml/element ("title" nil)
                      (xml/text () "Example")))
                  (xml/element ("body" ())
                    (xml/element ("h1" ())
                      (xml/text () "Example"))
                    (xml/element ("div" ((xml/attribute () "id" "e1") (xml/attribute () "style" "width: 800px; height: 600px;")))))))
              (book/chapter (:title "JSON")
                (book/paragraph ()
                  (text/text ()
                    (text/string "Here is a simple contact list in JSON." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
                (json/array ()
                  (json/object ()
                    ("name" (json/string () "Levente Mészáros"))
                    ("sex" (json/string () "male"))
                    ("born" (json/number () 1975)))
                  (json/object ()
                    ("name" (json/string () "Attila Lendvai"))
                    ("sex" (json/string () "male"))
                    ("born" (json/number () 1978))))))))))))