# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.2
function wood_model(N = 10; T = Float64, backend = CUDABackend(), kwargs...)
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 2) == 1 ? -2 : 0 for i = 1:N))

    # Define the constraints
    con = ExaModels.constraint(
        c,
        (2 + 5 * x[k+5]^2) * x[k+5] + 1 for k in 1:N-7
    )
    ExaModels.constraint!(
        c,
        con,
        i => x[i] * (1 + x[i]) + x[i+1] * (1 + x[i+1]) for i in 1:N-7
    )
    ExaModels.objective(c, (100 * (x[2*i-1]^2 - x[2*i])^2 + (x[2*i-1] - 1)^2 +
    90 * (x[2*i+1]^2 - x[2*i+2])^2 + (x[2*i+1] - 1)^2 +
    10 * (x[2*i] + x[2*i+2] - 2)^2 + ((x[2*i] - x[2*i+2])^2 / 10)) for i = 1:N ÷ 2 -1)
    
    return ExaModels.ExaModel(c)
end