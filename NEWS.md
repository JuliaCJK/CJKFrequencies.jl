# NEWS/CHANGELOG

## v0.3.0

- new character/word frequency datasets:
  - Huang-Tsai (traditional)
  - Leiden Weibo
  - other JunDa lists added
  - SUBTLEX-CH
- added `coverage` method for "mutual coverage" between 2 character frequencies
- new experimental `mutual_information` function
- `SimplifiedLCMC` constructor no longer requires uppercase characters
- fixed bug in `coverage` function with incorrectly ordered arguments
- new `entropy` function
- intersections and unions between character frequencies
- `copy` and `setindex!` functions on character frequencies
