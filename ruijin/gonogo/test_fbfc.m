N = 1000;
Lb = -8;
Ub = 8;

fb = 1;
fc = 1;
[psi,x] = cmorwavf(Lb,Ub,N,fb,fc);
subplot(3,1,1)
plot(x,real(psi)); title('fc=1,fb=1');


fb = 10;
fc=1;
[psi,x] = cmorwavf(Lb,Ub,N,fb,fc);
subplot(3,1,2)
plot(x,real(psi)); title('fc=1,fb=10');


fb = 10;
fc = 10;
[psi,x] = cmorwavf(Lb,Ub,N,fb,fc);
subplot(3,1,3)
plot(x,real(psi)); title('fc=10,fb=10');