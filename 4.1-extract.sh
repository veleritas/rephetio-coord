fold=$1

cd ~
cd "fold$fold/learn/all-features"

echo "Starting neo4j servers for fold $fold"
bash pipeline.sh

echo "Starting feature extraction for fold $fold"

jupyter nbconvert --execute 3-extract.ipynb --inplace --ExecutePreprocessor.timeout=-1

echo "Finished feature extraction for fold $fold"

SERVERS=../../integrate/neo4j/servers.py
python $SERVERS --stop-all
