function X = bits_to_4PAM(b)
    
    b_pairs = reshape(b, 2, [])'; 
    
    % Αρχικοποίηση του διανύσματος των συμβόλων
    X = zeros(length(b)/2, 1);
    
    % mapping
    idx_00 = (b_pairs(:,1) == 0) & (b_pairs(:,2) == 0);
    X(idx_00) = 3;
    
    idx_01 = (b_pairs(:,1) == 0) & (b_pairs(:,2) == 1);
    X(idx_01) = 1;
    
    idx_11 = (b_pairs(:,1) == 1) & (b_pairs(:,2) == 1);
    X(idx_11) = -1;
    
    idx_10 = (b_pairs(:,1) == 1) & (b_pairs(:,2) == 0);
    X(idx_10) = -3;
end