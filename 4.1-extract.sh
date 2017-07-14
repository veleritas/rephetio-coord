fold=$1

TOP=$(dirname "$PWD")

serv_loc="$TOP/fold$fold/integrate/neo4j/servers.py"

echo "Starting neo4j servers for fold $fold"
python $serv_loc --start-all


echo "Starting feature extraction for fold $fold"

cd "$TOP/fold$fold/learn/all-features"
source activate integrate

python 3-extract.py

echo "Finished feature extraction for fold $fold"

python $serv_loc --stop-all

source deactivate
