int: n;
int: m;
set of int: ITEM = 1..n;
set of int: KNAPSACK = 1..m;

array[ITEM] of int: profits;
array[ITEM] of int: weights;
array[KNAPSACK] of int: capacities;

array[ITEM, KNAPSACK] of var 0..1: x;
constraint forall(i in ITEM) (
    sum(j in KNAPSACK) (x[i,j]) <= 1
);

constraint forall(j in KNAPSACK) (
    sum(i in ITEM) (x[i,j] * weights[i]) <= capacities[j]
);

constraint forall(j in KNAPSACK) (
    sum(i in ITEM) (x[i,j]) >= 2
);

constraint sum(i in ITEM, j in KNAPSACK) (x[i,j]) <= n-2;

solve maximize sum(i in ITEM, j in KNAPSACK) (x[i,j] * profits[i]);

output [
    "Przedmioty w plecakach:\n"] ++
    [ "Plecak \(j): " ++ show([i | i in ITEM where fix(x[i,j]) == 1]) ++
      " | Wartość: \(sum(i in ITEM where fix(x[i,j]) == 1)(profits[i]))\n"
      | j in KNAPSACK
    ];
