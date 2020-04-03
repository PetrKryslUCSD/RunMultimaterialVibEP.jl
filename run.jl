using Pkg; 
Pkg.activate("."); Pkg.instantiate()
pkg"add https://github.com/PetrKryslUCSD/Comsol2FinEtoolsModel.jl.git"
Pkg.activate("Comsol2FinEtoolsModel"); Pkg.instantiate()
using Comsol2FinEtoolsModel: solve_ep

# The name of the parameter file is up to you
parameterfile = "twoblocks.json"
solve_ep(parameterfile)

exit()