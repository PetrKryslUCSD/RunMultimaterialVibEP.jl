using Pkg; 
Pkg.activate("."); Pkg.instantiate()
using Revise
using FinEtoolsMultimaterialVibEP: solve_ep

# The name of the parameter file is up to you
parameterfile = "twoblocks.json"
# parameterfile = "Cyl_W_Hole.json"
solve_ep(parameterfile)

exit()