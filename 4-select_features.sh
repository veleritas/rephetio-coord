# select the metapath features which will be used for learning

K=1

MAX_FOLD=1

# assumes all prior steps have completed successfully

echo "Activating learning environment"
source activate integrate


echo "Starting parallel extract for $K folds ($MAX_FOLD concurrently)"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j$MAX_FOLD --no-notice bash 4.1-extract.sh
echo "Finished parallel extract"


echo "Starting parallel prior calculations for $K folds ($MAX_FOLD concurrently)"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j5 --no-notice bash 4.2-calc_priors.sh
echo "Finished calculating priors"

echo "Finished"
