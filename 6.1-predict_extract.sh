fold=$1

TOP=$(dirname "$PWD")

echo "Starting neo4j servers for fold $fold"
serv_loc="$TOP/fold$fold/integrate/neo4j/servers.py"
python $serv_loc --start-all


source activate integrate

# run the extract notebooks
echo "Starting extraction for fold $fold"

cd "$TOP/fold$fold/learn/prediction"

python 2-extract.py

echo "Finished extraction step for fold $fold"


# stop neo4j servers
echo "Stopping neo4j servers for fold $fold"
python $serv_loc --stop-all

echo "Finished extraction for fold $fold"
