[X,Y]=meshgrid(1:meshsize+1);
figure; 
hold on;
plot(X-0.5,Y-0.5,'k');
plot(Y-0.5,X-0.5,'k');
% %axis off
% theta = pi/0.9;
% r = 0.3; % magnitude (length) of arrow to plot
% %x = 4; y = 5;
% %h = quiver(x,y,u,v);
flow = random_flow(meshsize,meshsize);
for n=1:meshsize
    for p=1:meshsize
        theta = flow(n,p,2);
        r = flow(n,p,1);
        u = r * cos(theta); % convert polar (theta,r) to cartesian
        v = r * sin(theta);
        h = quiver(meshsize-p+1,meshsize-n+1,u,v);
    end
end

