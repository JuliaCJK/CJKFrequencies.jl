# API Reference
A character frequency can be computed or loaded via the `charfreq` function, either from some text or a predefined corpus.
```@docs
charfreq
```

## Supported Predefined Character Frequency Datasets
A Chinese character frequency dataset's `struct`'s name will be prefixed with either `Traditional` or `Simplified` depending on whether it is based on a traditional or simplified text corpus.

```@docs
SimplifiedLCMC
SimplifiedJunDa
```

Other data sets are planned to be added. To add a data set to this API, see the [Developer Docs](@ref) page.
