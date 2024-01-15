# Frequency List API

A character (or word) frequency can be computed or loaded via the `charfreq` function, 
either from some text or a predefined corpus.

```@docs
charfreq
```

## Supported Predefined Character Frequency Datasets

A Chinese character frequency dataset's `struct`'s name will be prefixed with either `Traditional` or `Simplified` depending on whether it is based on a traditional or simplified text corpus.

```@docs
SimplifiedLCMC
SimplifiedJunDa
TraditionalHuangTsai
SimplifiedLeidenWeibo
SimplifiedSUBTLEX
```

Other data sets are planned to be added. To add a data set to this API, see the [Developer Docs](@ref) page.

## Frequency List Type

```@docs
CJKFrequency
```

Common operations on `CJKFrequency`:

- `DataStructures.inc!`
- `DataStructures.dec!`
- `DataStructures.reset!`
- and most typical "iterable" or "indexable" functions.

Both `length` and `size` are defined: the length of a frequency list is the number of terms in the frequency list, whereas the size is the total count of all tokens.

```@docs
CJKFrequencies.entropy
```
