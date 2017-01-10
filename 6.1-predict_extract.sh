fold=$1

# start neo4j servers
cd ~
cd "fold$fold/learn/all-features"
echo "Starting neo4j servers for fold $fold"
SERVERS=../../integrate/neo4j/servers.py
python $SERVERS --start-all


# run the extract notebooks
cd ~
cd "fold$fold/learn/prediction"

echo "Starting extraction for fold $fold"
jupyter nbconvert --execute 2-extract.ipynb --inplace --ExecutePreprocessor.timeout=-1
echo "Finished extraction step for fold $fold"


# stop neo4j servers
cd ~
echo "Stopping neo4j servers for fold $fold"
SERVERS="fold$fold/integrate/neo4j/servers.py"
python $SERVERS --stop-all

echo "Finished extraction for fold $fold"
