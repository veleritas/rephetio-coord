# Script for preparing the Neo4j networks
# Prepares K versions

# number of cross validations
K=5

# max number of fold validations to do concurrently
MAX_FOLD=2


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
        git clone https://github.com/veleritas/integrate.git -b neo3test
    fi

    cd ..
done

#-------------------------------------------------------------------------------

echo "Activating runtime environment"
source activate integrate

# notebooks do not affect output files

#echo "Preparing resources"
#for ((i=0; i<K; i++)); do
#    cd "fold$i/integrate"
#    bash precompile.sh &
#    cd ~
#done
#wait
#
#echo "Finished precompiling resources"


echo "Running integration scripts"

for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j5 --no-notice bash 2.1-integrate.sh

for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j5 --no-notice bash 2.2-permute.sh


echo "Running neo4j imports"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j5 --no-notice bash 2.3-neo4j_import.sh


# run the neo4j csv importer
for ((i=0; i<K; i++)); do
    cd ~
    echo "Running Neo4j CSV importer for fold $i"
    cd "fold$i/integrate"
    bash neo4j-import.sh
done

echo "Done data integration for $K fold cross validation"
