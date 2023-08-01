function ach_BS = findAchievableRate_BS(h_UAV_BS,noBS)

    % System Parameters
    B = 10^6;
    Pt = 46;     %in dBm
    pt = (10^-3)*db2pow(Pt);	%in linear scale
    
    No = -174 + 10*log10(B);
    no = (10^-3)*db2pow(No);
    
    abh_h_UAV_BS = (abs(h_UAV_BS)).^2;
    
    abh_h_UAV_BS_sort = sort(abh_h_UAV_BS,'descend');
    
    ach_BS = zeros(1,noBS);
    
    for i=1:noBS
        index = find(abh_h_UAV_BS == abh_h_UAV_BS_sort(i));
        ach_BS(index) = B*log2(1 + pt*abh_h_UAV_BS(index)/(no + pt*sum(abh_h_UAV_BS_sort(1+1:end))));
    end

end