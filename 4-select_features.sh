# select the metapath features which will be used for learning

K=5

MAX_FOLD=1

TOP=$(dirname "$PWD")

# assumes all prior steps have completed successfully

echo "Activating learning environment"
source activate integrate


#echo "Starting parallel extract for $K folds ($MAX_FOLD concurrently)"
#for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j$MAX_FOLD --no-notice bash 4.1-extract.sh
#echo "Finished parallel extract"



echo "Starting parallel prior calculations for $K folds ($MAX_FOLD concurrently)"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j5 --no-notice bash 4.2-calc_priors.sh
echo "Finished calculating priors"


# we do the extraction after prior calculation now
echo "Running new combined all-features extract and matrixify for fold $i"
for ((i=0; i<K; i++)); do
    cd "$TOP/fold$i/learn/all-features"
    jupyter nbconvert --execute new_extract_matrixify.ipynb --inplace --ExecutePreprocessor.timeout=-1

done

source deactivate

echo "Finished"
