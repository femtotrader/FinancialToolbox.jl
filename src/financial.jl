"""
Cumulative Distribution Function of a Standard Gaussian Random Variable

		y=normcdf(x)

Where:\n
		x         = point of evaluation.

		y      = probability that a standard gaussian random variable is below x.

# Example
```julia-repl
julia> normcdf(0.0)
0.5
```
"""
function normcdf(x::number) where {number <: Number}
    return (1.0 + erf(x / sqrt(2.0))) / 2.0
end

"""
Probability Distribution Function of a Standard Gaussian Random Variable

		y=normpdf(x)

Where:\n
		x         = point of evaluation.

		y      = value.

# Example
```julia-repl
julia> normpdf(0.0)
0.3989422804014327
```
"""
function normpdf(x::number) where {number <: Number}
    return exp(-0.5 * x .^ 2) / sqrt(2 * pi)
end

"""
Black & Scholes Price for European Options

		Price=blsprice(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Price      = price of the European Option.

# Example
```julia-repl
julia> blsprice(10.0,10.0,0.01,2.0,0.2,0.01)
1.1023600107733191
```
"""
function blsprice(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    d2 = d1 - σ * sqrt(T)
    N_d1 = normcdf(d1)
    N_d2 = normcdf(d2)
    Price = 0.0
    if FlagIsCall
        Price = S0 * exp(-d * T) * N_d1 - K * exp(-r * T) * N_d2
    else
        Price = K * exp(-r * T) * (1 - N_d2) - S0 * exp(-d * T) * (1 - N_d1)
    end
    return Price
end

"""
Black Price for European Options

		Price=blkprice(F0,K,r,T,σ,FlagIsCall=true)

Where:\n
		F0         = Value of the Forward.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility.
		FlagIsCall = true for Call Options, false for Put Options.

		Price      = price of the European Option.

# Example
```julia-repl
julia> blkprice(10.0,10.0,0.01,2.0,0.2)
1.1023600107733191
```
"""
function blkprice(F0::num1, K::num2, r::num3, T::num4, σ::num5, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number}
    blscheck(F0, K, r, T, σ)
    Price = blsprice(F0, K, r, T, σ, r, FlagIsCall)
    return Price
end

"""
Black Price for Binary European Options

		Price=blsbin(S0,K,r,T,σ,FlagIsCall=true)

Where:\n
		F0         = Value of the Forward.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility.
		FlagIsCall = true for Call Options, false for Put Options.

		Price      = price of the Binary European Option.

# Example
```julia-repl
julia> blsbin(10.0,10.0,0.01,2.0,0.2)
0.4624714677292208
```
"""
function blsbin(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
	blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    d2 = d1 - σ * sqrt(T)
    FlagIsCall ? (return(exp(-r * T) * FinancialToolbox.normcdf(d2));) : (return(exp(-r * T)*(1.0- FinancialToolbox.normcdf(d2))));
end

"""
Black & Scholes Delta for European Options

		Δ=blsdelta(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Δ          = delta of the European Option.

# Example
```julia-repl
julia> blsdelta(10.0,10.0,0.01,2.0,0.2,0.01)
0.5452173371920436
```
"""
function blsdelta(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    Δ = 0.0
    if FlagIsCall
        Δ = exp(-d * T) * normcdf(d1)
    else
        Δ = -exp(-d * T) * normcdf(-d1)
    end
    return Δ
end

"""
Black & Scholes Gamma for European Options

		Γ=blsgamma(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Γ          = gamma of the European Option.

# Example
```julia-repl
julia> blsgamma(10.0,10.0,0.01,2.0,0.2,0.01)
0.13687881535712826
```
"""
function blsgamma(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    Γ = exp(-d * T) * normpdf(d1) / (S0 * σ * sqrt(T))
    return Γ
end

"""
Black & Scholes Vega for European Options

		ν=blsvega(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		ν          = vega of the European Option.

# Example
```julia-repl
julia> blsvega(10.0,10.0,0.01,2.0,0.2,0.01)
5.475152614285131
```
"""
function blsvega(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    ν = S0 * exp(-d * T) * normpdf(d1) * sqrt(T)
    return ν
end

"""
Black & Scholes Rho for European Options

		ρ=blsrho(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		ρ          = rho of the European Option.

# Example
```julia-repl
julia> blsrho(10.0,10.0,0.01,2.0,0.2,0.01)
8.699626722294234
```
"""
function blsrho(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d2 = (log(S0 / K) + (r - d - σ * σ * 0.5) * T) / (σ * sqrt(T))
    if FlagIsCall
        ρ = K * exp(-r * T) * normcdf(d2) * T
    else
        ρ = -K * exp(-r * T) * normcdf(-d2) * T
    end
    return ρ
end

"""
Black & Scholes Theta for European Options

		Θ=blstheta(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Θ          = theta of the European Option.

# Example
```julia-repl
julia> blstheta(10.0,10.0,0.01,2.0,0.2,0.01)
-0.26273403060652334
```
"""
function blstheta(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    sqrtT = sqrt(T)
    σ_sqrtT = σ * sqrtT

    d1 = (log(S0 / K) + (r - d + σ .^ 2 / 2) * T) / σ_sqrtT

    shift = -exp(-d * T) * S0 * normpdf(d1) * σ / 2 / sqrtT
    t1 = r * K * exp(-r * T)
    t2 = d * S0 * exp(-d * T)
    Θ = 0.0
    if FlagIsCall
        Θ = shift - t1 * normcdf(d1 - σ_sqrtT) + t2 * normcdf(d1)
    else
        Θ = shift + t1 * (1 - normcdf(d1 - σ_sqrtT)) + t2 * (normcdf(d1) - 1)
    end
    return Θ
end

"""
Black & Scholes Lambda for European Options

		Λ=blslambda(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Λ          = lambda of the European Option.

# Example
```julia-repl
julia> blslambda(10.0,10.0,0.01,2.0,0.2,0.01)
4.945909973725978
```
"""
function blslambda(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    Price = blsprice(S0, K, r, T, σ, d, FlagIsCall)
    Δ = blsdelta(S0, K, r, T, σ, d, FlagIsCall)
    Λ = Δ * S0 / Price
    return Λ
end

"Check input for Black Scholes Formula"
function blscheck(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    lesseq(x::Complex, y::Complex) = real(x) <= real(y)
    lesseq(x, y) = x <= y
    if (lesseq(S0, zero(num1)))
        error("Spot Price Cannot Be Negative")
    elseif (lesseq(K, zero(num2)))
        error("Strike Price Cannot Be Negative")
    elseif (lesseq(T, zero(num4)))
        error("Time to Maturity Cannot Be Negative")
    elseif (lesseq(σ, zero(num5)))
        error("Volatility Cannot Be Negative")
    end
    return
end

"Brent Method: Scalar Equation Solver"
function brentMethod(f::Function, x0::Number, x1::Number, xtol::AbstractFloat = 1e-14, ytol::AbstractFloat = 1e-15)
    if xtol < 0.0
        throw(ErrorException("x tollerance cannot be negative"))
    end
    if ytol < 0.0
        throw(ErrorException("y tollerance cannot be negative"))
    end
    EPS = eps(x0)
    maxiter = 80
    y0 = f(x0)
    y1 = f(x1)
    if (y0 * y1 > 0)
        throw(DomainError("There is no such volatility"))
    end
    if abs(y0) < abs(y1)
        # Swap lower and upper bounds.
        x0, x1 = x1, x0
        y0, y1 = y1, y0
    end
    x2 = x0
    y2 = y0
    x3 = x2
    bisection = true
    for _ = 1:maxiter
        # x-tolerance.
        if abs(x1 - x0) < xtol
            return x1
        end

        # Use inverse quadratic interpolation if f(x0)!=f(x1)!=f(x2)
        # and linear interpolation (secant method) otherwise.
        if abs(y0 - y2) > ytol && abs(y1 - y2) > ytol
            x = x0 * y1 * y2 / ((y0 - y1) * (y0 - y2)) + x1 * y0 * y2 / ((y1 - y0) * (y1 - y2)) + x2 * y0 * y1 / ((y2 - y0) * (y2 - y1))
        else
            x = x1 - y1 * (x1 - x0) / (y1 - y0)
        end

        # Use bisection method if satisfies the conditions.
        delta = abs(2EPS * abs(x1))
        min1 = abs(x - x1)
        min2 = abs(x1 - x2)
        min3 = abs(x2 - x3)
        if (x < (3x0 + x1) / 4 && x > x1) || (bisection && min1 >= min2 / 2) || (!bisection && min1 >= min3 / 2) || (bisection && min2 < delta) || (!bisection && min3 < delta)
            x = (x0 + x1) / 2
            bisection = true
        else
            bisection = false
        end
        y = f(x)
        if abs(x - x0) < xtol
            return x
        end
        x3 = x2
        x2 = x1
        if sign(y0) != sign(y)
            x1 = x
            y1 = y
        else
            x0 = x
            y0 = y
        end
        if abs(y0) < abs(y1)
            # Swap lower and upper bounds.
            x0, x1 = x1, x0
            y0, y1 = y1, y0
        end
    end
    throw(ErrorException("Max iteration exceeded, possible wrong result"))
end

function blsimpv_impl(zero_typed::AbstractFloat,S0, K, r, T, price_d,d,FlagIsCall,xtol, ytol)
    f(x) = blsprice(S0, K, r, T, x, d, FlagIsCall) - price_d
    σ = brentMethod(f, 0.001, 1.2, xtol, ytol)
    return σ
end

export blsimpv
"""
Black & Scholes Implied Volatility for European Options

		σ=blsimpv(S0,K,r,T,Price,d=0.0,FlagIsCall=true,xtol=1e-14,ytol=1e-15)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		Price      = Price of the Option.
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		σ          = implied volatility of the European Option.

# Example
```julia-repl
julia> blsimpv(10.0,10.0,0.01,2.0,2.0)
0.3433730534290586
```
"""
function blsimpv(S0::num1, K::num2, r::num3, T::num4, Price::num5, d::num6 = 0.0, FlagIsCall::Bool = true, xtol::Real = 1e-14, ytol::Real = 1e-15) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    if (Price < num5(0))
        throw(ErrorException("Option Price Cannot Be Negative"))
    end
    blscheck(S0, K, r, T, 0.1, d)
	zero_typed=0*S0*K*r*T*d*Price
	σ = blsimpv_impl(zero_typed,S0, K, r, T, Price,d,FlagIsCall,xtol, ytol)
	return σ
end

export blkimpv
"""
Black Implied Volatility for European Options

		σ=blkimpv(F0,K,r,T,Price,FlagIsCall=true,xtol=1e-14,ytol=1e-15)

Where:\n
		F0         = Value of the Forward.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		Price      = Price of the Option.
		FlagIsCall = true for Call Options, false for Put Options.

		σ          = implied volatility of the European Option.

# Example
```julia-repl
julia> blkimpv(10.0,10.0,0.01,2.0,2.0)
0.36568658096623635
```
"""
function blkimpv(F0::num1, K::num2, r::num3, T::num4, Price::num5, FlagIsCall::Bool = true, xtol::Real = 1e-14, ytol::Real = 1e-15) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number}
    blscheck(F0, K, r, T, 0.1)
    σ = blsimpv(F0, K, r, T, Price, r, FlagIsCall, xtol, ytol)
    return σ
end

##	ADDITIONAL Function

"""
Black & Scholes Psi for European Options

		Ψ=blspsi(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Ψ          = psi of the European Option.

# Example
```julia-repl
julia> blspsi(10.0,10.0,0.01,2.0,0.2,0.01)
-10.904346743840872
```
"""
function blspsi(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    if FlagIsCall
        Ψ = -S0 * exp(-d * T) * normcdf(d1) * T
    else
        Ψ = S0 * exp(-d * T) * normcdf(-d1) * T
    end
    return Ψ
end

"""
Black & Scholes Vanna for European Options

		Vanna=blsvanna(S0,K,r,T,σ,d=0.0,FlagIsCall=true)

Where:\n
		S0         = Value of the Underlying.
		K          = Strike Price of the Option.
		r          = Zero Rate.
		T          = Time to Maturity of the Option.
		σ          = Implied Volatility
		d          = Implied Dividend of the Underlying.
		FlagIsCall = true for Call Options, false for Put Options.

		Vanna        = vanna of the European Option.

# Example
```julia-repl
julia> blsvanna(10.0,10.0,0.01,2.0,0.2,0.01)
0.2737576307142566
```
"""
function blsvanna(S0::num1, K::num2, r::num3, T::num4, σ::num5, d::num6 = 0.0, FlagIsCall::Bool = true) where {num1 <: Number, num2 <: Number, num3 <: Number, num4 <: Number, num5 <: Number, num6 <: Number}
    blscheck(S0, K, r, T, σ, d)
    d1 = (log(S0 / K) + (r - d + σ * σ * 0.5) * T) / (σ * sqrt(T))
    d2 = d1 - σ * sqrt(T)
    Vanna = -exp(-d * T) * normpdf(d1) * d2 / σ
    return Vanna
end
