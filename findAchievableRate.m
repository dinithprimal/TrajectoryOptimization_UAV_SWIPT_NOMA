function [ach_ch,ach_fr] = findAchievableRate(h_UAV_Users,coefArr_ch,coefArr_fr, noUsers)
    % System Parameters
    B = 10^6;
    Pt = 20;     %in dBm
    pt = (10^-3)*db2pow(Pt);	%in linear scale
    
    No = -174 + 10*log10(B);
    no = (10^-3)*db2pow(No);
    
    abh_h_UAV_Users = (abs(h_UAV_Users)).^2;

    
    coefArr_ch_sort = sort(coefArr_ch);
    coefArr_fr_sort = sort(coefArr_fr);
    ach_ch = zeros(1,noUsers);
    ach_fr = zeros(1,noUsers);
    
    for i = 1:noUsers
        if i == 1
            index = find(coefArr_ch == coefArr_ch_sort(i));
            index_fr = find(coefArr_fr == coefArr_fr_sort(i));
            ach_ch(index) = B*log2(1 + pt*coefArr_ch_sort(i)*abh_h_UAV_Users(index)/(no));
            ach_fr(index_fr) = B*log2(1 + pt*coefArr_fr_sort(i)*abh_h_UAV_Users(index_fr)/(no));
        else
            index = find(coefArr_ch == coefArr_ch_sort(i));
            index_fr = find(coefArr_fr == coefArr_fr_sort(i));
            ach_ch(index) = B*log2(1 + pt*coefArr_ch_sort(i)*abh_h_UAV_Users(index)/(no + pt*sum(coefArr_ch_sort(1:i-1))*abh_h_UAV_Users(index)));
            ach_fr(index_fr) = B*log2(1 + pt*coefArr_fr_sort(i)*abh_h_UAV_Users(index_fr)/(no + pt*sum(coefArr_fr_sort(1:i-1))*abh_h_UAV_Users(index_fr)));
        end
    end
    
end