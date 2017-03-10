fold=$1

echo "Starting neo4j servers for fold $fold"
serv_loc="$PWD/fold$fold/integrate/neo4j/servers.py"
python $serv_loc --start-all


source activate integrate

# run the extract notebooks
echo "Starting extraction for fold $fold"

cd "fold$fold/learn/prediction"

python 2-extract.py

#jupyter nbconvert --execute 2-extract.ipynb --inplace --ExecutePreprocessor.timeout=-1
echo "Finished extraction step for fold $fold"


# stop neo4j servers
echo "Stopping neo4j servers for fold $fold"
python $serv_loc --stop-all

echo "Finished extraction for fold $fold"
