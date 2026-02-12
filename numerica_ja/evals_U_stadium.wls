#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Cargar paquetes *)
Quiet[<<QuantumWalks`]
Quiet[<<QMB`]


(*Define geometry parameters*)
xc = 50; (*Length of the straight part*)
nu = 50;  (*Radius (width)*)

(*Generate the grid data*)
billiardData = GenerateStadiumBasis[xc,nu];


(*Construct Shift Operators*)
{Sx, Sy} = BuildShiftOperators[billiardData];

(*Construct the Coin Operators*)
dim = billiardData["Dimension"];



angles = Subdivide[0., 2.*Pi, 8];

Do[
	Coin1 = Coin[\[Theta]1, dim]; Coin2 = Coin[\[Theta]2, dim]; U = Sx . Coin2 . Sy . Coin1;
	eigenphases = Sort[Mod[Arg[Eigenvalues[Normal[U]]], 2*Pi]];
	Export["/home/jadeleon/Documents/chaotic_walks/numerica_ja/evals_U_stadium_50_50/theta1_"<>ToString[NumberForm[\[Theta]1, {Infinity, 3}]]<>"theta2_"<>ToString[NumberForm[\[Theta]2, {Infinity, 3}]]<>".wdx", eigenphases];
, {\[Theta]1, angles}
, {\[Theta]2, angles}
]
