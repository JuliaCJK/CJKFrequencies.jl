push!(LOAD_PATH, "../src/")

using Documenter, CJKFrequencies

makedocs(
    sitename="CJKFrequencies.jl Documentation",
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true"
    ),
    modules=[CJKFrequencies],
    pages=[
        "Home" => "index.md",
        "API Reference" => "api_reference.md",
        "Developer Docs" => "devdocs.md"
    ]
)

deploydocs(
    repo = "github.com/tmthyln/CJKFrequencies.jl.git",
    devbranch = "main",
    devurl="latest"
    )
