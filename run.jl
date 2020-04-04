using Pkg; 
Pkg.activate("."); Pkg.instantiate()
using FinEtoolsMultimaterialVibEP: solve_ep

# The name of the parameter file is up to you
parameterfile = "twoblocks.json"
solve_ep(parameterfile)

exit()