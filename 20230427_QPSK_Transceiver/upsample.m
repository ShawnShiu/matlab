function ret = upsample(multiple,arr)
    ret = zeros(1 , length(arr)*multiple );
    ret(1:multiple:end) = arr;
end
