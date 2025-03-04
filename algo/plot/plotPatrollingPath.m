function plotPatrollingPath(patrollingPath)
stepSize = 0.1;
Nsteps = patrollingPath(end).CumSum/stepSize;

s = linspace(0,patrollingPath(end).CumSum,Nsteps);
 [xy,~] = pointOnPerimeter(s(1:end),patrollingPath);

plot(xy(:,1),xy(:,2))