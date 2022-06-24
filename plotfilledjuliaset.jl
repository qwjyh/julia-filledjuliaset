#!usr/bin/env julia
using Plots
#plotlyjs() # too heavy for my env
gr()

c = -0.1 + 0.75im

xs = [0.005 * i for i in -300:300]
ys = [0.005 * i for i in -300:300]
xys = hcat([x for x in xs for y in ys], [y for x in xs for y in ys]);


# Array{Float64, 1} -> ComplexF64 -> Bool
function isFilledB(z::Array{Float64, 1}, c::ComplexF64)
  f(z::ComplexF64) = z^2 + c
  rec = z[1] + im*z[2]
  for i in 1:100
      rec = f(rec)
      if abs(rec) == Inf
          return false
      end
  end
  return true
end

# Array{Float64, 1} -> Bool
isInjuliaset(z::Array{Float64, 1}) = isFilledB(z, c)

juliaset = transpose(reduce(hcat, filter(isInjuliaset, Array.(eachrow(xys)))))

plot(
  juliaset[:, 1],
  juliaset[:, 2],
  seriestype = :scatter,
  markersize = 1,
  size = (400, 400),
  label = false,
  title = "c =" * string(c)
)
savefig("plots/filledjuliaset_c_" * string(c) * ".png")