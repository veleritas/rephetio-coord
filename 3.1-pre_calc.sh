fold=$1


serv_loc="$PWD/fold$fold/integrate/neo4j/servers.py"

echo "Starting neo4j servers for fold $fold"
python $serv_loc --start-all


source activate integrate

echo "Running summary notebook for $fold"
cd "fold$fold/learn/summary"
jupyter nbconvert --execute 1-summary.ipynb --inplace --ExecutePreprocessor.timeout=-1

cd "../all-features"
jupyter nbconvert --execute 1-partition.ipynb --inplace --ExecutePreprocessor.timeout=-1


echo "Stopping neo4j servers for $fold"
python $serv_loc --stop-all
