# Prepare graphs for learning

K=5

MAX_FOLD=2

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
echo "Saving Neo4j server information"
for ((i=0; i<K; i++)); do
    serv_loc="$PWD/fold$i/integrate/neo4j/servers.py"
    json_loc="$PWD/fold$i/learn/all-features/servers.json"

    python $serv_loc --write $json_loc
done


cd ~
echo "Running precalculation notebooks"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j$MAX_FOLD --no-notice bash 3.1-pre_calc.sh



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
