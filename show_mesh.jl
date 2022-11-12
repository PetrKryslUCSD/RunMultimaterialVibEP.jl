using Pkg; 
Pkg.activate("."); Pkg.instantiate()
using Revise
using JSON
using MAT
using LinearAlgebra
using UnicodePlots
# using Gnuplot; @gp "clear"
using FinEtools
using DataDrop: with_extension
using FinEtools.MeshImportModule
using FinEtoolsMultimaterialVibEP: solve_ep
using FinEtools.MeshExportModule.VTKWrite: vtkwrite

# The name of the parameter file is up to you
parameterfile = "Heat_105.json"
# parameterfile = "twoblocks.json"
parameters = open(parameterfile, "r") do file
    JSON.parse(file)
end

meshfilebase, ext = splitext(parameters["meshfile"])
output = MeshImportModule.import_NASTRAN(with_extension(meshfilebase, ext))
fens = output["fens"]
@info "$(count(fens)) nodes"
@info "$(length(output["fesets"])) materials"
for i in axes(output["fesets"], 1)
    fes = output["fesets"][i]
    File =  meshfilebase * "-part-$i.vtu"
    vtkwrite(File, fens, fes)
end

allfes = output["fesets"][1]
for i in 2:length(output["fesets"])
    fes = output["fesets"][i]
    global allfes = cat(allfes, fes)
end

bfes = meshboundary(allfes)
File =  meshfilebase * "-boundary.vtu"
vtkwrite(File, fens, bfes)

obfes = outer_surface_of_solid(fens, bfes)
File =  meshfilebase * "-outer-boundary.vtu"
vtkwrite(File, fens, obfes)

# mode = 7
# scattersysvec!(u, v[:,mode])
# File =  meshfilebase * ".vtu"
# vtkwrite(File, fens, fes)
# vtkwrite(File, fens, allfes; vectors=[("mode$mode", u.values)])
