var documenterSearchIndex = {"docs":
[{"location":"api/lexicon/#Lexicon-API","page":"Lexicons","title":"Lexicon API","text":"","category":"section"},{"location":"api/lexicon/#Lexicons","page":"Lexicons","title":"Lexicons","text":"","category":"section"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"Lexicon\ntagged_with","category":"page"},{"location":"api/lexicon/#CJKFrequencies.Lexicon","page":"Lexicons","title":"CJKFrequencies.Lexicon","text":"Lexicon()\nLexicon(io_or_filename)\nLexicon(words)\n\nConstruct a lexicon. It can be empty (no parameters) or created from some IO-like object or a sequence/iterable of words.\n\nA lexicon is a list of (known) words, each of which can be tagged with various tags (e.g. indicating how it is known, etc.).\n\n\n\n\n\n","category":"type"},{"location":"api/lexicon/#CJKFrequencies.tagged_with","page":"Lexicons","title":"CJKFrequencies.tagged_with","text":"tagged_with(lexicon, tag)\n\nThe set of words or characters in a lexicon tagged with tag.\n\n\n\n\n\n","category":"function"},{"location":"api/lexicon/#Coverage-and-Mutual-Information","page":"Lexicons","title":"Coverage and Mutual Information","text":"","category":"section"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"\"Coverage\" is a family of statistics about the overlap between","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"character frequencies,\nlexicons, and\ntext (as represented as its character frequency).","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"CJKFrequencies.coverage","category":"page"},{"location":"api/lexicon/#CJKFrequencies.coverage","page":"Lexicons","title":"CJKFrequencies.coverage","text":"coverage([filter,] coverer, covered)\n\nCompute an \"intersection-over-latter\" coverage metric.\n\nThe coverage of a lexicon of known words over a character frequency list is  the ratio of tokens or types in the frequency list which are also present in the lexicon. There are two varieties:\n\ntoken coverage counts each token separately (considering repeated characters)\ntype coverage counts each unique token once\n\nSuppose the lexicon contains all the words you know  and the frequency list represents words extracted from a text you wish to read. The token coverage represents how much of the text you are expected to know (by character), and the type coverage represents how much of the vocabulary you are. The lower the coverage, the higher the \"switching cost\" in terms of vocabulary.\n\nCoverage can be computed between \n\nlexicon over a frequency list\nlexicon over text (represented as a frequency list)\nfrequency list over another frequency list\n\nby both tokens and types.\n\nParameters\n\nThe first parameter must be a covering type, i.e. one of Accumulator, CJKFrequency, or Lexicon. The second parameter must be a coverable type, i.e. either Accumulator or CJKFrequency. Anything else must be convertible to CJKFrequency via the charfreq function.\n\nIf three arguments are provided, the first argument acts as a context filter. This must be a covering type. For example, if the arguments are a lexicon, frequency list, and some text (in that order), the coverage of the frequency list over the text will be computed, ignoring any characters in the text that do not appear in the lexicon.\n\nExamples\n\n\n\n\n\n","category":"function"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"Mutual information  is a more rigorously defined concept from information theory. In this context, some possible interpretations are","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"\"the amount of text you can understand from knowing a set of characters\"\n\"the amount of one text you can read if you can read this other text\"","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"CJKFrequencies.mutual_information","category":"page"},{"location":"api/lexicon/#CJKFrequencies.mutual_information","page":"Lexicons","title":"CJKFrequencies.mutual_information","text":"mutual_information(charfreq1, charfreq2)\n\nCompute the mutual information between two frequency lists.\n\nwarning: Subject to refinement\nBecause there's not a good source of information for the joint PMF, this function currently approximates it using the average of the two marginal PMFs.\n\n\n\n\n\n","category":"function"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"Differences between coverage and mutual information metrics:","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"Coverage is asymmetric as the intersection is normalized over the second argument; mutual information is symmetric.\nCoverage considers counts of shared tokens or types; mutual information considers (entropy of) shared tokens only.\nDue to its grounding in information theory, mutual information also includes a log factor.","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"A middle ground between mutual information and coverage is a symmetric \"intersection-over-union\" coverage:","category":"page"},{"location":"api/lexicon/","page":"Lexicons","title":"Lexicons","text":"using CJKFrequencies # hide\n\nset1 = CJKFrequency(\"a\" => 5, \"b\" => 11, \"c\" => 3)\nset2 = CJKFrequency(\"b\" => 2, \"c\" => 4, \"d\" => 4)\n\nsize(set1 ∩ set2) / size(set1 ∪ set2)","category":"page"},{"location":"api/freqlist/#Frequency-List-API","page":"Frequency Lists","title":"Frequency List API","text":"","category":"section"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"A character (or word) frequency can be computed or loaded via the charfreq function,  either from some text or a predefined corpus.","category":"page"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"charfreq","category":"page"},{"location":"api/freqlist/#CJKFrequencies.charfreq","page":"Frequency Lists","title":"CJKFrequencies.charfreq","text":"charfreq(text)\ncharfreq(charfreq_type)\n\nCreate a character frequency mapping from either text or load it from a default location for pre-specified character frequency datasets (e.g. SimplifiedLCMC, SimplifiedJunDa, etc.).\n\nExamples\n\nWhen creating a character frequency from text, this method behaves almost exactly like DataStructures.counter except that the return value always has type CharacterFrequency (Accumulator{String, Int}).\n\njulia> text = split(\"王老师性格内向，沉默寡言，我除在课外活动小组“文学研究会”听过他一次报告，并听-邓知识渊博，是“老师的老师”外，对他一无所知。所以，研读他的作\", \"\");\n\njulia> charfreq(text)\nCJKFrequency{SubString{String}, Int64}(Accumulator(除 => 1, 报 => 1, 是 => 1, 知 => 2, 并 => 1, 性 => 1, ， => 6, 言 => 1, 邓 => 1, 外 => 2, 所 => 2, 对 => 1, 动 => 1, 寡 => 1, 。 => 1, 渊 => 1, 学 => 1, - => 1, 听 => 2, 我 => 1, 次 => 1, 一 => 2, 读 => 1, 作 => 1, 格 => 1, “ => 2, 博 => 1, 课 => 1, 老 => 3, 会 => 1, 告 => 1, 无 => 1, 活 => 1, 组 => 1, 内 => 1, 师 => 3, 的 => 2, 小 => 1, 文 => 1, 默 => 1, 究 => 1, 过 => 1, 在 => 1, 以 => 1, ” => 2, 研 => 2, 他 => 3, 向 => 1, 沉 => 1, 王 => 1), Base.RefValue{Int64}(71))\n\nSee the documentation for individual character frequency dataset structs for examples of the second case.\n\n\n\n\n\n","category":"function"},{"location":"api/freqlist/#Supported-Predefined-Character-Frequency-Datasets","page":"Frequency Lists","title":"Supported Predefined Character Frequency Datasets","text":"","category":"section"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"A Chinese character frequency dataset's struct's name will be prefixed with either Traditional or Simplified depending on whether it is based on a traditional or simplified text corpus.","category":"page"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"SimplifiedLCMC\nSimplifiedJunDa\nTraditionalHuangTsai\nSimplifiedLeidenWeibo\nSimplifiedSUBTLEX","category":"page"},{"location":"api/freqlist/#CJKFrequencies.SimplifiedLCMC","page":"Frequency Lists","title":"CJKFrequencies.SimplifiedLCMC","text":"SimplifiedLCMC([categories])\n\nA character frequency dataset: Lancaster Corpus for Mandarin Chinese, simplified terms only, based on simplified text corpus. See their website for more details about the corpus.\n\nThe character frequency can be based only on selected categories (see CJKFrequencies.LCMC_CATEGORIES for valid  category keys and corresponding category names). Any invalid categories will be ignored.\n\nExamples\n\nLoading all the categories:\n\njulia> charfreq(SimplifiedLCMC())\nDataStructures.Accumulator{String,Int64} with 45411 entries:\n  \"一路…   => 1\n  \"舍得\"   => 9\n  \"５８\"   => 1\n  \"神农…   => 1\n  \"十点\"   => 8\n  \"随从\"   => 9\n  \"荡心…   => 1\n  \"尺码\"   => 1\n  ⋮      => ⋮\n\nOr loading just a subset (argument can be any iterable):\n\njulia> charfreq(SimplifiedLCMC(\"ABEGKLMNR\"))\nDataStructures.Accumulator{String,Int64} with 35488 entries:\n  \"废…  => 1\n  \"蜷\"  => 1\n  \"哇\"  => 13\n  \"丰…  => 1\n  \"弊…  => 3\n  \"议…  => 10\n  \"滴\"  => 28\n  \"美…  => 1\n  ⋮    => ⋮\n\nLicensing/Copyright\n\nNote: This corpus has some conflicting licensing information, depending on who is supplying the data.\n\nThe original corpus is provided primarily for non-profit-making research. Be sure to see the full end user license agreement.\nVia the Oxford Text Archive, this corpus is distributed under the CC BY-NC-SA 3.0 license.\n\n\n\n\n\n","category":"type"},{"location":"api/freqlist/#CJKFrequencies.SimplifiedJunDa","page":"Frequency Lists","title":"CJKFrequencies.SimplifiedJunDa","text":"SimplifiedJunDa([list])\n\nA character frequency dataset  of modern Chinese compiled by Jun Da, for simplified characters.\n\nBy default, the modern Chinese list is fetched,  but this can be set by providing a different list argument. The available lists are as follows:\n\nList Name Symbol\nModern Chinese (default) :modern\nClassical Chinese :classical\nModern + Classical Chinese :combined\n《现代汉语常用字表》 :common\nNews Corpus Bigrams :bigram_news\nFiction Corpus Bigrams :bigram_fiction\n\nNote that although :classical uses a Classical Chinese corpus, it still uses the simplified character set.\n\nExamples\n\njulia> charfreq(SimplifiedJunDa())\nDataStructures.Accumulator{String,Int64} with 9932 entries:\n  \"蜷… => 837\n  \"哇… => 4055\n  \"湓… => 62\n  \"滴… => 8104\n  \"堞… => 74\n  \"狭… => 6901\n  \"尚… => 38376\n  \"懈… => 2893\n  ⋮   => ⋮\n\nLicensing/Copyright\n\nThe original author maintains full copyright to the character frequency lists, but provides the lists for research and teaching/learning purposes only, no commercial use without permission from  the author. See their full disclaimer and copyright notice.\n\n\n\n\n\n","category":"type"},{"location":"api/freqlist/#CJKFrequencies.TraditionalHuangTsai","page":"Frequency Lists","title":"CJKFrequencies.TraditionalHuangTsai","text":"TraditionalHuangTsai()\n\nA character frequency dataset initially created by Shih-Kun Huang and then further compiled and added to by Chih-Hao Tsai.\n\nThe original corpus was collected from 1993-94.\n\nLicensing/Copyright\n\nCopyright 1996-2006 Chih-Hao Tsai. Licensing information unknown, so use at your own risk.\n\n\n\n\n\n","category":"type"},{"location":"api/freqlist/#CJKFrequencies.SimplifiedLeidenWeibo","page":"Frequency Lists","title":"CJKFrequencies.SimplifiedLeidenWeibo","text":"SimplifiedLeidenWeibo()\n\nA word frequency dataset built from Weibo messages This corpus also includes geo-lexical frequency keyed by city, but this is not included in this character frequency.\n\nThis data was collected in 2012.\n\nLicensing/Copyright\n\nThe data is generated from the Leiden Weibo Corpus, which is released openly under the CC BY-NC-SA 3.0 license.\n\n\n\n\n\n","category":"type"},{"location":"api/freqlist/#CJKFrequencies.SimplifiedSUBTLEX","page":"Frequency Lists","title":"CJKFrequencies.SimplifiedSUBTLEX","text":"SimplifiedSUBTLEX(form)\n\nA word and character frequency dataset  generated from film subtitles. To get the respective frequency list, pass either :char or :word for the form parameter.\n\nThis dataset was published in 2010.\n\nLicensing/Copyright\n\nThe dataset was developed under a non-commercial grant,  and the researchers have released free access for research purposes.\n\n\n\n\n\n","category":"type"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"Other data sets are planned to be added. To add a data set to this API, see the Developer Docs page.","category":"page"},{"location":"api/freqlist/#Frequency-List-Type","page":"Frequency Lists","title":"Frequency List Type","text":"","category":"section"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"CJKFrequency","category":"page"},{"location":"api/freqlist/#CJKFrequencies.CJKFrequency","page":"Frequency Lists","title":"CJKFrequencies.CJKFrequency","text":"Accumulator-like data structure for storing frequencies of CJK words  (although other tokens can be stored as well).  This is usually like the type Accumulator{String, Int}.\n\nYou generally don't need to explicitly call this struct's constructor yourself;  rather, use the charfreq function.\n\n\n\n\n\n","category":"type"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"Common operations on CJKFrequency:","category":"page"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"DataStructures.inc!\nDataStructures.dec!\nDataStructures.reset!\nand most typical \"iterable\" or \"indexable\" functions.","category":"page"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"Both length and size are defined: the length of a frequency list is the number of terms in the frequency list, whereas the size is the total count of all tokens.","category":"page"},{"location":"api/freqlist/","page":"Frequency Lists","title":"Frequency Lists","text":"CJKFrequencies.entropy","category":"page"},{"location":"api/freqlist/#CJKFrequencies.entropy","page":"Frequency Lists","title":"CJKFrequencies.entropy","text":"entropy(charfreq)\n\nCompute the information theoretic entropy for a character frequency, defined as\n\n-sum_(c v)in CF fracvslog_2left( fracvs right) quad s=sum_(c v) in CF v\n\nwhere c is the character and v is the count for that value.\n\n\n\n\n\n","category":"function"},{"location":"#CJKFrequencies.jl-Documentation","page":"Home","title":"CJKFrequencies.jl Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package primarily provides the function charfreq for computing and loading character frequencies of CJK-like languages.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Note that while the source code for this package is MIT-licensed, some of the character frequency datasets are not. The licensing/copyright information for each dataset is listed under the respective struct on Supported Predefined Character Frequency Datasets.","category":"page"},{"location":"#Contents","page":"Home","title":"Contents","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Frequency Lists\nLexicons\nDeveloper Docs","category":"page"},{"location":"devdocs/#Developer-Docs","page":"Developer Docs","title":"Developer Docs","text":"","category":"section"},{"location":"devdocs/#Adding-a-new-character/word-frequency-dataset","page":"Developer Docs","title":"Adding a new character/word frequency dataset","text":"","category":"section"},{"location":"devdocs/","page":"Developer Docs","title":"Developer Docs","text":"To add a new character frequency dataset using this API, a method just needs to be added to the charfreq function. It should have the signature","category":"page"},{"location":"devdocs/","page":"Developer Docs","title":"Developer Docs","text":"function charfreq(cf::CustomDataSetStruct)::CJKFrequency end","category":"page"},{"location":"devdocs/","page":"Developer Docs","title":"Developer Docs","text":"where the CustomDataSetStruct is any struct that you define for that particular character frequency data set. If needed, the constructor for the struct should take any arguments (e.g. see SimplifiedLCMC for an example with arguments).","category":"page"},{"location":"devdocs/","page":"Developer Docs","title":"Developer Docs","text":"The return value should have type CJKFrequency.","category":"page"}]
}
