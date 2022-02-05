using Pkg; 
Pkg.activate("."); Pkg.instantiate()
using Revise
using JSON
using MAT
using LinearAlgebra
using UnicodePlots
using Gnuplot; @gp "clear"
using FinEtools
using FinEtoolsMultimaterialVibEP: solve_ep
using FinEtools.MeshExportModule.VTKWrite: vtkwrite

# The name of the parameter file is up to you
parameterfile = "Cyl_W_Hole.json"
# parameterfile = "twoblocks.json"
parameters = open(parameterfile, "r") do file
    JSON.parse(file)
end

meshfilebase, ext = splitext(parameters["meshfile"])
file = matopen(meshfilebase * ".mat", "r")
Omega = read(file, "Omega")
E = read(file, "E")
X = read(file, "X")
conn = read(file, "conn")
G = read(file, "G")
areas = read(file, "areas")
close(file)

fens = FENodeSet(X)
fes = FESetT3(Int.(conn))
# mode = 7
# scattersysvec!(u, v[:,mode])
File =  meshfilebase * ".vtu"
vtkwrite(File, fens, fes)
# vtkwrite(File, fens, allfes; vectors=[("mode$mode", u.values)])
