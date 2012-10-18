=====================================================
A Symbolized Description of Execution Process in Klee
=====================================================

:Author: Mao Junjie <eternal.n08@gmail.com>

.. contents::

Symbols
=======

Static Program
--------------
The program is represented as a map from address to instructions, i.e.

.. math::
    P ::= addr \mapsto inst

Runtime Execution State
-----------------------

The memory state is defined as

.. math::
    M ::= m \mapsto o

where :math:`m` is a *MemoryObject* and :math:`o` is an *ObjectState*. They are defined as follows.

.. math::
    m ::= \langle base, size \rangle

.. math::
    o ::= [] | byte,o

where :math:`base` and :math:`size` determine the range of the memory and :math:`byte` is a container of one-byte memory either being concrete or symbolic.

The globals

.. math::
    G ::= id \mapsto m

is a map from identifiers to *MemoryObject*.

A stack

.. math::
    \Sigma ::= [] | \sigma, \Sigma

where :math:`\sigma` is a stack frame and is defined as

.. math::
    \sigma ::= \langle pc, \Delta,\alpha \rangle

:math:`pc` is the program counter. :math:`\Delta` stands for the locals of the current function and is map from the local identifiers to its value, i.e.

.. math::
    \Delta ::= id \mapsto V

An execution state :math:`S` is defined as

.. math::
    S ::= \langle M, G, \Sigma \rangle

Annotations
===========

Reference to Instruction
------------------------
Given a program :math:`P` and a location whose address is :math:`a`, the instruction at the location is referred to as :math:`P[a]`.

Increment of a Program Counter
------------------------------
Given a program counter :math:`pc` which is an address to an instruction, :math:`pc_{next}` means the address of the next instruction in the program.

Mapping
-------
Suppose a map :math:`m ::= A \mapsto B` and :math:`a \in A`, then we define

- :math:`a \in m` is true if the mapping of :math:`a` is defined in :math:`m`.
- :math:`b = m[a]` is true if :math:`a \in m` and the mapping of :math:`a` in :math:`m` is :math:`b`.

Reference to Tuple Elements
---------------------------
Suppose a tuple :math:`T ::= \langle a, b, c\rangle`, we write :math:`T_a` to refer to the element :math:`a` of the tuple :math:`T`.

Initial State
=============

Semantics of LLVM instructions
==============================

The instructions are arranged according to the LLVM Assembly Language Reference Manual [1]_. The result of each instruction is given in the form of one or more execution states assuming that the program is :math:`P` and the execution state before the instruction is invoked is :math:`S = \langle M, G, \Sigma\rangle`.

Terminator Instructions
-----------------------

Binary Operations
-----------------

Bitwise Binary Operations
-------------------------

Vector Operations
-----------------

Aggregate Operations
--------------------

Memory Access and Addressing Operations
---------------------------------------

*alloca*
~~~~~~~~

Conversion Operations
---------------------

Other Operations
----------------

.. [1] `LLVM Assembly Language Reference Manual`_

.. _LLVM Assembly Language Reference Manual: http://llvm.org/releases/2.9/docs/LangRef.html

