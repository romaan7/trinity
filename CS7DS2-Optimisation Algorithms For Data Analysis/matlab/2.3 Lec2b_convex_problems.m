% Lecture 3 - Convex Problems

% Example 1: A non-convex function constraint giving a convex feasible set

clear; clc % plot the non-convex constraint function
x1=-10:0.1:10;
x2=-10:0.1:10;
y=x1./(1+x2.^2);
plot3(x1,x2,y)
xlabel('x1')
ylabel('x2')
zlabel('y')
grid on

for x1=-10:0.2:10 % plot the feasibility region which is convex
    for x2=-5:0.2:5
        if ((x1./(1+x2.^2))<0 )
             plot(x1,x2, 'k*')
             hold on
        end
    end
end
xlabel('x1')
ylabel('x2')
xlim([-10 10])
ylim([-5 5])


% Example 2: Global and Local optima

x=1:0.1:15;
y=0.1*x.^3+400*log(x+1);
plot(x,y)
xlabel('x')
ylabel('y')