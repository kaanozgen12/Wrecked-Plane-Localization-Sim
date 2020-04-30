matrices = cell(4,1);
matrices{1}= zeros(16,4)+20 ;
matrices{2}= zeros(16.^2,4) ;
matrices{3}= zeros(16.^3,4) ;
matrices{4}= zeros(16.^4,4)  ;


for i= 1:1:16
    matrices{1}(i,4)= ((matrices{1}(i,4))+i-1);
end

for i=2:1:4
    for k=1:1:power(16,i-1)
        for l=1:1:16
        matrices{i}((k-1)*16+l,:) = matrices{i-1}(k,:);
        matrices{i}((k-1)*16+l,5-i) = matrices{i-1}(k,5-i) +l-1;
        end
    end
end

S = sum(matrices{4},2);

number=0;
for k=1:1:16.^4
    if S(k,1)<100
        number= number+1;
    end
end
    
