function ret = downsample(multiple,arr)
    size_a=length(arr);
    c=1;
    ret = zeros(1,size_a);
    for loop = 1 :multiple
        for n = 1 :multiple: size_a
             ret(c) = arr(n);
             c=c+1;
        end
    end
end


% % function ret = downsample(multiple,arr)
% %     size_a=length(arr);
% %     c=1;
% %     for n = 1 :multiple: size_a
% %          ret(c) = arr(n);
% %          c=c+1;
% %     end
% % end
