function [initial_phase] = pseudorandomPhase(N,M,dPhi)
%generates a 2D pseudorandom array by random walk with steps of dPhi in both directions
coinflip = @(x) round(rand(1,x))*2-1;

%%%dPhi = pi/6; %1.335; %2.0;
initial_phase = zeros(N,M);

%% switch directions after each row
% for px=2:M
%     initial_phase(1,px) = initial_phase(1,px-1) + coinflip(1)*dPhi;
% end
% for py=2:N
%     if rem(py,2)==1 %odd
%     %left to right
%         initial_phase(py,1) = initial_phase(py-1,1) + coinflip(1)*dPhi;
%         for px=2:M
%             if initial_phase(py-1,px)-initial_phase(py-1,px-1) > 0
%                 if initial_phase(py,px-1)-initial_phase(py-1,px-1) > 0
%                     %0+ 12 12
%                     %+  23 21
%                     initial_phase(py,px) = initial_phase(py,px-1) +coinflip(1)*dPhi;
%                 else
%                     %0+ 12 
%                     %-  01
%                     initial_phase(py,px) = initial_phase(py-1,px-1);
%                 end
%             else
%                 if initial_phase(py,px-1)-initial_phase(py-1,px-1) > 0
%                     %0- 21
%                     %+  32
%                     initial_phase(py,px) = initial_phase(py-1,px-1);
%                 else
%                     %0- 21 21
%                     %-  10 12
%                     initial_phase(py,px) = initial_phase(py,px-1) +coinflip(1)*dPhi;
%                 end
%             end
%         end
%     else
%     %right to left
%         initial_phase(py,N) = initial_phase(py-1,N) + coinflip(1)*dPhi;
%         for px=M-1:-1:1
%             if initial_phase(py-1,px+1)-initial_phase(py-1,px) > 0
%                 if initial_phase(py,px+1)-initial_phase(py-1,px+1) > 0
%                     %-0 12
%                     % + 23
%                     initial_phase(py,px) = initial_phase(py-1,px+1);
%                 else
%                     %-0 12 12
%                     % - 01 21
%                     initial_phase(py,px) = initial_phase(py,px+1) +coinflip(1)*dPhi;
%                 end
%             else
%                 if initial_phase(py,px+1)-initial_phase(py-1,px+1) > 0
%                     %+0 21 21
%                     % + 32 12
%                     initial_phase(py,px) = initial_phase(py,px+1) +coinflip(1)*dPhi;
%                 else
%                     %+0 21
%                     % - 10
%                     initial_phase(py,px) = initial_phase(py-1,px+1);
%                 end
%             end
%         end
%     end
% end
%---
%% chose direction randomly
for py=2:N
    if round(rand(1)) %left to right
        initial_phase(py,1) = initial_phase(py-1,1) + coinflip(1)*dPhi;
        for px=2:M
            if py==2
                if round(rand(1))
                    initial_phase(1:2,:) = flipud( initial_phase(1:2,:) );
                end
                initial_phase(1,px) = initial_phase(1,px-1) + coinflip(1)*dPhi;
            end
            %--- 
            if initial_phase(py-1,px)-initial_phase(py-1,px-1) > 0
                if initial_phase(py,px-1)-initial_phase(py-1,px-1) > 0
                    %0+ 12 12
                    %+  23 21
                    initial_phase(py,px) = initial_phase(py,px-1) +coinflip(1)*dPhi;
                else
                    %0+ 12 
                    %-  01
                    initial_phase(py,px) = initial_phase(py-1,px-1);
                end
            else
                if initial_phase(py,px-1)-initial_phase(py-1,px-1) > 0
                    %0- 21
                    %+  32
                    initial_phase(py,px) = initial_phase(py-1,px-1);
                else
                    %0- 21 21
                    %-  10 12
                    initial_phase(py,px) = initial_phase(py,px-1) +coinflip(1)*dPhi;
                end
            end
        end
    else %right to left
        initial_phase(py,N) = initial_phase(py-1,N) + coinflip(1)*dPhi;
        for px=M-1:-1:1
            if py==2
                if round(rand(1))
                    initial_phase(1:2,:) = flipud( initial_phase(1:2,:) );
                end
                initial_phase(1,px) = initial_phase(1,px+1) + coinflip(1)*dPhi;
            end
            %---
            if initial_phase(py-1,px+1)-initial_phase(py-1,px) > 0
                if initial_phase(py,px+1)-initial_phase(py-1,px+1) > 0
                    %-0 12
                    % + 23
                    initial_phase(py,px) = initial_phase(py-1,px+1);
                else
                    %-0 12 12
                    % - 01 21
                    initial_phase(py,px) = initial_phase(py,px+1) +coinflip(1)*dPhi;
                end
            else
                if initial_phase(py,px+1)-initial_phase(py-1,px+1) > 0
                    %+0 21 21
                    % + 32 12
                    initial_phase(py,px) = initial_phase(py,px+1) +coinflip(1)*dPhi;
                else
                    %+0 21
                    % - 10
                    initial_phase(py,px) = initial_phase(py-1,px+1);
                end
            end
        end
    end
end

end

