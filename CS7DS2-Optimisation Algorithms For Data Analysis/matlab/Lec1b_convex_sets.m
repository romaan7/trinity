% Lecture 1b - Convex Sets

% Example 1: Creating an affine set

x1=[1,2];
x2=[3,5];
plot([x1(1,1) x2(1,1)], [ x1(1,2) x2(1,2)], '*')
xlim([0 6]) 
ylim([0 6])
txt1 = 'X1';
text(x1(1,1),x1(1,2),txt1)
txt1 = 'X2';
text(x2(1,1),x2(1,2),txt1)


th=-0.1;
z=th.*x1+(1-th).*x2;
hold on
plot(z(1,1), z(1,2), 'o')

th=0.9;
z=th.*x1+(1-th).*x2;
hold on
plot(z(1,1), z(1,2), 'o')

for th=-0.2:0.01:1.19
    z=th.*x1+(1-th).*x2;
    hold on
    plot(z(1,1), z(1,2), '.')    
end

%% ------------------------------------------------------------------------



% Example 2: Creating a convex hull
x1 = rand(1,10);
y1 = rand(1,10);
plot(x1,y1,'k*')

vi = convhull(x1,y1); % https://uk.mathworks.com/help/matlab/ref/convhull.html

axis equal
hold on
fill ( x1(vi), y1(vi), [0.9,1,1],'facealpha', 0.5 ); % [1,1,1] for white
hold off

polyarea(x1(vi),y1(vi)) % in case we want to calculate the "surface/area" of the hull.


%% ------------------------------------------------------------------------

% Example 3: Creating a cone
x1=[1,2]; % initially we have just a set of two points
x2=[2,1];
plot([x1(1,1) x2(1,1)], [ x1(1,2) x2(1,2)], '*')
xlim([0 4]) 
ylim([0 4])
txt1 = 'X1';
text(x1(1,1),x1(1,2),txt1)
txt1 = 'X2';
text(x2(1,1),x2(1,2),txt1)

% finding
th1=0.5;
th2=0.3;
z=th1.*x1+th2.*x2;
hold on
plot(z(1,1), z(1,2), 'ko')

th1=0.2;
th2=0.4;
z=th1.*x1+th2.*x2;
hold on
plot(z(1,1), z(1,2), 'ko')

for th1=0:0.08:6
    for th2=0:0.08:6
    z=th1.*x1+th2.*x2;
    hold on
    plot(z(1,1), z(1,2), 'ro')    
    end
end

%%-----------------------------------------------------------------------
% Example 4: Creating a non-convex cone

x=-2:0.02:2;
y=abs(x);
plot(x,y)
xlabel('x')
ylabel('y')

%%-----------------------------------------------------------------------


% Example 5: Hyperplane
A=[3, 2];
B=6;
x=linsolve(A,B);
Z = null(A,'r');
for q=0:0.01:10 % https://uk.mathworks.com/help/matlab/math/systems-of-linear-equations.html#bt7ov7u
    y=x+Z*q;
    hold on
    plot(y(1,1), y(2,1), '.')
end
xlim([0 4]) 
xlabel('x')
ylabel('y')
ylim([0 4])
title('hyperplane of 3x_1+2x_2=6')


% Example 6: Hyperspace
x=0:0.01:5;
y=(6-3*x)/2;
plot(x,y,'k*')
title('hyperspaces defined by 3x_1+2x_2=6')
xlim([0 4]) 
xlabel('x')
ylabel('y')
ylim([0 4])
hold on
fill([0,0,2],[0,3,0], 'y')
text(0.5,0.5, '3x_1+2x_2<6' )
text(3,3, '3x_1+2x_2>6' )
hold off




 

