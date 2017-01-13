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
        git clone https://github.com/veleritas/integrate.git
    fi

    cd ..
done

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


echo "Running integration scripts"

cd ~
echo "Running integrate notebooks"
for ((i=0; i<K; i++)); do
    cd "fold$i/integrate"

    echo "Running integrate.ipynb for fold $i"
    jupyter nbconvert --execute integrate.ipynb --inplace --ExecutePreprocessor.timeout=-1 &

    cd ~
done
wait


cd ~
echo "Running permute notebooks"
for ((i=0; i<K; i++)); do
    cd "fold$i/integrate"

    echo "Running permute.ipynb for fold $i"
    jupyter nbconvert --execute permute.ipynb --inplace --ExecutePreprocessor.timeout=-1 &

    cd ~
done
wait


echo "Running neo4j imports"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j$MAX_FOLD --no-notice bash 2.1-neo4j_import.sh

echo "Done data integration for $K fold cross validation"
