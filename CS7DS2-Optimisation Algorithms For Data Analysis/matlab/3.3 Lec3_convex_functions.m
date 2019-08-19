% Lecture 2 - Convex Functions

% Example 1: A concave function

x=0.1:0.01:20;
y=log(x); % selecting the log function here
plot(x,y,'k-') % plotting this concave function for all x
xlabel('x')
ylabel('f(x)=logx')

hold on
x1=1.5; y1=log(x1); % selecting one point (x1,y1) from the function
plot(x1, y1, 'r*')
txt1 = 'x1, y1=log(x1)';
text(x1+0.5, y1, txt1)

hold on
x2=9.5; y2=log(x2); % selecting a different point (x2,y2)
plot(x2, y2, 'r*')
txt1 = 'x2, y2=log(x2)';
text(x2+0.5, y2-0.1, txt1)

hold on  % connecting the two points
plot([x1,x2], [y1,y2], 'k--')

th=0.6;
x3=th*x1 + (1-th)*x2; % selecting a point in the line connecting x1, x2
y3a=log(x3); % selecting the respective y
y3b=th*log(x1)+(1-th)*log(x2); % selecting the convex combination of the values of y1, y2
hold on
plot(x3, y3a, 'r*')
txt1 = 'x3, y3=log(x3)';
text(x3-1.3, y3a+0.2, txt1)
hold on
plot(x3, y3b, 'r*')
txt1 = 'x3, th*log(x1)+(1-th)*log(x2)';
text(x3+0.5, y3a-0.6, txt1)

%% ------------------------------------------------------------------------

% Example 2: Plotting a convex function
x=0.1:0.01:20;
a=0.5; % becomes concave for a<1
y=x.^a;
plot(x,y,'k-') % plotting this convex function for all x
xlabel('x')
ylabel('f(x)=x^a')



% Example 3: Plotting the sum of convex functions
x=0.1:0.01:20;
a=2; % becomes concave for a<1
y1=x.^a; % convex function
y2=10*x.*log(x); % convex function
plot(x,y1, 'k-')
hold on
plot(x,y2, 'r-')
hold on
plot(x,y1+y2,'k--') % plotting their sum
xlabel('x')
ylabel('f1(x)+f2(x)')


% Example 4: Plotting the sum of concave and convex functions
x=0.1:0.01:20;
a=1.8; % becomes concave for a<1
y1=x.^a; % convex function
y2=25*log(x); % concave function
plot(x,y1, 'k-')
hold on
plot(x,y2, 'r-')
hold on
plot(x,y1+y2,'k--') % plotting their sum. 
xlabel('x')
ylabel('f1(x)+f2(x)')


