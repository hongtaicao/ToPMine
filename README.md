# ToPMine
I'm hosting the files originially provided by Ahmed El-Kishky on github with minimal changes.


# From El-Kishky

## Illimine Copyright

University of Illinois at Urbana-Champaign, 2014

illimine.cs.illinois.edu


## Additional Copyright

This package contains the source code and the dataset used in the following paper:

@inproceedings{conf/vldb/ElkishkySWVH13,
  author    = {Ahmed El-Kishky and
		Yanglei Song and
		Chi Wang and
		Clare R. Voss and
		Jiawei Han},
  title     = {Scalable Topical Phrase Mining from Text Corpora},
  booktitle = {VLDB},
  year      = {2015},
}

If you use any contents in this package, please cite the above paper as your reference.


## Code explanation

Place the input corpus in rawFiles with each document on a line
Edit the parameters in run.sh(linux)/win_run.bat(for windows) for minimum support and topic modeling parameters
run run.sh (for linux)/ win_run.bat (for windows, or just double click)

Parameter explanation:
1.) minsup = minumum support (minimum times a phrase candidate should appear in the corpus to be significant)
2.) maxpattern = max size you would like a phrase to be (if you don't want too long of phrases that occasionally occur)
3.) numTopics = number of topics - same as LDA
4.) Gibbs Sampling iterations = number of iterations done for inference (learning the parameters. Usually 500 is good, may do more if you like)
5.) thresh (significance) = the significance of a phrase. Equivalent to a z-score. I usually use 3 to 5. The higher it is, the fewer phrases will be found, but they will be of very high quality.
6.) Topic Model, two variants of PhraseLDA are used (choose 1 or 2). 2 is the default topic model.

The output should be in output, you will have corpus and topics

Corpus is the corpus partitioned into phrases, stopwords are removed except those in phrases
each phrase is delimited by a comma

The topics file is a one-to-one and onto mapping between documents and topics for each phrase

_Alert from Justin: This is not always true._

e.g

line 1 in corpus is document 1
line 1 in topics is the topics for phrases in document 1

example:

Line 1 corpus: Cow Dog Flower
Line 1 topics: 2 2 1

Cow is topic 2, dog is topic 2, flower is topic 1 

there are also output files for the top phrases (ranked by their frequency)

 	
## For More Questions

Please contact illimine.cs.illinois.edu or Ahmed El-Kishky (elkishk2@illinois.edu) or
Yanglei Song (ysong44@illinois.edu)


# From Hongtai Cao
## quick start
* In the roject root directory, build the project by ``make``.
* Edit ``run.sh`` by commenting out ``line 5``.
* Execute run.sh using command ``./run.sh <absolute-path-to-corpus>``.

## comment error
* Line #1 does not match regex.
```
./run.sh /home/hongt/ToPMine/Scottish.txt
/home/hongt/ToPMine/Scottish.txt
rm: cannot remove 'TopicalPhrases/input_dataset/*': No such file or directory
rm: cannot remove 'output/outputFiles/*': No such file or directory
Classpath: /home/hongt/ToPMine/TopicalPhrases/bin:/home/hongt/ToPMine/external/mallet.jar:/home/hongt/ToPMine/external/snowball-20051019.jar:/home/hongt/ToPMine/external/trove-2.0.2.jar
/home/hongt/ToPMine/Scottish.txt
input
5
4
___
Warning: This is going to write a logging error, unimportant.
First pass: finding rare words...
Exception in thread "main" java.lang.IllegalStateException: Line #1 does not match regex:
A Scottish restaurant in a very grand setting in the centre of town. The food is lovely, but it can be a little rich at times, and the service can be a little slow. A good place to take someonne you'd like to impress, though, and it's not ridiculously expensive.
        at cc.mallet.pipe.iterator.CsvIterator.next(CsvIterator.java:95)
        at cc.mallet.pipe.iterator.CsvIterator.next(CsvIterator.java:44)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:290)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:282)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:290)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:282)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:290)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:282)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:290)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:282)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:290)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:282)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:290)
        at cc.mallet.pipe.Pipe$SimplePipeInstanceIterator.next(Pipe.java:282)
        at cc.mallet.types.InstanceList.addThruPipe(InstanceList.java:267)
        at DataPreparation.PrepareData.main(PrepareData.java:97)
...
```
* The pattern can be found at ``PrepareData.java`` lines 67-76 as the followings
```java
    Pattern linePattern = null;
    if(startsWithID == 1){ // just test
       linePattern = Pattern.compile("()()(.*)");
    }else if(startsWithID == 2){//doc id/ no label: the docid may contain -
       linePattern = Pattern.compile("([^\\s]+)\\s+()(.*)");
    }else if(startsWithID == 3){//doc id/label
       linePattern = Pattern.compile("([^\\s]+)\\s+([^\\s]+)\\s+(.*)");
    } else { //meta . text (no label)
      linePattern = Pattern.compile("([^\\.]+)\\s+\\.\\s+()(.*)");
    }
```
* The ``startsWithID`` parameter is explained in ``TopicalPhrases/runDataPreparation.sh``.
* Therefore example corpus should be the following:
```
1 . A Scottish restaurant in a very grand setting in the centre of town. The food is lovely, but it can be a little rich at times, and the service can be a little slow. A good place to take someonne you'd like to impress, though, and it's not ridiculously expensive.
2 . Howies is a local chain with a number of restaurants in Edinburgh, it specialises in modern British/Scottish cuisine and proves itself to be popular with both locals and tourists.
```
* The provided sample corpus is very small and therefore the default min support ``minsup`` (``TopicalPhrases/runDataPreparation.sh``) might be too high, and causes exceptions for other commands in ``run.sh``.
