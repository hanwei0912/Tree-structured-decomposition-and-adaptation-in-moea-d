# [Tree-structured decomposition and adaptation in MOEA/D]

## Abstract
The multiobjective evolutionary algorithm based on decompo-
sition (MOEA/D) converts a multiobjective optimization problem (MOP)
into a set of simple subproblems, and deals with them simultaneously to
approximate the Pareto optimal set (PS) of the original MOP. Normally
in MOEA/D, a set of weight vectors are predened and kept unchanged
during the search process. In the last few years, it has been demonstrated
in some cases that a set of predened subproblems may fail to achieve a
good approximation to the Pareto optimal set. The major reason is that
it is usually unable to dene a proper set of subproblems, which take full
consideration of the characteristics of the MOP beforehand. Therefore,
it is imperative to develop a way to adaptively redene the subproblems
during the search process. This paper proposes a tree-structured decom-
position and adaptation (TDA) strategy to achieve this goal. The basic
idea is to use a tree structure to decompose the search domain into a
set of subdomains that are related with some subproblems, and adaptively
maintain these subdomains by analyzing the search behaviors of
MOEA/D in these subdomains. The TDA strategy has been applied to
a variety of test instances. Experimental results show the advantages
of TDA on improving MOEA/D in dealing with MOPs with dierent
characteristics.

## Code
Matlab code for the paper Tree-structured decomposition and adaptation in moea/d
The MOEA/D framework is implemented in MATLAB, while the NDSelector is implemented in C++. 
So you need "mex" to compile the code in MATLAB as below:

> mex --setup C++

> mex NDSelector.cpp

Run the file demo_moeaddda_withPFarchive.m or demo_moeaddda_withPSarchive.m to see the demo.
