function HDR = CNN(input, size_input, stride, net_weights, net_model, flag)

    phase = 'test';
    net = caffe.Net(net_model, net_weights, phase);
    
    im_input = VDP(input) / (2^12 - 1);
    [m,n] = size(im_input);
    hei = m;
    wid = n;
    
    padding = 0;
    size_label = size_input;

    HDR = zeros(m,n,1);

    du = zeros(1,32);
    dv = zeros(1,32);
    du(1,17 : 32) = abs((17 : 32) - 32) + 1;
    du = repmat(du,[32 1 1]);
    dv(1,1 : 16,1) = abs(17 - (17 : 32)) + 1; % == 1 : 16
    dv = repmat(dv,[32 1 1]);
    dl = zeros(32,1);
    dl(17 : 32,1) = abs((17 : 32) - 32) + 1;
    dl = repmat(dl,[1 n 1]);
    dn = zeros(32,1);
    dn(1 : 16,1) = abs(17 - (17 : 32)) + 1;
    dn = repmat(dn,[1 n 1]);
 
    for x = 1 : stride : hei-size_input+1
        %fprintf('%d rows in processing .............\n',x);
        for y = 1 : stride : wid-size_input+1
            data = cell(1,1);
            subim_input = im_input(x : x+size_input-1, y : y + size_input-1,:);
            
            im_RGGB = subim_input;
            
            data{1,1} = im_RGGB;
            result = net.forward(data);
            z = result{1,1};
            
            if y == 1
                HDR(x + padding : x + padding + size_label - 1, y + padding : y + padding + size_label - 1,:) = z;
                u = z;
            else
                v = z;
                start = y;
                fin = (y - stride) + size_input - 1;
                %            Weight Average (Blend Mosaic method)
                h = (du(:,stride + 1 : size_input,:) .* u(:,stride + 1 : size_input,:) + dv(:,1 : stride,:) .* v(:,1 : stride,:)) ...
                    ./ (du(:,stride + 1 : size_input,:) + dv(:,1 : stride,:));
                %            Determine Overlapp Pixels
                HDR(x + padding : x + padding + size_label - 1, start : fin ,:) = h;
                
                HDR(x+padding : x+padding+size_label-1, fin + 1 : y + size_label-1,:) = ...
                    v(:, stride + 1: size_input ,:);
                
                u = HDR(x + padding : x + padding + size_label - 1, y + padding : y + padding + size_label - 1,:);
            end
        end
        if x ~= 1
            n = HDR(x  : x + size_label - 1,:,:);
            start = x;
            fin = (x - stride) + size_input - 1;
            %         Weight Average (Blend Mosaic method)
            g = (dl(stride + 1 : size_input, :, :) .* l(stride + 1 : size_input,:,:) + dn(1 : stride,:,:) .* n(1 : stride,:,:)) ...
                ./ (dl(stride + 1 : size_input, :, :) + dn(1 : stride, :, :));
            %         Determine Overlapp Pixels
            HDR(start : fin, :, :) = g;
            HDR(fin + 1 : x + size_label-1, :, :) = n(stride + 1 : size_input, :, :);
            
            l = HDR(x  : x + size_label - 1,:,:);
        else
            l = HDR(x  : x + size_label - 1,:,:);
        end
    end
    HDR(HDR < 0) = 0;

end
