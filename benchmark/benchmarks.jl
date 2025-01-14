using BenchmarkTools
using Random
using ReactiveMP

import Pkg;

# Pkg.resolve()
Pkg.instantiate()
Pkg.status()

# Define a parent BenchmarkGroup to contain our suite
const SUITE = BenchmarkGroup()

SUITE["models"] = BenchmarkGroup([ "models", "ssm", "graphppl" ])

# Simple Linear Gaussian State Space Model Benchmarks 
# ------------------------------------------------------------ #
include("models/lgssm1.jl")

SUITE["models"]["lgssm1"] = BenchmarkGroup([ "linear", "gaussian", "ssm", "univariate" ])

for lgssm1_size in [ 100, 500 ]
    # Model creation benchmark
    SUITE["models"]["lgssm1"]["creation_$lgssm1_size"]  = @benchmarkable LGSSM1Benchmark.lgssm($lgssm1_size)
    # Inference benchmark
    SUITE["models"]["lgssm1"]["inference_$lgssm1_size"] = @benchmarkable LGSSM1Benchmark.benchmark(input) setup=(input=LGSSM1Benchmark.generate_input(MersenneTwister(1234), $lgssm1_size))
end
# ------------------------------------------------------------ #

# Multivariate Linear Gaussian State Space Model Benchmarks 
# ------------------------------------------------------------ #
include("models/lgssm2.jl")

SUITE["models"]["lgssm2"] = BenchmarkGroup([ "linear", "gaussian", "ssm", "multivariate" ])

for lgssm2_size in [ 100, 500 ]
    # Model creation benchmark
    SUITE["models"]["lgssm2"]["creation_$lgssm2_size"]  = @benchmarkable LGSSM2Benchmark.lgssm($lgssm2_size)
    # Inference benchmark
    SUITE["models"]["lgssm2"]["inference_$lgssm2_size"] = @benchmarkable LGSSM2Benchmark.benchmark(input) setup=(input=LGSSM2Benchmark.generate_input(MersenneTwister(1234), $lgssm2_size))
end
# ------------------------------------------------------------ #

# Hierarchical Gaussian Filter Model Benchmarks 
# ------------------------------------------------------------ #
include("models/hgf1.jl")

SUITE["models"]["hgf1"] = BenchmarkGroup([ "hierarchical", "gaussian", "ssm", "univariate" ])

SUITE["models"]["hgf1"]["creation"]  = @benchmarkable HGF1Benchmark.hgf()

for hgf1_size in [ 100, 500, 1000 ]
    # Inference benchmark
    SUITE["models"]["hgf1"]["inference_$hgf1_size"] = @benchmarkable HGF1Benchmark.benchmark(input) setup=(input=HGF1Benchmark.generate_input(MersenneTwister(1234), $hgf1_size))
end
# ------------------------------------------------------------ #

# Hidden Markov Model Benchmarks 
# ------------------------------------------------------------ #
include("models/hmm1.jl")

SUITE["models"]["hmm1"] = BenchmarkGroup([ "hmm", "ssm", "discrete" ])


for hmm1_size in [ 100, 500 ]
    # Creation Benchmark
    SUITE["models"]["hmm1"]["creation_$hmm1_size"]  = @benchmarkable HMM1Benchmark.hmm($hmm1_size)
    # Inference benchmark
    SUITE["models"]["hmm1"]["inference_$hmm1_size"] = @benchmarkable HMM1Benchmark.benchmark(input) setup=(input=HMM1Benchmark.generate_input(MersenneTwister(1234), $hmm1_size))
end
# ------------------------------------------------------------ #

BenchmarkTools.warmup(SUITE)