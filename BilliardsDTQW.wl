(* ::Package:: *)

(* BilliardsDTQW|.wl *)

BeginPackage["BilliardsDTQW`"]

(* Load the QMB package *)
Get["/home/jadeleon/Documents/chaos_meets_channels/Mathematica_packages/QMB.wl"];

DimH::usage = "DimH[xc] calculates the dimension of the Hilbert space for a given xc.";
TagPosition::usage = "TagPosition[ket_, tags_] finds the position of a ket in the tags list.";
HorizontalBoundary::usage = "HorizontalBoundary[y_, xc_] calculates the horizontal boundary for a given y and xc.";
HorizontalBoundary2::usage = "HorizontalBoundary2[y_, xc_] calculates the horizontal boundary for a given y and xc.";(*fix it later*)
VerticalBoundary::usage = "VerticalBoundary[x_, xc_] calculates the vertical boundary for a given x and xc.";
Basis::usage = "Basis[xc_] generates the basis states for a given xc.";
VerticalShift::usage = "VerticalShift[xc_, tags_] calculates the vertical shift operator.";
HorizontalShift::usage = "HorizontalShift[xc_, tags_, reversedBasis_] calculates the horizontal shift operator.";
Coin::usage = "Coin[\[Alpha]_, xc_] generates the coin operator for a given angle \[Alpha] and xc.";

Begin["`Private`"]

(* Define the functions here *)

DimH[xc_] := 2*Sum[VerticalBoundary[x, xc] + 1, {x, 0, 2*xc}]

TagPosition[ket_, tags_] := FirstPosition[tags, Tag[ket]]

ClearAll[HorizontalBoundary, VerticalBoundary]

HorizontalBoundary[y_, xc_] := Round[xc + Sqrt[xc^2 - y^2]]
HorizontalBoundary[y_, xc_, yu_] := Round[xc + Sqrt[yu^2 - y^2]]
HorizontalBoundary2[y_,reversedBasis_]:=SelectFirst[reversedBasis,#[[2]]==y&][[1]]

VerticalBoundary[x_, xc_] := 
 If[x <= xc, xc, Round[Sqrt[xc^2 - (x - xc)^2]]]
VerticalBoundary[x_, xc_, yu_] := 
 If[x <= xc, yu, Round[Sqrt[yu^2 - (x - xc)^2]]]

Basis[xc_] := 
 Flatten[Table[{x, y, c}, {x, 0, 2*xc}, {y, 0, 
    VerticalBoundary[x, xc]}, {c, 0, 1}], 2]

VerticalShift[xc_, tags_] :=
 Module[{ymax},
  SparseArray[Transpose[{Flatten[
       Table[
        ymax = VerticalBoundary[x, xc];
        Join[
         {If[ymax == 0., TagPosition[{x, 0., 1.}, tags], 
           TagPosition[{x, 1., 0.}, tags]], 
          TagPosition[{x, 0., 0.}, tags]},
         Table[{TagPosition[{x, y + 1., 0.}, tags], 
           TagPosition[{x, y - 1., 1.}, tags]}, {y, 1., ymax - 1}],
         If[ymax > 0., TagPosition[#, tags] & /@ {{x, ymax, 1.}, {x, ymax - 1., 1.}}, {}]
         ]
        , {x, 0., 2.*xc}]
       ], Range[DimH[xc]]}] -> 1.]
  ]

ClearAll[HorizontalShift]
HorizontalShift[xc_, tags_, reversedBasis_] :=
 Module[{ymax, xmax},
  SparseArray[Transpose[{Flatten[
       Table[
        ymax = VerticalBoundary[x, xc];
        Table[
         xmax = HorizontalBoundary2[y, reversedBasis];
         
         Which[x == 0., {TagPosition[{1., y, 0.}, tags], 
           TagPosition[{0., y, 0.}, tags]}, 
          x == xmax, {TagPosition[{x, y, 1.}, tags], 
           TagPosition[{x - 1., y, 1.}, tags]}, 
          1 <= x < xmax, {TagPosition[{x + 1., y, 0.}, tags], 
           TagPosition[{x - 1., y, 1.}, tags]}]
         , {y, 0., ymax}]
        , {x, 0., 2.*xc}]
       ], Range[DimH[xc]]}] -> 1.]
  ]

Coin[\[Alpha]_, xc_] := 
 KroneckerProduct[IdentityMatrix[Round[DimH[xc]]/2, SparseArray], 
  SparseArray[{{Cos[\[Alpha]], Sin[\[Alpha]]}, {-Sin[\[Alpha]], 
     Cos[\[Alpha]]}}]]

End[]

EndPackage[]
