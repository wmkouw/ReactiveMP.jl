module NormalMeanVarianceNodeTest

using Test
using ReactiveMP
using Random

import ReactiveMP: make_node

@testset "NormalMeanVarianceNode" begin
    @testset "Creation" begin
        node = make_node(NormalMeanVariance)

        @test functionalform(node) === NormalMeanVariance
        @test sdtype(node) === Stochastic()
        @test name.(interfaces(node)) === (:out, :μ, :v)
        @test factorisation(node) === ((1, 2, 3),)
        @test localmarginalnames(node) === (:out_μ_v,)
        @test metadata(node) === nothing

        node = make_node(NormalMeanVariance, FactorNodeCreationOptions(nothing, 1, nothing))

        @test functionalform(node) === NormalMeanVariance
        @test sdtype(node) === Stochastic()
        @test name.(interfaces(node)) === (:out, :μ, :v)
        @test factorisation(node) === ((1, 2, 3),)
        @test localmarginalnames(node) === (:out_μ_v,)
        @test metadata(node) === 1

        node = make_node(NormalMeanVariance, FactorNodeCreationOptions(((1,), (2, 3)), nothing, nothing))

        @test functionalform(node) === NormalMeanVariance
        @test sdtype(node) === Stochastic()
        @test name.(interfaces(node)) === (:out, :μ, :v)
        @test factorisation(node) === ((1,), (2, 3))
        @test localmarginalnames(node) === (:out, :μ_v)
        @test metadata(node) === nothing
    end

    @testset "AverageEnergy" begin
        begin
            q_out = PointMass(0.956629)
            q_μ   = NormalMeanVariance(0.255332, 0.762870)
            q_τ   = GammaShapeRate(0.93037, 0.79312)

            for N in (NormalMeanPrecision, NormalMeanVariance, NormalWeightedMeanPrecision),
                G in (GammaShapeRate, GammaShapeScale)

                marginals = (
                    Marginal(q_out, false, false),
                    Marginal(convert(N, q_μ), false, false),
                    Marginal(convert(G, q_τ), false, false)
                )
                @test score(AverageEnergy(), NormalMeanPrecision, Val{(:out, :μ, :τ)}, marginals, nothing) ≈
                      1.8879401707928936
            end
        end

        begin
            q_out = NormalMeanVariance(0.148725, 0.483501)
            q_μ   = NormalMeanVariance(0.992776, 0.545851)
            q_v   = GammaShapeRate(0.309396, 0.343814)

            for N in (NormalMeanPrecision, NormalMeanVariance, NormalWeightedMeanPrecision),
                G in (GammaShapeRate, GammaShapeScale)

                marginals = (
                    Marginal(q_out, false, false),
                    Marginal(convert(N, q_μ), false, false),
                    Marginal(convert(G, q_v), false, false)
                )
                @test score(AverageEnergy(), NormalMeanPrecision, Val{(:out, :μ, :τ)}, marginals, nothing) ≈
                      2.86416186172411
            end
        end

        begin
            q_out_μ = MvNormalMeanCovariance([0.2818402997601115, 0.0847764277628964], [0.7059042678955475 0.3595204552322394; 0.3595204552322394 0.22068491824258746])
            q_v     = GammaShapeRate(0.49074414, 0.4071772)

            for N in (MvNormalMeanPrecision, MvNormalMeanCovariance, MvNormalWeightedMeanPrecision),
                G in (GammaShapeRate, GammaShapeScale)

                marginals = (Marginal(convert(N, q_out_μ), false, false), Marginal(convert(G, q_v), false, false))
                @test score(AverageEnergy(), NormalMeanPrecision, Val{(:out_μ, :τ)}, marginals, nothing) ≈
                      1.6231194045861121
            end
        end

        begin
            q_out_μ = MvNormalMeanCovariance([0.8378350736808462, 0.41494396892699026], [1.0074451742986652 0.4369298270351709; 0.4369298270351709 0.19572138039218784])
            q_v     = GammaShapeRate(0.435485, 0.5269575)

            for N in (MvNormalMeanPrecision, MvNormalMeanCovariance, MvNormalWeightedMeanPrecision),
                G in (GammaShapeRate, GammaShapeScale)

                marginals = (Marginal(convert(N, q_out_μ), false, false), Marginal(convert(G, q_v), false, false))
                @test score(AverageEnergy(), NormalMeanPrecision, Val{(:out_μ, :τ)}, marginals, nothing) ≈
                      1.969539193740776
            end
        end
    end
end
end
