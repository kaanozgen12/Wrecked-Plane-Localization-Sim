function [p_stay, p_trans] = eval_probs(is_flow_active,L_voxel,D,delta_t,flow_matrix,i,j)
    
    if (is_flow_active)
        [p_stay, p_trans] = evl_pstay_2D_withFLOW(L_voxel, D, delta_t,flow_matrix,i,j);
    else
        [p_stay, p_trans] = evl_pstay_2D_woutFLOW(L_voxel, D, delta_t);
    end
end



function [p_stay, p_trans] = evl_pstay_2D_woutFLOW(L_voxel, D, delta_t)
denumerator = sqrt(4*D*delta_t);

fun = @(x,y) (1/4) * ( erf((L_voxel-x)/denumerator)-erf(-x/denumerator) ) .* ( erf((L_voxel-y)/denumerator)-erf(-y/denumerator) ); 

p_stay = integral2(fun, 0,L_voxel, 0,L_voxel) / L_voxel^2;
p_trans.sum         = (1-p_stay);
p_trans.x_positive  = p_trans.sum/4; % RIGHT
p_trans.x_negative  = p_trans.sum/4; % LEFT
p_trans.y_positive  = p_trans.sum/4; % UP
p_trans.y_negative  = p_trans.sum/4; % DOWN
end


function [p_stay, p_trans] = evl_pstay_2D_withFLOW(L_voxel, D, delta_t, flow_matrix, i, j)
v_flow_magnitude    = flow_matrix(i,j,1);
v_flow_angle        = (flow_matrix(i,j,2)/360)*2*pi;
v_flow_x            = v_flow_magnitude*cos(v_flow_angle);
v_flow_y            = v_flow_magnitude*sin(v_flow_angle);

denumerator = sqrt(4*D*delta_t);

fun_stay       = @(x,y) (1/4) * ( erf((L_voxel-x-v_flow_x*delta_t)/denumerator)-erf((-x-v_flow_x*delta_t)/denumerator) )          .* ( erf((L_voxel-y-v_flow_y*delta_t)/denumerator)-erf((-y-v_flow_y*delta_t)/denumerator) ); 
fun_x_positive = @(x,y) (1/4) * ( erf((2*L_voxel-x-v_flow_x*delta_t)/denumerator)-erf((L_voxel-x-v_flow_x*delta_t)/denumerator) ) .* ( erf((L_voxel-y-v_flow_y*delta_t)/denumerator)-erf((-y-v_flow_y*delta_t)/denumerator) ); 
fun_x_negative = @(x,y) (1/4) * ( erf((-x-v_flow_x*delta_t)/denumerator)-erf((-L_voxel-x-v_flow_x*delta_t)/denumerator) )         .* ( erf((L_voxel-y-v_flow_y*delta_t)/denumerator)-erf((-y-v_flow_y*delta_t)/denumerator) ); 
fun_y_positive = @(x,y) (1/4) * ( erf((L_voxel-x-v_flow_x*delta_t)/denumerator)-erf((-x-v_flow_x*delta_t)/denumerator) )          .* ( erf((2*L_voxel-y-v_flow_y*delta_t)/denumerator)-erf((L_voxel-y-v_flow_y*delta_t)/denumerator) ); 
fun_y_negative = @(x,y) (1/4) * ( erf((L_voxel-x-v_flow_x*delta_t)/denumerator)-erf((-x-v_flow_x*delta_t)/denumerator) )          .* ( erf((-y-v_flow_y*delta_t)/denumerator)-erf((-L_voxel-y-v_flow_y*delta_t)/denumerator) ); 

r_x_positive  = integral2(fun_x_positive, 0,L_voxel, 0,L_voxel) / L_voxel^2;
r_x_negative  = integral2(fun_x_negative, 0,L_voxel, 0,L_voxel) / L_voxel^2;
r_y_positive  = integral2(fun_y_positive, 0,L_voxel, 0,L_voxel) / L_voxel^2;
r_y_negative  = integral2(fun_y_negative, 0,L_voxel, 0,L_voxel) / L_voxel^2;
r_sum = r_x_positive + r_x_negative + r_y_positive + r_y_negative;

p_stay = integral2(fun_stay, 0,L_voxel, 0,L_voxel) / L_voxel^2;
p_trans.sum         = (1-p_stay);
p_trans.x_positive  = r_x_positive * p_trans.sum / r_sum;
p_trans.x_negative  = r_x_negative * p_trans.sum / r_sum;
p_trans.y_positive  = r_y_positive * p_trans.sum / r_sum;
p_trans.y_negative  = r_y_negative * p_trans.sum / r_sum;
end


