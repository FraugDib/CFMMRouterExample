#=
# Liquidating a basket of tokens
This example illustrates how to use CFMMRouter.jl to liquidate a basket of tokens.
=#
using CFMMRouter
using LinearAlgebra

## Create CFMMs
cfmms = [
    ProductTwoCoin([1e3, 1e4], 0.997, [1, 2]),
    ProductTwoCoin([1e3, 1e2], 0.997, [2, 3]),
    ProductTwoCoin([1e3, 2e4], 0.997, [1, 3])
]

## We want to liquidate a basket of tokens 2 & 3 into token 1
Δin = [0, 1e9, 0]

## Build a routing problem with liquidation objective
router = Router(
    BasketLiquidation(1, Δin),
    cfmms,
    maximum([maximum(cfmm.Ai) for cfmm in cfmms]),
)

## Optimize!
route!(router)

## Print results
Ψ = round.(Int, netflows(router))
println("Input Basket: $(round.(Int, Δin))")
println("Net trade: $Ψ")
println("Amount recieved: $(Ψ[1])")

