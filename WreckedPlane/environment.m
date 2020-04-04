meshsize_x = 100;
meshsize_y = 100;
is_flow_active = true;
[X,Y]=meshgrid(1:meshsize_x+1);
L_voxel = 0.25;
D       = 7;
delta_t = 0.001 ; 
env_number_of_particles = 100000;
particles = zeros(meshsize_x,meshsize_y);
particles(50,50)= env_number_of_particles;
temp_particles= particles;
flow = random_flow(meshsize_x,meshsize_y);
flow_matrix_x_positive = zeros(meshsize_x,meshsize_y);
flow_matrix_x_negative = zeros(meshsize_x,meshsize_y);
flow_matrix_y_positive = zeros(meshsize_x,meshsize_y);
flow_matrix_y_negative = zeros(meshsize_x,meshsize_y);
flow_matrix_stay = zeros(meshsize_x,meshsize_y);


number_of_steps = 185;


for column=meshsize_y:-1:1
         for row=meshsize_x:-1:1
            [p_stay, p_trans] = eval_probs(is_flow_active,L_voxel,D,delta_t,flow,row,column);
            flow_matrix_x_positive(row,column) = p_trans.x_positive;
            flow_matrix_x_negative(row,column) = p_trans.x_negative;
            flow_matrix_y_positive(row,column) = p_trans.y_positive;
            flow_matrix_y_negative(row,column) = p_trans.y_negative;
            flow_matrix_stay(row,column) = p_stay;
         end
         disp(column*row)
end


for i=number_of_steps:-1:1
    A = particles.*flow_matrix_x_positive;
    B = particles.*flow_matrix_x_negative;
    C = particles.*flow_matrix_y_positive;
    D = particles.*flow_matrix_y_negative;
    E = particles.*flow_matrix_stay;
    particles = E + [zeros(1,meshsize_y) ; D(1:meshsize_x-1,:)] + [C(2:meshsize_x,:) ; zeros(1,meshsize_y)] + [ zeros(meshsize_x,1) , A(:, 1:meshsize_y-1)] + [B(:, 2:meshsize_y) , zeros(meshsize_x,1)];  
    disp(i)
end

% for i=number_of_steps:-1:1
%     
%     for column=meshsize_y:-1:1
%         for row=meshsize_x:-1:1
%             if particles(row,column) ~= 0
%                 [p_stay, p_trans] = eval_probs(is_flow_active,L_voxel,D,delta_t,flow,row,column);
%                 if (2<=row) && (row<=meshsize_x)
%                     temp_particles(row-1,column)= temp_particles(row-1,column) + particles(row,column)*p_trans.y_negative;
%                 end
%                 if (1<=row) && (row<meshsize_x) 
%                     temp_particles(row+1,column)= temp_particles(row+1,column) + particles(row,column)*p_trans.y_positive;
%                 end
%                 if (1<=column) && (column<meshsize_y)
%                     temp_particles(row,column+1)= temp_particles(row,column+1) + particles(row,column)*p_trans.x_positive;
%                 end
%                 if (2<=column) && (column<=meshsize_y)
%                     temp_particles(row,column-1)= temp_particles(row,column-1) + particles(row,column)*p_trans.x_negative;
%                 end
%                 temp_particles(row,column)=  temp_particles(row,column)*p_stay;
%             end
%         end
%     end
%     particles= temp_particles;
%     disp(i)
% end

imagesc(particles)
colorbar
% hold on
% for n=1:meshsize_x
%     for p=1:meshsize_y
%         theta = flow(n,p,2);
%         r = flow(n,p,1);
%         u = r * cos(theta); % convert polar (theta,r) to cartesian
%         v = r * sin(theta);
%         h = quiver(meshsize_x-p+1,meshsize_y-n+1,u,v);
%          set(h,'LineWidth',2)
%     end
% end

disp(sum(particles, 'all'))