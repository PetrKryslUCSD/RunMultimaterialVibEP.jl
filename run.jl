using Pkg; 
Pkg.activate("."); Pkg.instantiate()

using FinEtoolsMultimaterialVibEP: solve_ep

# The name of the parameter file is up to you
parameterfile = "Finned_81mm_Max_12kHz.json"

solve_ep(parameterfile)

# exit()
