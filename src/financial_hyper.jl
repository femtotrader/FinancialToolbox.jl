using .HyperDualNumbers

macro blkimpv_hyper(num1,num2,num3,num4,num5)
	@eval function blkimpv(S0::$num1,K::$num2,r::$num3,T::$num4,Price::$num5,FlagIsCall::Bool=true,xtol::Real=1e-14,ytol::Real=1e-15)

		blscheck(S0,K,r,T,0.1,r);

		return blsimpv(S0,K,r,T,Price,r,FlagIsCall);

	end
end

type_blkimpv_hyper_=[Dual,Union{Real,Dual},Union{Real,Dual},Union{Real,Dual},Union{Real,Dual}]
type_blkimpv_hyper=copy(type_blkimpv_hyper_)
for i=1:5
	type_blkimpv_hyper=circshift(type_blkimpv_hyper_,i-1)
	@blkimpv_hyper(type_blkimpv_hyper[1],type_blkimpv_hyper[2],type_blkimpv_hyper[3],type_blkimpv_hyper[4],type_blkimpv_hyper[5])
end

macro blsimpv_hyper(num1,num2,num3,num4,num5,num6)
	@eval function blsimpv(S0::$num1,K::$num2,r::$num3,T::$num4,Price::$num5,d::$num6=0.0,FlagIsCall::Bool=true,xtol::Real=1e-14,ytol::Real=1e-15)
	if (Price< $num5(0))
		throw(ErrorException("Option Price Cannot Be Negative"));
	end
	FinancialToolbox.blscheck(S0,K,r,T,0.1,d);
	value__(x)=x.value;
	value__(x::Real)=x;
	f(x)=(blsprice(value__(S0),value__(K),value__(r),value__(T),x,value__(d),FlagIsCall)-value__(Price));
	σ=FinancialToolbox.brentMethod(f,0.001,1.2,xtol,ytol);
	der_=-(blsprice(S0,K,r,T,σ,d,FlagIsCall)/blsvega(value__(S0),value__(K),value__(r),value__(T),σ,value__(d),FlagIsCall)).epsilon
	der_2=-(blsprice(S0,K,r,T,σ,d,FlagIsCall)/blsvega(value__(S0),value__(K),value__(r),value__(T),σ,value__(d),FlagIsCall)).epsilon
	out=hyper(σ,der_,der_,der_2);

	return out;

	end
end

type_blsimpv_hyper_=[Dual,Union{Real,Dual},Union{Real,Dual},Union{Real,Dual},Union{Real,Dual},Union{Real,Dual}]
type_blsimpv_hyper=copy(type_blsimpv_hyper_)
for i=1:6
	type_blsimpv_hyper=circshift(type_blsimpv_hyper_,i-1)
	@blsimpv_hyper(type_blsimpv_hyper[1],type_blsimpv_hyper[2],type_blsimpv_hyper[3],type_blsimpv_hyper[4],type_blsimpv_hyper[5],type_blsimpv_hyper[6])
end
