# Script for preparing the Neo4j networks
# Prepares K versions

# number of cross validations
K=5

# max number of fold validations to do concurrently
MAX_FOLD=3


echo "Preparing folder structure for $K fold cross validation"
for ((i=0; i<K; i++)); do
    if [ ! -d "fold$i" ]; then
        echo "Creating folder for validation fold $i"
        mkdir "fold$i"

        echo "$i" > "fold$i/crossval_idx.txt"
    fi
done


echo "Cloning integrate repository"
for ((i=0; i<K; i++)); do
    cd "fold$i"

    if [ ! -d "integrate" ]; then
        echo "Cloning integrate repository for fold $i"
        git clone https://github.com/veleritas/integrate.git
    fi

    cd ..
done
wait

#-------------------------------------------------------------------------------

echo "Activating runtime environment"
source activate integrate

echo "Preparing resources"
for ((i=0; i<K; i++)); do
    cd "fold$i/integrate"

    bash precompile.sh &

    cd ~
done
wait

echo "Finished precompiling resources"


cd ~
echo "Running integration scripts"


for ((i=0; i<K; i++)); do echo $i; done | parallel -j$MAX_FOLD --no-notice bash sub_build_graphs.sh


echo "Done data integration for $K fold cross validation"
