push!(LOAD_PATH, "../src/")

using Documenter, CJKFrequencies

makedocs(
    sitename="CJKFrequencies.jl Documentation",
    modules=[CJKFrequencies],
    pages=[
        "Home" => "index.md",
        "API Reference" => [
            "Frequency Lists" => "api/freqlist.md",
            "Lexicons" => "api/lexicon.md",
        ],
        "Developer Docs" => "devdocs.md",
    ],
)

if get(ENV, "CI", nothing) == "true"
    deploydocs(
        repo = "github.com/JuliaCJK/CJKFrequencies.jl.git",
        devbranch = "main",
        devurl="latest",
    )
end
