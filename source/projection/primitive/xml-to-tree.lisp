;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Projection

(def projection xml/text->tree/leaf ()
  ())

(def projection xml/attribute->tree/node ()
  ())

(def projection xml/element->tree/node ()
  ())

;;;;;;
;;; IO map

(def iomap iomap/xml/element->tree/node ()
  ((attribute-iomaps :type sequence)
   (child-iomaps :type sequence)))

;;;;;;
;;; Construction

(def function make-projection/xml/text->tree/leaf ()
  (make-projection 'xml/text->tree/leaf))

(def function make-projection/xml/attribute->tree/node ()
  (make-projection 'xml/attribute->tree/node))

(def function make-projection/xml/element->tree/node ()
  (make-projection 'xml/element->tree/node))

;;;;;;
;;; Construction

(def macro xml/text->tree/leaf ()
  '(make-projection/xml/text->tree/leaf))

(def macro xml/attribute->tree/node ()
  '(make-projection/xml/attribute->tree/node))

(def macro xml/element->tree/node ()
  '(make-projection/xml/element->tree/node))

;;;;;;
;;; Forward mapper

(def function forward-mapper/xml/text->tree/leaf (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case (reverse reference)
      (((the string (value-of (the xml/text document)))
        (the string (subseq (the string document) ?start-index ?end-index)))
       `((the text/text (text/subseq (the text/text document) ,?start-index ,?end-index))
         (the text/text (content-of (the tree/leaf document)))))
      (((the tree/leaf (printer-output (the xml/text document) ?projection ?recursion)) . ?rest)
       (when (and (eq projection ?projection) (eq recursion ?recursion))
         (reverse ?rest))))))

(def function forward-mapper/xml/attribute->tree/node (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case (reverse reference)
      (((the string (name-of (the xml/attribute document)))
        (the string (subseq (the string document) ?start-character-index ?end-character-index)))
       `((the text/text (text/subseq (the text/text document) ,?start-character-index ,?end-character-index))
         (the text/text (content-of (the tree/leaf document)))
         (the tree/leaf (elt (the sequence document) 0))
         (the sequence (children-of (the tree/node document)))))
      (((the string (value-of (the xml/attribute document)))
        (the string (subseq (the string document) ?start-character-index ?end-character-index)))
       `((the text/text (text/subseq (the text/text document) ,?start-character-index ,?end-character-index))
         (the text/text (content-of (the tree/leaf document)))
         (the tree/leaf (elt (the sequence document) 1))
         (the sequence (children-of (the tree/node document)))))
      (((the tree/node (printer-output (the xml/attribute document) ?projection ?recursion)) . ?rest)
       (when (and (eq projection ?projection) (eq recursion ?recursion))
         (reverse ?rest))))))

(def function forward-mapper/xml/element->tree/node (printer-iomap reference)
  (bind ((printer-input (input-of printer-iomap))
         (projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case (reverse reference)
      (((the string (xml/start-tag (the xml/element document)))
        (the string (subseq (the string document) ?start-character-index ?end-character-index)))
       `((the text/text (text/subseq (the text/text document) ,?start-character-index ,?end-character-index))
         (the text/text (content-of (the tree/leaf document)))
         (the tree/leaf (elt (the sequence document) 0))
         (the sequence (children-of (the tree/node document)))))
      (((the string (xml/end-tag (the xml/element document)))
        (the string (subseq (the string document) ?start-character-index ?end-character-index)))
       `((the text/text (text/subseq (the text/text document) ,?start-character-index ,?end-character-index))
         (the text/text (content-of (the tree/leaf document)))
         (the tree/leaf (elt (the sequence document) ,(+ (length (children-of printer-input)) (if (attributes-of printer-input) 2 1))))
         (the sequence (children-of (the tree/node document)))))
      (((the sequence (attributes-of (the xml/element document)))
        (the ?attribute-type (elt (the sequence document) ?attribute-index))
        . ?rest)
       (bind ((attribute-iomap (elt (attribute-iomaps-of printer-iomap) ?attribute-index))
              (attribute-output (output-of attribute-iomap)))
         (values `((the ,(form-type attribute-output) (elt (the sequence document) ,?attribute-index))
                   (the sequence (children-of (the tree/node document)))
                   (the tree/node (elt (the sequence document) 1))
                   (the sequence (children-of (the tree/node document))))
                 (reverse ?rest)
                 attribute-iomap)))
      (((the sequence (children-of (the xml/element document)))
        (the ?child-type (elt (the sequence document) ?child-index))
        . ?rest)
       (bind ((child-iomap (elt (child-iomaps-of printer-iomap) ?child-index))
              (child-output (output-of child-iomap)))
         (values `((the ,(form-type child-output) (elt (the sequence document) ,(+ ?child-index (if (attributes-of printer-input) 2 1))))
                   (the sequence (children-of (the tree/node document))))
                 (reverse ?rest)
                 child-iomap)))
      (((the tree/node (printer-output (the xml/element document) ?projection ?recursion)) . ?rest)
       (when (and (eq projection ?projection) (eq recursion ?recursion))
         (reverse ?rest))))))

;;;;;;
;;; Backward mapper

(def function backward-mapper/xml/text->tree/leaf (printer-iomap reference)
  (bind ((printer-input (input-of printer-iomap))
         (projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case (reverse reference)
      (((the text/text (content-of (the tree/leaf document)))
        (the text/text (text/subseq (the text/text document) ?start-index ?end-index)))
       (if (string= (value-of printer-input) "")
           (append reference `((the tree/leaf (printer-output (the xml/text document) ,projection ,recursion))))
           `((the string (subseq (the string document) ,?start-index ,?end-index))
             (the string (value-of (the xml/text document))))))
      (?
       (append reference `((the tree/leaf (printer-output (the xml/text document) ,projection ,recursion))))))))

(def function backward-mapper/xml/attribute->tree/node (printer-iomap reference)
  (bind ((printer-input (input-of printer-iomap))
         (projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case reference
      (((the text/text (text/subseq (the text/text document) ?start-character-index ?end-character-index))
        (the text/text (content-of (the tree/leaf document)))
        (the tree/leaf (elt (the sequence document) 0))
        (the sequence (children-of (the tree/node document))))
       (if (string= (name-of printer-input) "")
           (append reference `((the tree/node (printer-output (the xml/attribute document) ,projection ,recursion))))
           `((the string (subseq (the string document) ,?start-character-index ,?end-character-index))
             (the string (name-of (the xml/attribute document))))))
      (((the text/text (text/subseq (the text/text document) ?start-character-index ?end-character-index))
        (the text/text (content-of (the tree/leaf document)))
        (the tree/leaf (elt (the sequence document) 1))
        (the sequence (children-of (the tree/node document))))
       (if (string= (value-of printer-input) "")
           (append reference `((the tree/node (printer-output (the xml/attribute document) ,projection ,recursion))))
           `((the string (subseq (the string document) ,?start-character-index ,?end-character-index))
             (the string (value-of (the xml/attribute document))))))
      (?a
       (append reference `((the tree/node (printer-output (the xml/attribute document) ,projection ,recursion))))))))

(def function backward-mapper/xml/element->tree/node (printer-iomap reference)
  (bind ((printer-input (input-of printer-iomap))
         (projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap))
         (first-child-index (if (attribute-iomaps-of printer-iomap) 2 1))
         (last-child-index (+ first-child-index (1- (length (children-of printer-input))))))
    (pattern-case (reverse reference)
      (((the sequence (children-of (the tree/node document)))
        (the ?child-type (elt (the sequence document) ?child-index))
        . ?rest)
       (econd ((= 0 ?child-index)
               (pattern-case ?rest
                 (((the text/text (content-of (the tree/leaf document)))
                   (the text/text (text/subseq (the text/text document) ?start-character-index ?end-character-index)))
                  (if (string= (name-of printer-input) "")
                      (append reference `((the tree/node (printer-output (the xml/element document) ,projection ,recursion))))
                      `((the string (subseq (the string document) ,?start-character-index ,?end-character-index))
                        (the string (xml/start-tag (the xml/element document))))))
                 (?a
                  (append reference `((the tree/node (printer-output (the xml/element document) ,projection ,recursion)))))))
              ((= (1+ last-child-index) ?child-index)
               (pattern-case ?rest
                 (((the text/text (content-of (the tree/leaf document)))
                   (the text/text (text/subseq (the text/text document) ?start-character-index ?end-character-index)))
                  (if (string= (name-of printer-input) "")
                      (append reference `((the tree/node (printer-output (the xml/element document) ,projection ,recursion))))
                      `((the string (subseq (the string document) ,?start-character-index ,?end-character-index))
                        (the string (xml/end-tag (the xml/element document))))))
                 (?a
                  (append reference `((the tree/node (printer-output (the xml/element document) ,projection ,recursion)))))))
              ((< ?child-index first-child-index)
               (pattern-case ?rest
                 (((the sequence (children-of (the tree/node document)))
                   (the ?attribute-type (elt (the sequence document) ?attribute-index))
                   . ?rest)
                  (bind ((attribute (elt (attributes-of printer-input) ?attribute-index))
                         (attribute-iomap (elt (attribute-iomaps-of printer-iomap) ?attribute-index)))
                    (values `((the ,(form-type attribute) (elt (the sequence document) ,?attribute-index))
                              (the sequence (attributes-of (the xml/element document))))
                            (reverse ?rest)
                            attribute-iomap)))
                 (?a
                  (append reference `((the tree/node (printer-output (the xml/element document) ,projection ,recursion)))))))
              ((<= first-child-index ?child-index last-child-index)
               (bind ((child-index (- ?child-index first-child-index))
                      (child (elt (children-of printer-input) child-index))
                      (child-iomap (elt (child-iomaps-of printer-iomap) child-index)))
                 (values `((the ,(form-type child) (elt (the sequence document) ,child-index))
                           (the sequence (children-of (the xml/element document))))
                         (reverse ?rest)
                         child-iomap)))))
      (?a
       (append reference `((the tree/node (printer-output (the xml/element document) ,projection ,recursion))))))))

;;;;;;
;;; Printer

(def printer xml/text->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (as (print-selection (make-iomap/object projection recursion input input-reference nil) (selection-of input) 'forward-mapper/xml/text->tree/leaf)))
         (output (as (tree/leaf (:selection output-selection)
                       (text/make-default-text (value-of input) "enter xml text" :selection (as (butlast (va output-selection))) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/green*)))))
    (make-iomap/object projection recursion input input-reference output)))

(def printer xml/attribute->tree/node (projection recursion input input-reference)
  (bind ((output-selection (as (print-selection (make-iomap/object projection recursion input input-reference nil) (selection-of input) 'forward-mapper/xml/attribute->tree/node)))
         (output (as (tree/node (:separator (text/text () (text/string "=" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                  :selection output-selection)
                       (tree/leaf (:selection (as (butlast (va output-selection) 2)))
                         (text/make-default-text (name-of input) "enter xml attribute name" :selection (as (butlast (va output-selection) 3)) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/red*))
                       (tree/leaf (:opening-delimiter (text/text () (text/string "\"" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                   :closing-delimiter (text/text () (text/string "\"" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                   :selection (as (butlast (va output-selection) 2)))
                         (text/make-default-text (value-of input) "enter xml attribute value" :selection (as (butlast (va output-selection) 3)) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/green*))))))
    (make-iomap/object projection recursion input input-reference output)))

(def printer xml/element->tree/node (projection recursion input input-reference)
  (bind ((deep-element (find-if (of-type 'xml/element) (children-of input)))
         (attribute-iomaps (as (iter (for attribute :in-sequence (attributes-of input))
                                     (for attribute-index :from 0)
                                     (collect (recurse-printer recursion attribute
                                                               `((elt (the sequence document) ,attribute-index)
                                                                 (the sequence (attributes-of document))
                                                                 ,@(typed-reference (form-type input) input-reference)))))))
         (child-iomaps (as (map-ll* (children-of input) (lambda (child index)
                                                          (bind ((child-iomap (recurse-printer recursion (value-of child)
                                                                                               `((elt (the sequence document) ,index)
                                                                                                 (the sequence (children-of (the xml/element document)))
                                                                                                 ,@(typed-reference (form-type input) input-reference))))
                                                                 (child-output (output-of child-iomap)))
                                                            (when deep-element
                                                              (setf (indentation-of child-output) 2))
                                                            child-iomap)))))
         (output-selection (as (print-selection (make-iomap 'iomap/xml/element->tree/node
                                                            :projection projection :recursion recursion
                                                            :input input :input-reference input-reference
                                                            :attribute-iomaps attribute-iomaps :child-iomaps child-iomaps)
                                                (selection-of input)
                                                'forward-mapper/xml/element->tree/node)))
         (output (as (bind ((children (children-of input))
                            (element-name (text/make-default-text (name-of input) "enter xml element name" :selection (as (butlast (va output-selection) 3)) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/blue*)))
                       (make-tree/node (append-ll (ll (append (list (ll (list (tree/leaf (:opening-delimiter (text/text () (text/string "<" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                                                                          :closing-delimiter (unless (va attribute-iomaps)
                                                                                                               (text/text () (text/string (if children ">" "/>") :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*)))
                                                                                          :selection (as (butlast (va output-selection) 2)))
                                                                                element-name))))
                                                              (when (va attribute-iomaps)
                                                                (list (ll (list (make-tree/node (mapcar 'output-of (va attribute-iomaps))
                                                                                                :closing-delimiter (text/text () (text/string (if children ">" "/>") :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                                                                                :separator (text/text () (text/string " " :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                                                                                :selection (as (butlast (va output-selection) 2)))))))
                                                              (when children
                                                                (list (append-ll (ll (list (map-ll (va child-iomaps) 'output-of)
                                                                                           (ll (list (tree/leaf (:indentation (if deep-element 0 nil)
                                                                                                                 :opening-delimiter (text/text () (text/string "</" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                                                                                                 :closing-delimiter (text/text () (text/string ">" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                                                                                                 :selection (as (butlast (va output-selection) 2)))
                                                                                                       element-name)))))))))
                                                      (+ (if children 1 0) (if (va attribute-iomaps) 1 0))))
                                       :separator (text/text () (text/string " " :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                       :selection output-selection)))))
    (make-iomap 'iomap/xml/element->tree/node
                :projection projection :recursion recursion
                :input input :input-reference input-reference :output output
                :attribute-iomaps attribute-iomaps :child-iomaps child-iomaps)))

;;;;;;
;;; Reader

(def reader xml/text->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((gesture (gesture-of input))
         (printer-input (input-of printer-iomap))
         (operation-mapper (lambda (operation selection child-selection child-iomap)
                             (declare (ignore child-selection child-iomap))
                             (typecase operation
                               (operation/text/replace-range
                                (pattern-case (reverse selection)
                                  (((the string (value-of (the xml/text document)))
                                    (the string (subseq (the string document) ?start-character-index ?end-character-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the tree/leaf (printer-output (the xml/text document) ?projection ?recursion)) . ?rest)
                                   (make-operation/sequence/replace-range printer-input
                                                                          '((the string (subseq (the string document) 0 0))
                                                                            (the string (value-of (the xml/text document))))
                                                                          (replacement-of operation)))))))))
    (merge-commands (command/read-backward recursion input printer-iomap 'backward-mapper/xml/text->tree/leaf operation-mapper)
                    (make-command/nothing gesture))))

(def reader xml/attribute->tree/node (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((printer-input (input-of printer-iomap))
         (operation-mapper (lambda (operation selection child-selection child-iomap)
                             (declare (ignore child-selection child-iomap))
                             (typecase operation
                               (operation/text/replace-range
                                (pattern-case (reverse selection)
                                  (((the string (name-of (the xml/attribute document)))
                                    (the string (subseq (the string document) ?start-character-index ?end-character-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the string (value-of (the xml/attribute document)))
                                    (the string (subseq (the string document) ?start-character-index ?end-character-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the tree/node (printer-output (the xml/attribute document) ?projection ?recursion))
                                    (the sequence (children-of (the tree/node document)))
                                    (the tree/leaf (elt (the sequence document) 0))
                                    . ?rest)
                                   (make-operation/sequence/replace-range printer-input
                                                                          '((the string (subseq (the string document) 0 0))
                                                                            (the string (name-of (the xml/attribute document))))
                                                                          (replacement-of operation)))
                                  (((the tree/node (printer-output (the xml/attribute document) ?projection ?recursion))
                                    (the sequence (children-of (the tree/node document)))
                                    (the tree/leaf (elt (the sequence document) 1))
                                    . ?rest)
                                   (make-operation/sequence/replace-range printer-input
                                                                          '((the string (subseq (the string document) 0 0))
                                                                            (the string (value-of (the xml/attribute document))))
                                                                          (replacement-of operation)))))))))
    (merge-commands (gesture-case (gesture-of input)
                      ((gesture/keyboard/key-press #\=)
                       :domain "XML" :description "Moves the selection to the value"
                       :operation (pattern-case (selection-of printer-input)
                                    (((the string (subseq (the string document) ?start-character-index ?end-character-index))
                                      (the string (name-of (the xml/attribute document))))
                                     (make-operation/replace-selection printer-input
                                                                       '((the string (subseq (the string document) 0 0))
                                                                         (the string (value-of (the xml/attribute document)))))))))
                    (command/read-backward recursion input printer-iomap 'backward-mapper/xml/attribute->tree/node operation-mapper)
                    (make-command/nothing (gesture-of input)))))

(def reader xml/element->tree/node (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((printer-input (input-of printer-iomap))
         (operation-mapper (lambda (operation selection child-selection child-iomap)
                             (declare (ignore child-selection child-iomap))
                             (typecase operation
                               (operation/text/replace-range
                                (pattern-case (reverse selection)
                                  (((the string (xml/start-tag (the xml/element document)))
                                    (the string (subseq (the string document) ?start-character-index ?end-character-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the string (xml/end-tag (the xml/element document)))
                                    (the string (subseq (the string document) ?start-character-index ?end-character-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the tree/node (printer-output (the xml/element document) ?projection ?recursion))
                                    (the sequence (children-of (the tree/node document)))
                                    (the tree/leaf (elt (the sequence document) 0))
                                    . ?rest)
                                   (make-operation/sequence/replace-range printer-input
                                                                          '((the string (subseq (the string document) 0 0))
                                                                            (the string (xml/start-tag (the xml/element document))))
                                                                          (replacement-of operation)))
                                  (((the tree/node (printer-output (the xml/element document) ?projection ?recursion))
                                    (the sequence (children-of (the tree/node document)))
                                    (the tree/leaf (elt (the sequence document) ?child-index))
                                    . ?rest)
                                   (when (= ?child-index (1- (length (children-of (output-of printer-iomap)))))
                                     (make-operation/sequence/replace-range printer-input
                                                                            '((the string (subseq (the string document) 0 0))
                                                                              (the string (xml/end-tag (the xml/element document))))
                                                                            (replacement-of operation))))))))))
    (merge-commands (command/read-selection recursion input printer-iomap 'forward-mapper/xml/element->tree/node 'backward-mapper/xml/element->tree/node)
                    (gesture-case (gesture-of input)
                      ((gesture/keyboard/key-press :sdl-key-insert)
                       :domain "XML" :description "Starts an insertion into the children of the XML element"
                       :operation (make-operation/compound (bind ((children-length (length (children-of printer-input))))
                                                             (list (make-operation/sequence/replace-range printer-input `((the sequence (subseq (the sequence document) ,children-length ,children-length))
                                                                                                                          (the sequence (children-of (the xml/element document)))) (list (document/insertion :font *font/liberation/serif/regular/18*)))
                                                                   (make-operation/replace-selection printer-input `((the string (subseq (the string document) 0 0))
                                                                                                                     (the string (value-of (the document/insertion document)))
                                                                                                                     (the document/insertion (elt (the sequence document) ,children-length))
                                                                                                                     (the sequence (children-of (the xml/element document)))))))))
                      ((gesture/keyboard/key-press :sdl-key-space)
                       :domain "XML" :description "Inserts a new XML attribute into the attributes of the XML element"
                       :operation (pattern-case (reverse (selection-of printer-input))
                                    ((?or ((the string (xml/start-tag (the xml/element document)))
                                           (the string (subseq (the string document) ?start-index ?end-index)))
                                          ((the sequence (attributes-of (the xml/element document)))
                                           (the xml/attribute (elt (the sequence document) ?attribute-index))
                                           (the tree/node (printer-output (the xml/attribute document) ?projection ?recursion)). ?rest)
                                          ((the tree/node (printer-output (the xml/element document) ?projection ?recursion)) . ?rest))
                                     (bind ((index (length (attributes-of printer-input))))
                                       (make-operation/compound (list (make-operation/sequence/replace-range printer-input `((the sequence (subseq (the sequence document) ,index ,index))
                                                                                                                             (the sequence (attributes-of (the xml/element document))))
                                                                                                             (list (xml/attribute () "" "")))
                                                                      (make-operation/replace-selection printer-input `((the string (subseq (the string document) 0 0))
                                                                                                                        (the string (name-of (the xml/attribute document)))
                                                                                                                        (the xml/attribute (elt (the sequence document) ,index))
                                                                                                                        (the sequence (attributes-of (the xml/element document)))))))))))
                      ((gesture/keyboard/key-press #\" :shift)
                       :domain "XML" :description "Inserts a new XML text into the children of the XML element"
                       :operation (bind ((index (length (children-of printer-input))))
                                    (make-operation/compound (list (make-operation/sequence/replace-range printer-input `((the sequence (subseq (the sequence document) ,index ,index))
                                                                                                                          (the sequence (children-of (the xml/element document))))
                                                                                                          (list (xml/text () "")))
                                                                   (make-operation/replace-selection printer-input `((the string (subseq (the string document) 0 0))
                                                                                                                     (the string (value-of (the xml/text document)))
                                                                                                                     (the xml/text (elt (the sequence document) ,index))
                                                                                                                     (the sequence (children-of (the xml/element document)))))))))
                      ((gesture/keyboard/key-press #\< :shift)
                       :domain "XML" :description "Inserts a new XML element into the children of the XML element"
                       :operation (bind ((index (length (children-of printer-input))))
                                    (make-operation/compound (list (make-operation/sequence/replace-range printer-input `((the sequence (subseq (the sequence document) ,index ,index))
                                                                                                                          (the sequence (children-of (the xml/element document))))
                                                                                                          (list (xml/element ("" nil))))
                                                                   (make-operation/replace-selection printer-input `((the string (subseq (the string document) 0 0))
                                                                                                                     (the string (xml/start-tag (the xml/element document)))
                                                                                                                     (the xml/element (elt (the sequence document) ,index))
                                                                                                                     (the sequence (children-of (the xml/element document))))))))))
                    (command/read-backward recursion input printer-iomap 'backward-mapper/xml/element->tree/node operation-mapper)
                    (make-command/nothing (gesture-of input)))))
