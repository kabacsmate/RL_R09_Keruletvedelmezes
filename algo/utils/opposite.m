function sOpp = opposite(s,perimeter)
sOpp = rem(s + perimeter(end).CumSum/2,perimeter(end).CumSum);