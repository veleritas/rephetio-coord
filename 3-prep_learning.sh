# Prepare graphs for learning

K=5

MAX_FOLD=3

# assumes that build_graphs.sh has successfully finished running

# Download learn repository if it doesn't exist
echo "Downloading learn repository"

for ((i=0; i<K; i++)); do
    if [ ! -d "fold$i/learn" ]; then
        echo "Downloading learn into fold $i"

        cd "fold$i"
        git clone https://github.com/veleritas/learn.git
        cd ..
    fi
done

echo "Finished cloning learn repository"

source activate integrate

cd ~
echo "Start neo4j servers"
# uses 15 GB RAM for 5fold, smallest network
# may need to do everything in limits of MAX_FOLD
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    bash pipeline.sh
    cd ~
done


cd ~
echo "Running summary notebooks"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/summary"
    echo "Starting summary notebook for fold $i"
    jupyter nbconvert --execute 1-summary.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait


cd ~
echo "Running partition notebook"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    echo "Starting partition notebook for fold $i"
    jupyter nbconvert --execute 1-partition.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait


cd ~
echo "Running metapath notebook"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    echo "Starting metapath notebook for fold $i"
    jupyter nbconvert --execute 2-metapaths.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait

echo "Finished preparing for learning"
