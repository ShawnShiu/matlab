% compare value of send and recieve
function err_num = compare_array(len,arr1,arr2)
    err_num = 0;
    for c = 1:len
        err_num = err_num + (arr1(c) ~= arr2(c));
    end
end
