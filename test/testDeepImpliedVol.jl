using Test
using FinancialToolbox, JSON
file_bin = read("impvres.json");
loaded_obj = JSON.parse(file_bin, allownan = true)
inputs = loaded_obj["input"]
outputs = loaded_obj["output"]
N = length(inputs);
toll = 1e-12
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
    end
end