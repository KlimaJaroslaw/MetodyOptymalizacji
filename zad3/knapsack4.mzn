int: n;
int: m;
set of int: ITEM = 1..n;
set of int: KNAPSACK = 1..m;

array[ITEM] of int: profits;
array[ITEM] of int: weights;
array[KNAPSACK] of int: capacities;

array[ITEM, KNAPSACK] of var 0..1: x;

% Przedmiot może być w maksymalnie jednym plecaku
constraint forall(i in ITEM) (
    sum(j in KNAPSACK) (x[i,j]) <= 1
);

% Nie przekraczamy pojemności plecaków
constraint forall(j in KNAPSACK) (
    sum(i in ITEM) (x[i,j] * weights[i]) <= capacities[j]
);

% Minimum 2 przedmioty w każdym plecaku
constraint forall(j in KNAPSACK) (
    sum(i in ITEM) (x[i,j]) >= 2
);

% Minimum 2 przedmioty pozostają poza plecakami
constraint sum(i in ITEM, j in KNAPSACK) (x[i,j]) <= n-2;

solve maximize sum(i in ITEM, j in KNAPSACK) (x[i,j] * profits[i]);

output [
    "Przedmioty w plecakach:\n"] ++
    [ "Plecak \(j): " ++ show([i | i in ITEM where fix(x[i,j]) == 1]) ++
      " | Wartość: \(sum(i in ITEM where fix(x[i,j]) == 1)(profits[i]))\n"
      | j in KNAPSACK
    ] ++
    [ 
      "----------\n",
      "SUMA_ZYSKU: ", show(sum(i in ITEM, j in KNAPSACK)(fix(x[i,j]) * profits[i])), "\n"
    ];