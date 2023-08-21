D = 5;
f0 = 10;
fm = 2*f0;    % nyquist reestriction
t = (-D:1/fm:D-1/fm);
x = rand(size(t))-0.5;%cos(2*2*pi*t);
h = sinc(t(3*numel(t)/8:5*numel(t)/8-1));
x_p1 = filter(h,1,x);

figure(1);plot(x);title('signal');
figure(2);plot(abs(fftshift(fft(fftshift(x)))));title('fft signal');
figure(3);plot(h);title('filter1');
figure(4);plot(x_p1);title('filter1(signal)');
figure(5);plot(abs(fftshift(fft(fftshift(x_p1)))));title('fft(filter1(signal))');

ns = numel(t);
ns = ns/4;
f = -fm/2:fm/ns:fm/2-fm/ns;
h1 = ifftshift(diric(f/fm,2*ns));
x_p2 = filter(h1,1,x);

figure(6);plot(h1);title('filter2');
figure(7);plot(x_p2);title('filter2(signal))');
figure(8);plot(abs(fftshift(fft(fftshift(x_p2)))));title('fft(filter2(signal))');
