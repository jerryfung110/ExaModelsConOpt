# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.12
# The index in nC would be out of range for the constraints. Threfore, the last constraint is not implemented. The number of constraints fulfilled the question. 
function Chained_HS47_model(N = 1000; T = Float64, backend=nothing, kwargs ...)
    nC = (3 * (N-1) ÷ 4)
    It_L1 = [4*div(i-1, 3) for i in 1:3:nC-3]
    It_L2 = [4*div(i-1, 3) for i in 2:3:nC-3]
    It_L3 = [4*div(i-1, 3) for i in 3:3:nC-3]
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 4) == 1 ? 2.0 : mod(i, 4) == 2 ? 1.5 : mod(i, 4) == 3 ? -1.0 : 0.5 for i = 1:N))
    ExaModels.constraint(
        c,
        x[l+1] + x[l+2]^2 + x[l+3]^2 - 3 for l in It_L1
    )

    ExaModels.constraint(
        c,
        x[l+2] + x[l+3]^2 + x[l+4] -1 for l in It_L2
    )

    ExaModels.constraint(
        c,
        x[l+1] * x[l+5] -1 for l in It_L3
    )

    ExaModels.objective(c, (x[4(i-1)+1] - x[4(i-1)+2])^2 + (x[4(i-1)+2] - x[4(i-1)+3])^2 + (x[4(i-1)+3] - x[4(i-1)+4])^2 + (x[4(i-1)+4] - x[4(i-1)+5])^2 for i in 1:floor(Int, (N-1)/4))
    
    
    return ExaModels.ExaModel(c)
end

