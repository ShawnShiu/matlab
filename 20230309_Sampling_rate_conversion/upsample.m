function ret = upsample(multiple,arr)
    size_arr = length(arr);
    new_size = size_arr*multiple;
    ret = zeros(1,new_size);
    c=1;
    for n = 1 : size_arr
        ret(c) = arr(n);
        c = c + multiple;
    end
end

% function ret = upsample(multiple,arr)
%     size_a=length(arr);
%     c=1;
%     ret = zeros(1,size_a*multiple);
%     for n = 1 : size_a
%         ret(c) = arr(n);
%         c = c + multiple;
%     end
% end
