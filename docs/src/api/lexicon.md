# Lexicon API

## Lexicons

```@docs
Lexicon
tagged_with
```

## Coverage and Mutual Information

**"Coverage"** is a family of statistics about the overlap between
- character frequencies,
- lexicons, and
- text (as represented as its character frequency).

```@docs
CJKFrequencies.coverage
```

[**Mutual information**](https://en.wikipedia.org/wiki/Mutual_information) 
is a more rigorously defined concept from information theory.
In this context, some possible interpretations are

- "the amount of text you can understand from knowing a set of characters"
- "the amount of one text you can read if you can read this other text"

```@docs
CJKFrequencies.mutual_information
```


Differences between coverage and mutual information metrics:
- Coverage is asymmetric as the intersection is normalized over the second argument;
  mutual information is symmetric.
- Coverage considers counts of shared tokens or types;
  mutual information considers (entropy of) shared tokens only.
- Due to its grounding in information theory, mutual information also includes a log factor.

A middle ground between mutual information and coverage is a symmetric "intersection-over-union" coverage:

```@example infothe
using CJKFrequencies # hide
using CJKFrequencies: coverage, mutual_information # hide

set1 = CJKFrequency("a" => 5, "b" => 11, "c" => 3)
set2 = CJKFrequency("b" => 2, "c" => 4, "d" => 4)

size(set1 ∩ set2) / size(set1 ∪ set2)
```

```@example infothe
coverage(set1, set2)
```

```@example infothe
mutual_information(set1, set2)
```
