using Test
using FinancialToolbox, ReverseDiff

#Test Parameters
spot = 10.0;
K = 10;
r = 0.02;
T = 2.0;
sigma = 0.2;
d = 0.01;

toll = 1e-4

#EuropeanCall Option
f_rv(S0) = blsprice(S0[1], K, r, T, sigma, d);
delta_1 = blsdelta(spot, K, r, T, sigma, d);
delta_v = ReverseDiff.gradient(f_rv, [spot])
@test(abs(delta_v[1] - delta_1) < toll)
price = f_rv(spot)
f_rv2(S0) = blsimpv(S0[1], K, r, T, price, d);
delta_v = ReverseDiff.gradient(f_rv2, [spot])
@test(abs(delta_v[1] + 0.10586634302510232) < toll)