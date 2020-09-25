function imgOut = our_tabledFunction(img, table, index, flag)

    col = size(img, 3);
    imgOut = zeros(size(img));
    for i = 1 : col 
        A(:,:,i) = interp1(index(:,i), table(:, i), img(:,:,i), 'nearest', 'extrap');
    end
    
    if flag == 0
        for i=1:col
            imgOut(:,:,i) = interp1(table(:, i), index(:,i), img(:,:,i), 'nearest', 'extrap');
        end
    else
        for i=1:col
            imgOut(:,:,i) = interp1(index(:,i), table(:, i), img(:,:,i), 'nearest', 'extrap');
        end
    end
end