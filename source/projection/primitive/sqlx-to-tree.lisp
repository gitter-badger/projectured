;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Projection

(def projection sqlx/column-reference->tree/leaf ()
  ())

(def projection sqlx/table-reference->tree/leaf ()
  ())

(def projection sqlx/select->tree/node ()
  ())

;;;;;;
;;; IO map

(def iomap iomap/sqlx/select->tree/node ()
  ((column-iomaps :type sequence)
   (table-iomaps :type sequence)))

;;;;;;
;;; Construction

(def function make-projection/sqlx/column-reference->tree/leaf ()
  (make-projection 'sqlx/column-reference->tree/leaf))

(def function make-projection/sqlx/table-reference->tree/leaf ()
  (make-projection 'sqlx/table-reference->tree/leaf))

(def function make-projection/sqlx/select->tree/node ()
  (make-projection 'sqlx/select->tree/node))

;;;;;;
;;; Construction

(def macro sqlx/column-reference->tree/leaf ()
  '(make-projection/sqlx/column-reference->tree/leaf))

(def macro sqlx/table-reference->tree/leaf ()
  '(make-projection/sqlx/table-reference->tree/leaf))

(def macro sqlx/select->tree/node ()
  '(make-projection/sqlx/select->tree/node))

;;;;;;
;;; Forward mapper

(def function forward-mapper/sqlx/column-reference->tree/leaf (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case reference
      (((the sqlx/column-reference document))
       '((the tree/leaf document)))
      (((the sqlx/column (target-of (the sqlx/column-reference document)))
        (the string (name-of (the sqlx/column document)))
        (the string (subseq (the string document) ?start-index ?end-index)))
       `((the text/text (content-of (the tree/leaf document)))
         (the text/text (text/subseq (the text/text document) ,?start-index ,?end-index))))
      (((the tree/leaf (printer-output (the sqlx/column-reference document) ?projection ?recursion)) . ?rest)
       (when (and (eq projection ?projection) (eq recursion ?recursion))
         ?rest)))))

(def function forward-mapper/sqlx/table-reference->tree/leaf (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case reference
      (((the sqlx/table-reference document))
       '((the tree/leaf document)))
      (((the sqlx/table (target-of (the sqlx/table-reference document)))
        (the string (name-of (the sqlx/table document)))
        (the string (subseq (the string document) ?start-index ?end-index)))
       `((the text/text (content-of (the tree/leaf document)))
         (the text/text (text/subseq (the text/text document) ,?start-index ,?end-index))))
      (((the tree/leaf (printer-output (the sqlx/table-reference document) ?projection ?recursion)) . ?rest)
       (when (and (eq projection ?projection) (eq recursion ?recursion))
         ?rest)))))

(def function forward-mapper/sqlx/select->tree/node (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case reference
      (((the sqlx/select document))
       '((the tree/node document)))
      (((the sequence (columns-of (the sqlx/select document)))
        (the ?type (elt (the sequence document) ?index))
        . ?rest)
       (bind ((column-iomap (elt (column-iomaps-of printer-iomap) ?index))
              (column-output (output-of column-iomap)))
         (values `((the sequence (children-of (the tree/node document)))
                   (the tree/node (elt (the sequence document) 1))
                   (the sequence (children-of (the tree/node document)))
                   (the ,(form-type column-output) (elt (the sequence document) ,?index)))
                 ?rest
                 column-iomap)))
      (((the sequence (tables-of (the sqlx/select document)))
        (the ?type (elt (the sequence document) ?index))
        . ?rest)
       (bind ((table-iomap (elt (table-iomaps-of printer-iomap) ?index))
              (table-output (output-of table-iomap)))
         (values `((the sequence (children-of (the tree/node document)))
                   (the tree/node (elt (the sequence document) 3))
                   (the sequence (children-of (the tree/node document)))
                   (the ,(form-type table-output) (elt (the sequence document) ,?index)))
                 ?rest
                 table-iomap)))
      (((the tree/node (printer-output (the sqlx/select document) ?projection ?recursion)) . ?rest)
       (when (and (eq projection ?projection) (eq recursion ?recursion))
         ?rest)))))

;;;;;;
;;; Backward mapper

(def function backward-mapper/sqlx/column-reference->tree/leaf (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap))
         (printer-input (input-of printer-iomap)))
    (pattern-case reference
      (((the tree/leaf document))
       '((the sqlx/column-reference document)))
      (((the text/text (content-of (the tree/leaf document)))
        (the text/text (text/subseq (the text/text document) ?start-index ?end-index)))
       (if (string= (name-of (target-of printer-input)) "")
           (append `((the tree/leaf (printer-output (the sqlx/column-reference document) ,projection ,recursion))) reference)
           `((the sqlx/column (target-of (the sqlx/column-reference document)))
             (the string (name-of (the sqlx/column document)))
             (the string (subseq (the string document) ,?start-index ,?end-index)))))
      (?a
       (append `((the tree/leaf (printer-output (the sqlx/column-reference document) ,projection ,recursion))) reference)))))

(def function backward-mapper/sqlx/table-reference->tree/leaf (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap))
         (printer-input (input-of printer-iomap)))
    (pattern-case reference
      (((the tree/leaf document))
       '((the sqlx/table-reference document)))
      (((the text/text (content-of (the tree/leaf document)))
        (the text/text (text/subseq (the text/text document) ?start-index ?end-index)))
       (if (string= (name-of (target-of printer-input)) "")
           (append `((the tree/leaf (printer-output (the sqlx/table-reference document) ,projection ,recursion))) reference)
           `((the sqlx/table (target-of (the sqlx/table-reference document)))
             (the string (name-of (the sqlx/table document)))
             (the string (subseq (the string document) ,?start-index ,?end-index)))))
      (?a
       (append `((the tree/leaf (printer-output (the sqlx/table-reference document) ,projection ,recursion))) reference)))))

(def function backward-mapper/sqlx/select->tree/node (printer-iomap reference)
  (bind ((projection (projection-of printer-iomap))
         (recursion (recursion-of printer-iomap)))
    (pattern-case reference
      (((the tree/node document))
       '((the sqlx/select document)))
      (((the sequence (children-of (the tree/node document)))
        (the tree/node (elt (the sequence document) 1))
        (the sequence (children-of (the tree/node document)))
        (the tree/leaf (elt (the sequence document) ?index))
        . ?rest)
       (bind ((column-iomap (elt (column-iomaps-of printer-iomap) ?index))
              (column-input (input-of column-iomap)))
         (values `((the sequence (columns-of (the sqlx/select document)))
                   (the ,(form-type column-input) (elt (the sequence document) ,?index)))
                 ?rest
                 column-iomap)))
      (((the sequence (children-of (the tree/node document)))
        (the tree/node (elt (the sequence document) 3))
        (the sequence (children-of (the tree/node document)))
        (the tree/leaf (elt (the sequence document) ?index))
        . ?rest)
       (bind ((table-iomap (elt (table-iomaps-of printer-iomap) ?index))
              (table-input (input-of table-iomap)))
         (values `((the sequence (tables-of (the sqlx/select document)))
                   (the ,(form-type table-input) (elt (the sequence document) ,?index)))
                 ?rest
                 table-iomap)))
      (?a
       (append `((the tree/node (printer-output (the sqlx/select document) ,projection ,recursion))) reference)))))

;;;;;;
;;; Printer

(def printer sqlx/column-reference->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (as (print-selection (make-iomap/object projection recursion input input-reference nil)
                                                (selection-of input)
                                                'forward-mapper/sqlx/column-reference->tree/leaf)))
         (output (as (tree/leaf (:selection output-selection)
                       (text/make-default-text (name-of (target-of input)) "enter column name" :font-color *color/solarized/content/darker* :selection (as (nthcdr 1 (va output-selection))))))))
    (make-iomap/object projection recursion input input-reference output)))

(def printer sqlx/table-reference->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (as (print-selection (make-iomap/object projection recursion input input-reference nil)
                                                (selection-of input)
                                                'forward-mapper/sqlx/table-reference->tree/leaf)))
         (output (as (tree/leaf (:selection output-selection)
                       (text/make-default-text (name-of (target-of input)) "enter table name" :font-color *color/solarized/content/darker* :selection (as (nthcdr 1 (va output-selection))))))))
    (make-iomap/object projection recursion input input-reference output)))

(def printer sqlx/select->tree/node (projection recursion input input-reference)
  (bind ((column-iomaps (as (iter (for column-index :from 0)
                                  (for column :in-sequence (columns-of input))
                                  (collect (recurse-printer recursion column
                                                            `((elt (the sequence document) ,column-index)
                                                              (the sequence (columns-of (the sqlx/select document)))
                                                              ,@(typed-reference (form-type input) input-reference)))))))
         (table-iomaps (as (iter (for table-index :from 0)
                                 (for table :in-sequence (tables-of input))
                                 (collect (recurse-printer recursion table
                                                           `((elt (the sequence document) ,table-index)
                                                             (the sequence (tables-of (the sqlx/select document)))
                                                             ,@(typed-reference (form-type input) input-reference)))))))
         (output-selection (as (print-selection (make-iomap 'iomap/sqlx/select->tree/node
                                                            :projection projection :recursion recursion
                                                            :input input :input-reference input-reference
                                                            :column-iomaps column-iomaps
                                                            :table-iomaps table-iomaps)
                                                (selection-of input)
                                                'forward-mapper/sqlx/select->tree/node)))
         (output (as (tree/node (:selection output-selection :separator (text/text () (text/string " ")))
                       (tree/leaf (:selection (as (nthcdr 2 (va output-selection))))
                         (text/text (:selection (as (nthcdr 3 (va output-selection))))
                           (text/string "SELECT" :font-color *color/solarized/blue*)))
                       (make-tree/node (as (mapcar 'output-of (va column-iomaps)))
                                       :separator (text/text () (text/string ", " :font-color *color/solarized/gray*))
                                       :selection (as (nthcdr 2 (va output-selection))))
                       (tree/leaf (:selection (as (nthcdr 2 (va output-selection))))
                         (text/text (:selection (as (nthcdr 3 (va output-selection))))
                           (text/string "FROM" :font-color *color/solarized/blue*)))
                       (make-tree/node (as (mapcar 'output-of (va table-iomaps)))
                                       :separator (text/text () (text/string ", " :font-color *color/solarized/gray*))
                                       :selection (as (nthcdr 2 (va output-selection))))))))
    (make-iomap 'iomap/sqlx/select->tree/node
                :projection projection :recursion recursion
                :input input :input-reference input-reference :output output
                :column-iomaps column-iomaps
                :table-iomaps table-iomaps)))

;;;;;;
;;; Reader

(def reader sqlx/column-reference->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((printer-input (input-of printer-iomap))
         (operation-mapper (lambda (operation selection child-selection child-iomap)
                             (declare (ignore child-selection child-iomap))
                             (typecase operation
                               (operation/text/replace-range
                                (pattern-case selection
                                  (((the sqlx/column (target-of (the sqlx/column-reference document)))
                                    (the string (name-of (the sqlx/column document)))
                                    (the string (subseq (the string document) ?start-index ?end-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the tree/leaf (printer-output (the sqlx/column-reference document) ?projection ?recursion)) . ?rest)
                                   (make-operation/sequence/replace-range printer-input
                                                                          '((the sqlx/column (target-of (the sqlx/column-reference document)))
                                                                            (the string (name-of (the sqlx/column document)))
                                                                            (the string (subseq (the string document) 0 0)))
                                                                          (replacement-of operation)))))))))
    (merge-commands (command/read-backward recursion input printer-iomap 'backward-mapper/sqlx/column-reference->tree/leaf operation-mapper)
                    (make-command/nothing (gesture-of input)))))

(def reader sqlx/table-reference->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((printer-input (input-of printer-iomap))
         (operation-mapper (lambda (operation selection child-selection child-iomap)
                             (declare (ignore child-selection child-iomap))
                             (typecase operation
                               (operation/text/replace-range
                                (pattern-case selection
                                  (((the sqlx/table (target-of (the sqlx/table-reference document)))
                                    (the string (name-of (the sqlx/table document)))
                                    (the string (subseq (the string document) ?start-index ?end-index)))
                                   (make-operation/sequence/replace-range printer-input selection (replacement-of operation)))
                                  (((the tree/leaf (printer-output (the sqlx/table-reference document) ?projection ?recursion)) . ?rest)
                                   (make-operation/sequence/replace-range printer-input
                                                                          '((the sqlx/table (target-of (the sqlx/table-reference document)))
                                                                            (the string (name-of (the sqlx/table document)))
                                                                            (the string (subseq (the string document) 0 0)))
                                                                          (replacement-of operation)))))))))
    (merge-commands (command/read-backward recursion input printer-iomap 'backward-mapper/sqlx/table-reference->tree/leaf operation-mapper)
                    (make-command/nothing (gesture-of input)))))

(def reader sqlx/select->tree/node (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (command/read-selection recursion input printer-iomap 'forward-mapper/sqlx/select->tree/node 'backward-mapper/sqlx/select->tree/node)
                    (gesture-case (gesture-of input)
                      ((gesture/keyboard/key-press #\,)
                       :domain "SQLX" :description "Inserts a new column into the columns of the SQLX select"
                       :operation (bind ((index (length (columns-of printer-input))))
                                    (make-operation/sequence/replace-range printer-input
                                                                           `((the sequence (columns-of (the sqlx/select document)))
                                                                             (the sequence (subseq (the sequence document) ,index ,index)))
                                                                           (list (sqlx/column-reference (:selection '((the sqlx/column (target-of (the sqlx/column-reference document)))
                                                                                                                     (the string (name-of (the sqlx/column document)))
                                                                                                                     (the string (subseq (the string document) 0 0))))
                                                                                   (sqlx/column () "" "")))))))
                    (command/read-backward recursion input printer-iomap 'backward-mapper/sqlx/select->tree/node nil)
                    (make-command/nothing (gesture-of input)))))
