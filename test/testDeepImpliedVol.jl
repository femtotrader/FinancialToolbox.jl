using Test
using FinancialToolbox, JSON
file_bin = read("impvres.json");
loaded_obj = JSON.parse(file_bin, allownan = true)
inputs = loaded_obj["input"]
outputs = loaded_obj["output"]
N = length(inputs);
toll = 1e-12
toll_vol = 1e-3
counter_el = 0
for i = 1:N
    r = 0.0
    cur_el = inputs[i]
    F = cur_el["F"]
    T = cur_el["T"]
    K = cur_el["K"]
    sigma = cur_el["sigma"]
    expected_res = outputs[i]["black"]
    q = cur_el["q"]
    iscall = q > 0
    price_internal = 0.0
    if F != 0.0 && T != 0.0 && K != 0.0 && sigma != 0.0
        price_internal = blkprice(F, K, r, T, sigma, iscall)
        @test abs(price_internal - expected_res) < toll
        xtol = eps(Float64)
        n_iter = 5
        #sigma_computed = blkimpv(big(F), big(K), big(r), big(T), big(price_internal), iscall,big(xtol),n_iter)
        sigma_computed = blkimpv(F, K, r, T, price_internal, iscall, xtol, n_iter)
        #sigma_loaded = outputs[i]["implied_volatility_from_a_transformed_rational_guess_with_limited_iterations"]
        if abs(sigma_computed - sigma) > toll_vol
            @show F, K, T, iscall, sigma, sigma_computed
            global counter_el += 1
        end
    end
end
println("counter : ", counter_el)
