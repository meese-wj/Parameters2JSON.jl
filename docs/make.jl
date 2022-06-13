using Parameters2JSON
using Documenter

DocMeta.setdocmeta!(Parameters2JSON, :DocTestSetup, :(using Parameters2JSON); recursive=true)

makedocs(;
    modules=[Parameters2JSON],
    authors="W. Joe Meese <meese022@umn.edu> and contributors",
    repo="https://github.com/meese-wj/Parameters2JSON.jl/blob/{commit}{path}#{line}",
    sitename="Parameters2JSON.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/meese-wj/Parameters2JSON.jl",
)
