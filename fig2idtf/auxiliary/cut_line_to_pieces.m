function [y] = cut_line_to_pieces(x, npiece)
[nrows, n] = size(x);
p = floor(n /npiece);
m = mod(n, npiece);

if m == 0
    m = [];
end

k = [npiece*ones(1, p), m];

y = mat2cell(x, nrows, k);
