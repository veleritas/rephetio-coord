# stop all neo4j servers for all folds

K=5

for ((i=0; i<K; i++)); do
    SERVERS="fold$i/integrate/neo4j/servers.py"

    echo "Stopping neo4j servers for fold $i"
    python $SERVERS --stop-all
done
