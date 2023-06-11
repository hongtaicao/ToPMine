#!/bin/bash
#PBS -l select=1:ncpus=64:mem=1950gb,walltime=72:00:00
#PBS -q bigmem

# cd $PBS_O_WORKDIR


echo $1
if [ -f "$1" ]; then
  inputFile=$1
else
  inputFile=/scratch2/jsybran/moliere_2017/processedText/abstracts.raw.filtered.txt
fi

source setEnv.sh

./cleanTmp.sh

echo "Classpath: $CLASSPATH"

# minimum phrase frequency
minsup=30
#maximum size of phrase (number of words)
maxPattern=6
#Two variations of phrase lda (1 and 2). Default topic model is 2
topicModel=1
numTopics=20
#set to 0 for no topic modeling and > 0 for topic modeling (around 1000)
gibbsSamplingIterations=0
#significance threshold for merging unigrams into phrases
thresh=25
#burnin before hyperparameter optimization
optimizationBurnIn=100
#alpha hyperparameter
alpha=2
#optimize hyperparameters every n iterations
optimizationInterval=50
cd TopicalPhrases
#Run Data preprocessing
./runDataPreparation.sh $inputFile
#Run frequent phrase mining
./runCPM.sh $minsup $maxPattern $thresh
#Run topic modeling
./runPhrLDA.sh $topicModel $numTopics $gibbsSamplingIterations $optimizationBurnIn $alpha $optimizationInterval
#Run post processing (insert stop words and unstem properly)
./createUnStem.sh $inputFile $maxPattern
#Recreate original corpus
./unMapper.py input_dataset/input_vocFile input_dataset/input_stemMapping input_dataset_output/unmapped_phrases input_dataset_output/input_partitionedTraining.txt input_dataset_output/newPartition.txt
#Copy to output
cp input_dataset_output/newPartition.txt ../output/corpus.txt
cp input_dataset_output/input_wordTopicAssign.txt ../output/topics.txt
cd ..
cd output
./topPhrases.py
./topTopics.py
mkdir outputFiles
mv *.txt outputFiles
