function [y] = cut_line_to_pieces(x, nperpiece)
[nrows, n] = size(x);
n_pieces = floor(n /nperpiece);
m = mod(n, nperpiece);

% n = multiple of npiece ?
if m == 0
    m = [];
elseif m == 1
    % no line with 1 point only!
    % merge with previous piece
    n_pieces = n_pieces -1;
    m = nperpiece +1;
end

k = [nperpiece*ones(1, n_pieces), m];

y = mat2cell(x, nrows, k);
