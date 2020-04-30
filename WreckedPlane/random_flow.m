function flow_matrix = random_flow(n1,n2)
%This function gives a random flow matrix
% matrix length is given as input

flow_matrix= zeros(n1,n2,2);
magnitude = 5;
magnitude_decrease_factor=1;
angle_change_factor=0;
%angle = (2*pi) / rand(1) ;
angle = 0 ;
%sign = randi([-1, 1], 1) % Get a -1 or 1 randomly.

flow_matrix(n1,n2,1)= magnitude;
flow_matrix(n1,n2,2)= angle;

for column=n2:-1:1
    for row=n1:-1:1
        if row==n1 && column== n2
            ;
        elseif row==n1 && column~= n2
            flow_matrix(row,column,1)= flow_matrix(row,column+1,1);
            flow_matrix(row,column,2)= flow_matrix(row,column+1,2)+(randi([-1, 1], 1)*2*pi*((angle_change_factor).*rand(1,1)));
        elseif row ~= n1
             flow_matrix(row,column,1)= flow_matrix(row+1,column,1)*(magnitude_decrease_factor + (0.1).*rand(1,1));
             flow_matrix(row,column,2)= flow_matrix(row+1,column,2)+(randi([-1, 1], 1)*2*pi*((angle_change_factor).*rand(1,1)));
        end
    end
end

