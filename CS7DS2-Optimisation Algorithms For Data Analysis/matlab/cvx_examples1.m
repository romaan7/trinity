
%cd ~/MATLAB/cvx
%cvx_setup
 

%1st
% m = 16; n = 8;
% A = randn(m,n);
% b = randn(m,1); 
% 
% cvx_begin
%     variable x(n)
%     minimize ( norm(A*x-b) )
% cvx_end



% %2nd
% bnds = randn(n,2);
% l = min( bnds, [], 2 );
% u = max( bnds, [], 2 );
% 
% cvx_begin
%     variable x(n)
%     minimize( norm(A*x-b) )
%     subject to
%         l <= x 
%         x <= u
% cvx_end


%3rd
% p = 4;
% C = randn(p,n);
% d = randn(p,1);
% 
% cvx_begin
%     variable x(n);
%     minimize( norm(A*x-b) );
%     subject to
%         C*x == d;
%         norm(x,Inf) <= 1;
% cvx_end



%4th
% gamma = logspace( -2, 2, 20 );
% l2norm = zeros(size(gamma));
% l1norm = zeros(size(gamma));
% fprintf( 1, '   gamma       norm(x,1)    norm(A*x-b)\n' );
% fprintf( 1, '---------------------------------------\n' );
% for k = 1:length(gamma),
%     fprintf( 1, '%8.4e', gamma(k) );
%     cvx_begin quiet
%         variable x(n);
%         minimize( norm(A*x-b)+gamma(k)*norm(x,1) );
%     cvx_end
%     l1norm(k) = norm(x,1);
%     l2norm(k) = norm(A*x-b);
%     fprintf( 1, '   %8.4e   %8.4e\n', l1norm(k), l2norm(k) );
% end
% plot( l1norm, l2norm );
% xlabel( 'norm(x,1)' );
% ylabel( 'norm(A*x-b)' );
% grid on



%5th
n=20;
bnds = randn(n,2);
l = min( bnds, [], 2 );
u = max( bnds, [], 2 );

cvx_begin
    variable x(n)
    minimize( x'*x )
    subject to
        l <= x 
cvx_end


% plotting the x^2 |Ax=b values and the duals
n=2;
A=[1 2 ; 3 4];
b=[1; 2];
cvx_begin
    variable x(n)
    dual variable y;
    minimize (x'*x)
    subject to
        y: A*x==b;
cvx_end

L=x'*x+y'*(A*x-b); % let's check if the dual has the same value.



