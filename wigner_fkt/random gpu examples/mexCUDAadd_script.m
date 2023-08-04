%compile:
mexcuda mexCUDAadd.cu

x = gpuArray.ones(4,4);
y = mexCUDAadd(x);
y = gather(y)

disp(['class(x) = ',class(x),', class(y) = ',class(y)])
