function out = RastriFun(inp)

out = 10.0 * length(inp) + sum(inp .^2 - 10.0 * cos(2 * pi .* inp));




end