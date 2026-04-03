function y = istft_estimate(Xmod, L)

    Nfft = 1024;          
    Nw = 256;             
    R = 128;             

    [K, M] = size(Xmod);

    if K ~= 513
        error('Xmod must have 513 rows for a 1024-point FFT of a real signal.');
    end

    % output accumulation arrays
    y_sum = zeros(L,1);
    y_count = zeros(L,1);

    for m = 1:M
        % positive-frequency part
        Xpos = Xmod(:,m);

        % reconstructing the full conjugate-symmetric 1024-point spectrum
        % X(1) = DC, X(513) = Nyquist
        Xfull = [Xpos; conj(Xpos(512:-1:2))];

        % inverse FFT and force real output
        xseg = real(ifft(Xfull, Nfft));

        % keeping the first 256 samples only (as per instructions)
        xseg = xseg(1:Nw);

        start_idx = (m-1)*R + 1;
        end_idx = start_idx + Nw - 1;

        if start_idx > L
            break;
        end

        if end_idx > L
            valid_len = L - start_idx + 1;
            y_sum(start_idx:L) = y_sum(start_idx:L) + xseg(1:valid_len);
            y_count(start_idx:L) = y_count(start_idx:L) + 1;
        else
            y_sum(start_idx:end_idx) = y_sum(start_idx:end_idx) + xseg;
            y_count(start_idx:end_idx) = y_count(start_idx:end_idx) + 1;
        end
    end

    y_count(y_count == 0) = 1;

    % averaging the overlapping estimates
    y = y_sum ./ y_count;
end