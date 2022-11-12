using Pkg; 
Pkg.activate("."); Pkg.instantiate()
using Revise
using JSON
using MAT
using LinearAlgebra
using UnicodePlots
# using Gnuplot; @gp "clear"
using FinEtools
using FinEtoolsMultimaterialVibEP: solve_ep
using FinEtools.MeshExportModule.VTKWrite: vtkwrite
using DataDrop

# The name of the parameter file is up to you
parameterfile = "Heat_105.json"
mode = 11

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

f = DataDrop.with_extension(DataDrop.clean_file_name(meshfilebase * "-model"), ".h5")
xyz = DataDrop.retrieve_matrix(f, "/xyz") 
fens = FENodeSet(xyz)
conn = DataDrop.retrieve_matrix(f, "/conn") 
fes = FESetT4(Int.(conn))
u = NodalField(zeros(size(fens.xyz,1),3)) 
u.dofnums = DataDrop.retrieve_matrix(f, "/dofnums") 
u.nfreedofs = maximum(u.dofnums)

scattersysvec!(u, E[:, mode])
@show norm(u.values)
File =  meshfilebase * "-mode-$(mode).vtu"
# vtkwrite(File, fens, fes)
vtkwrite(File, fens, fes; vectors=[("mode$mode", u.values)])

nothing