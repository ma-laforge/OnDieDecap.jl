using ConventionalApp

proj = Project(@__DIR__)
setup_env(proj)
@include_startup(proj)

#show(activeproject)

using Revise
using OnDieDecap
#Main.include("src/OnDieDecap.jl")
#Main.OnDieDecap.run_app()
