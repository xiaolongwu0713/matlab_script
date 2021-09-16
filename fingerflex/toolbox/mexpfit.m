function  [X, c, info, perf] = mexpfit(ty, x0, opts)
%MEXPFIT  Least squares fit of sum of decaying exponentials:  
% Find  xm = argmin{F(x)} , where  x  is an n-vector with negative 
% values.  Let  ty(i,:) = [ti  yi], then
%     F(x) = .5||r(x)||^2,   ri(x) = yi - c'*Ei
% with  Ei = [1 exp(x1*ti)  ...  exp(xn*ti)]  and  c = c(x)  is
% the least squares solution to  E*c "=" y .  (The constant term
% may be omitted, see opts.)
%
% Call
%      [X, c, info {, perf}] = mexpfit(ty, x0, opts)
%
% Input parameters
% ty   :  Data points. 
% x0   :  Starting guess for  x .
% opts :  Vector with 5 elements:
%         opts(1) = 0 :  Constant term is omitted.
%         opts(2:4)  used in stopping criteria:
%             ||g||_inf <= opts(2)                     or 
%             ||dx||_2 <= opts(3)*(opts(3) + ||x||_2)  or
%             no. of function evaluations exceeds  opts(4) .
%         opts(5) :  Used to get starting value for Marquardt
%             damping parameter.  Default: opts(5) = 1e-3.
%
% Output parameters
% X    :  If  perf  is present, then array, holding the iterates
%         columnwise.  Otherwise, computed solution vector.
% c    :  Coefficients [c0, ..., cn]
%
% info :  Performance information, vector with 5 elements:
%         info(1:3) = final values of 
%             [F(x)  ||F'||inf  ||dx||2  
%         info(4) = no. of evaluations of (F,J)
%         info(5) = 1 :  Stopped by small gradient
%                   2 :  Stopped by small x-step
%                   3 :  Stopped by  kmax
%                   4 :  Stopped by extreme step
%                   5 :  Stopped by stalling.
% perf :  (optional). If present, then array, holding 
%         perf(1:2,:) = values of  F(x) and || F'(x) ||inf
%         perf(3,:) = mu-values.
%
% Use of other MATLAB functions :  QRFACSOL.
%
% Method
% Levenberg-Marquardt-Gauss-Newton, see H.B. Nielsen: "Damping 
% Parameter in Marquardt's Method", IMM-REP-1999-05.
% See  H.B. Nielsen: "Separable Nonlinear Least Squares", 
% IMM-REP-2000-01, about the formulation of the model.

% Hans Bruun Nielsen,  IMM, DTU.  00.02.14

  %  Initialise
  x = -sort(-x0(:));   n = length(x);  offset = opts(1);     
  if  any(x >= 0),  error('x must be strictly negative'), end
  if  length(opts) < 5,  opts(5) = 1e-3; end
  if  opts(5) <= 0,  opts(5) = 1e-3; end
  %  Initial values
  [f J c] = func(x, ty, offset);
  A = J'*J;   g = J'*f;   F = (f'*f)/2;   ng = norm(g,inf);
  mu = opts(5) * max(diag(A));    kmax = opts(4);
  Trace = nargout > 3;
  if  Trace
    X = x*ones(1,kmax+1);   perf = [F; ng; mu]*ones(1,kmax+1);
  end 
  k = 1;  neval = 1;  nu = 2;  stop = 0;  mok = 0;
  
  while   ~stop
    if  ng <= opts(2),  stop = 1;  
    else
      h = (A + mu*eye(n))\(-g);
      nh = norm(h);   nx = opts(3) + norm(x);
      if      nh <= opts(3)*nx,  stop = 2;
      elseif  nh >= nx/eps,   stop = 4; end    % Almost singular ?
    end 
    if  ~stop
      %  Check h
      i = find(x + h >= 0);
      if  ~isempty(i)    % Reduce h
        h = min(-.99*x(i)./h(i))*h;  mu = 10*mu
      end    
      xnew = x + h;   h = xnew - x;   dL = (h'*(mu*h - g))/2; 
      [fn Jn] = func(xnew, ty, offset);  neval = neval + 1;   
      Fn = (fn'*fn)/2;   dF = F - Fn;
      if  (dL > 0) & (dF > 0)
        x = xnew;   F = Fn;  J = Jn;  f = fn; 
        A = J'*J;   g = J'*f;   ng = norm(g,inf);
        mok = mok + 1;
        mu = mu * max(1/3, 1 - (2*dF/dL - 1)^3);   nu = 2;
      else    % Marquardt fail
        mu = mu*nu;  nu = 2*nu;
        if  mok > n & nu > 8, stop = 5; end 
      end
      k = k + 1;
      if  Trace, X(:,k) = x(:);   perf(:,k) = [F; ng; mu]; end
      if  neval == kmax,  stop = 3; end
    end   
  end
  %  Set return values
  x = -sort(-x);
  if  Trace
    X = [X(:,1:k-1) x];   perf = perf(:,1:k);
  else,  X = x;  end
  [r J c] = func(x, ty, offset);
  F = .5*dot(r,r);   
  if  offset, c = c([n+1 1:n]); end
  info = [F  ng  nh  neval  stop];

% ==========  auxiliary function  =================================

function  [r,J,c] = func(x, p, offset)
% Function for exponential fit.  Separated.

  m = size(p,1);   n = length(x);
  if  offset,  F = [exp(p(:,1) * x') ones(m,1)];
  else,        F = [exp(p(:,1) * x')];          end
  [c cons fac] = qrfacsol('BA',F,p(:,2));
  if  fac.rk < n,  x,  error('Singular F'), end
  r = p(:,2) - F*c;   
  %  Jacobian
  J = zeros(m,n);   
  for  j = 1 : n
    jj = -p(:,1).*F(:,j);   b = c(j)*(F'*jj);   b(j) = b(j) - jj'*r;
    dc = qrfacsol('BAA',fac,b);   J(:,j) = c(j)*jj - F*dc;
  end
   
