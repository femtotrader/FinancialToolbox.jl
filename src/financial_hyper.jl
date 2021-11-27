using .HyperDualNumbers

function blkimpv_hyper(num1, num2, num3, num4, num5)
    @eval function blkimpv(S0::$num1, K::$num2, r::$num3, T::$num4, Price::$num5, FlagIsCall::Bool = true, xtol::Real = 1e-14, ytol::Real = 1e-15)
        blscheck(S0, K, r, T, 0.1, r)

        return blsimpv(S0, K, r, T, Price, r, FlagIsCall)
    end
end

type_blkimpv_hyper_1 = [Hyper, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}]
type_blkimpv_hyper_2 = [Real, Hyper, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}]
type_blkimpv_hyper_3 = [Real, Real, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}]
blkimpv_hyper(type_blkimpv_hyper_1[1], type_blkimpv_hyper_1[2], type_blkimpv_hyper_1[3], type_blkimpv_hyper_1[4], type_blkimpv_hyper_1[5])
blkimpv_hyper(type_blkimpv_hyper_2[1], type_blkimpv_hyper_2[2], type_blkimpv_hyper_2[3], type_blkimpv_hyper_2[4], type_blkimpv_hyper_2[5])
blkimpv_hyper(type_blkimpv_hyper_3[1], type_blkimpv_hyper_3[2], type_blkimpv_hyper_3[3], type_blkimpv_hyper_3[4], type_blkimpv_hyper_3[5])

function blsimpv_hyper(num1, num2, num3, num4, num5, num6)
    @eval function blsimpv(S0::$num1, K::$num2, r::$num3, T::$num4, Price::$num5, d::$num6 = 0.0, FlagIsCall::Bool = true, xtol::Real = 1e-14, ytol::Real = 1e-15)
        if (Price < 0)
            throw(ErrorException("Option Price Cannot Be Negative"))
        end
        FinancialToolbox.blscheck(S0, K, r, T, 0.1, d)
        value__(x) = x.value
        value__(x::Real) = x
        f(x) = (blsprice(value__(S0), value__(K), value__(r), value__(T), x, value__(d), FlagIsCall) - value__(Price))
        σ = FinancialToolbox.brentMethod(f, 0.001, 1.2, xtol, ytol)
        out = hyper(0.0)
        if (!ishyper(Price))
            der_ = -(blsprice(S0, K, r, T, σ, d, FlagIsCall) / blsvega(value__(S0), value__(K), value__(r), value__(T), σ, value__(d), FlagIsCall)).epsilon1
            der_2 = ((blsprice(S0, K, r, T, σ, d, FlagIsCall).epsilon12 + blsvega(S0, K, r, T, σ, d, FlagIsCall).epsilon1 * der_) * blsvega(value__(S0), value__(K), value__(r), value__(T), σ, value__(d), FlagIsCall) - blsprice(S0, K, r, T, σ, d, FlagIsCall).epsilon1 * (blsvega(S0, K, r, T, σ, d, FlagIsCall).epsilon1 + blsvega(value__(S0), value__(K), value__(r), value__(T), hyper(σ, 1.0, 1.0, 0.0), value__(d), FlagIsCall).epsilon1 * der_)) / (blsvega(value__(S0), value__(K), value__(r), value__(T), σ, value__(d), FlagIsCall)^2)
            out = hyper(σ, der_, der_, -der_2)
        else
            der_ = 1 / blsvega(value__(S0), value__(K), value__(r), value__(T), σ, value__(d), FlagIsCall)
            der_2 = -(blsprice(S0, K, r, T, hyper(σ, 1.0, 1.0, 0.0), d, FlagIsCall).epsilon12) / (blsvega(value__(S0), value__(K), value__(r), value__(T), σ, value__(d), FlagIsCall)^3)
            out = hyper(σ, der_, der_, der_2)
        end

        return out
    end
end

type_blsimpv_hyper_1 = [Hyper, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}]
type_blsimpv_hyper_2 = [Real, Hyper, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}]
type_blsimpv_hyper_3 = [Real, Real, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}, Union{Real, Hyper}]
blsimpv_hyper(type_blsimpv_hyper_1[1], type_blsimpv_hyper_1[2], type_blsimpv_hyper_1[3], type_blsimpv_hyper_1[4], type_blsimpv_hyper_1[5], type_blsimpv_hyper_1[6])
blsimpv_hyper(type_blsimpv_hyper_2[1], type_blsimpv_hyper_2[2], type_blsimpv_hyper_2[3], type_blsimpv_hyper_2[4], type_blsimpv_hyper_2[5], type_blsimpv_hyper_2[6])
blsimpv_hyper(type_blsimpv_hyper_3[1], type_blsimpv_hyper_3[2], type_blsimpv_hyper_3[3], type_blsimpv_hyper_3[4], type_blsimpv_hyper_3[5], type_blsimpv_hyper_3[6])
