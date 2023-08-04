function output = crop(input,N,M)
%scale array "input" to size (N,M)

dim = size(input);
diff = [dim(1)-N,dim(2)-M];
offset = floor(diff/2);

output = zeros([N,M,size(input,3)]);

if dim(2)==M && dim(1)==N
    output = input;
else
    if dim(2)<M
        if dim(1)<N
            output(-offset(1)+1:-offset(1)+dim(1),-offset(2)+1:-offset(2)+dim(2),:) = input;
        else
            output(:,-offset(2)+1:-offset(2)+dim(2),:) = input(offset(1)+1:offset(1)+N,:,:);
        end
    else
        if dim(1)<N
            output(-offset(1)+1:-offset(1)+dim(1),:,:) = input(:,offset(2)+1:offset(2)+M,:);
        else
            output = input(offset(1)+1:offset(1)+N,offset(2)+1:offset(2)+M,:);
        end
    end
end

end