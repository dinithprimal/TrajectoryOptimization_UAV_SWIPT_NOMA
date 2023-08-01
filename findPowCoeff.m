function [coefArr_ch, coefArr_fr] = findPowCoeff(h,noUsers)
    
    h_sort = sort(h);
    in_coeff = 0.8;
    coefArr_fr = zeros(1,noUsers);
    
    for i = 1:noUsers
        in_coefArr(i) = 1 - (h(i)/(sum(h)));
        if i == 1
            index = find(h == h_sort(i));
            coefArr_fr(index) = in_coeff;
        elseif i <  noUsers
            index = find(h == h_sort(i));
            coefArr_fr(index) = in_coeff*(1-(sum(coefArr_fr)));
        else
            index = find(h == h_sort(i));
            coefArr_fr(index) = (1-(sum(coefArr_fr)));
        end
    end
    for i = 1:noUsers
        coefArr_ch(i) = (in_coefArr(i)/(sum(in_coefArr)));
    end
    
    
end