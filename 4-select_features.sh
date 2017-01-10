# select the metapath features which will be used for learning

K=5

MAX_FOLD=2

# assumes all prior steps have completed successfully

echo "Activating learning environment"
source activate integrate

# parallel extract also works if it's the only thing that gets done in the subscript
# works fine if it's the only command being run

# may need to check that the servers are all running ok
# I think it said that some servers didn't start

echo "Starting parallel extract for $K folds ($MAX_FOLD concurrently)"
for ((i=0; i<K; i++)); do echo $i; done | parallel -j$MAX_FOLD --no-notice bash 4.1-extract.sh
echo "Finished parallel extract"

# this works now if the prior calculation notebook is turned into a script
# can probably also remove the fold limitation here

echo "Starting parallel prior calculations for $K folds ($MAX_FOLD concurrently)"
for ((i=0; i<K; i++)); do echo $i; done | parallel -j$MAX_FOLD --no-notice bash 4.2-calc_priors.sh
echo "Finished calculating priors"

echo "Finished"
