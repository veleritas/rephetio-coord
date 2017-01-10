# select the metapath features which will be used for learning

K=5

MAX_FOLD=2

# assumes all prior steps have completed successfully

echo "Activating learning environment"
source activate integrate


cd ~
for ((i=0; i<K; i++)); do
    echo "Starting neo4j servers for fold $i"

    cd "fold$i/learn/all-features"
    bash pipeline.sh
    cd ~
done

exit


# this doesn't work either
# not sure why, but the code hangs after the execution of the notebook should be finished

cd ~
echo "Starting serial prior calculations"

for ((i=0; i<K; i++)); do
    echo "Running priors for fold $i"

    cd "fold$i/learn/prior"
    jupyter nbconvert --execute 1-prior.ipynb --inplace --ExecutePreprocessor.timeout=-1

    echo "Finished priors for fold $i"
    cd ~
done







echo "done done done"
exit



# parallel extract also works if it's the only thing that gets done in the subscript
# works fine if it's the only command being run

echo "Starting parallel extract for $K folds ($MAX_FOLD concurrently)"
for ((i=0; i<K; i++)); do echo $i; done | parallel -j$MAX_FOLD --no-notice bash 4.1-extract.sh
echo "Finished parallel extract"




cd ~
echo "Starting serial prior calculations"

for ((i=0; i<K; i++)); do
    echo "Running priors for fold $i"

    cd "fold$i/learn/prior"
    jupyter nbconvert --execute 1-prior.ipynb --inplace --ExecutePreprocessor.timeout=-1

    echo "Finished priors for fold $i"
    cd ~
done





# this doesn't work for some reason and hangs the system doing nothing

#echo "Starting parallel prior calculations for $K folds ($MAX_FOLD concurrently)"
#for ((i=0; i<K; i++)); do echo $i; done | parallel -j$MAX_FOLD --no-notice bash 4.2-calc_priors.sh
#echo "Finished calculating priors"
#
#echo "DONE DONE DONE"
#
#exit




cd ~
echo "Creating feature matrix"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    jupyter nbconvert --execute 4-matrixfy.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait


cd ~
echo "Calculating primary AUCs"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    jupyter nbconvert --execute 5-primary-aucs.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait


cd ~
echo "Calculating DWPCs"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    jupyter nbconvert --execute 5.5-transplit-DWPCs.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait

echo "Finished"
