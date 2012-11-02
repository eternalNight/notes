============================
Expression Subsystem in Klee
============================

:Author: Mao Junjie <eternal.n08@gmail.com>

.. contents::

Overall
=======

Type of Expressons
------------------

An unsigned integer representing the size of the expression in bit.

Kinds of Expressions
--------------------

* Extension or Casting
* Arithmetic and Bitwise Operations
* Comparison
* Miscellaneous (Read, Extract, Concat, Select)

Kids
----

A kid is a parameter of an expression which itself is an expression.

Constants
=========

Constants are expressed by *ConstantExpr* which consists of an *APInt* (Arbitrary Precision Integer). The contents may either be integers or floating point real numbers. No kids.

Representation of *True* and *False*
------------------------------------

The constant value *True* or *False* is represented by a 1-bit constant which holds 1 or 0 respectively.

Constant Operations
-------------------
*ConstantExpr* has defined a set of utility methods, which accpet a *ConstantExpr* as RHS operand, to handle the operations between two constants. These methods allocate a new *ConstantExpr* which holds the result of the calculation. The result of a comparison is *True* or *False* which is a 1-bit constant.

Binary Operations
=================

Represented by *BinaryExpr* which has two kids standing for the left and right operators. The oprations presented include arithmetic operations such as add, sub, mul, div(signed and unsigned), rem(remainder, signed and unsigned), bitwise operations such as and, or, xor, shl, shr(logical and arithmetical) and comparison operators such as eq, neq, etc. Each arithmetic or bitwise operation is represented by a *XXXExpr* class, where *XXX* is the name of the operation, defined by the macro *ARITHMETIC_EXPR_CLASS*. The classes for comparison operations are defined by the macro *COMPARISON_EXPR_CLASS*.

Unary Operations
================

The only unary operator in Klee is not which is represented by *NotExpr* who has one kid.

Casting
=======

Casting operations include zero-extension and signed-extension and are represented by *CastExpr* who has 1 kid. The zero-extension and signed-extension expressions use *ZExtExpr* and *SExtExpr* respectively which are based on *CastExpr* and defined by the macro *CAST_EXPR_CLASS*

Concatenation
=============

e.g. C(0001, 1101) = 00011101

Represented with *ConcatExpr* who has two kids.

**TODO** When is this kind of operation needed as it is not in the LLVM instruction set?

Extraction
==========

e.g. E(00011000, 3, 2) = 11

e.g. E(10000000, 10, 2) = 11 (signed-extended)

Represented by *ExtractExpr* who has one kid and two parameters (offset and width).

NotOptimized Tag
================

Represented by *NotOptimizedExpr* which has one kid. This is used to prevent the kid from being optimized for testing.

Reading
=======

Represented by *ReadExpr* which has one kid standing for the index and one parameter (the update list). This operation read one byte from the list.

**TODO** How is a *read* operation carried out?

Selecting
=========

Represented by *SelectExpr* which has three kids.
