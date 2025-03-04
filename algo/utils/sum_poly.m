function coeff_sum = sum_poly(x1, x2)
    x1_order = length(x1);
    x2_order = length(x2);
    max_order = max(x1_order,x2_order);
    new_x1 = padarray(x1,max_order-x1_order,0,'pre');
    new_x2 = padarray(x2,max_order-x2_order,0,'pre');

    coeff_sum = new_x1 + new_x2;
end