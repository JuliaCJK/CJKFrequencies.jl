# Developer Docs

## Adding a new character/word frequency dataset

To add a new character frequency dataset using this API, a method just needs to be added to the `charfreq` function. It should have the signature

```julia
function charfreq(cf::CustomDataSetStruct)::CJKFrequency end
```

where the `CustomDataSetStruct` is any struct that you define for that particular character frequency data set. If needed, the constructor for the struct should take any arguments (e.g. see [`SimplifiedLCMC`](@ref) for an example with arguments).

The return value should have type [`CJKFrequency`](@ref).
