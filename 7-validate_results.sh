# make the final predictions and validate the results

K=5


echo "Activating python environment"
source activate integrate


for ((i=0; i<K; i++)); do
    echo "Building model for fold $i"

    cd ~
    cd "fold$i/learn/prediction"

    jupyter nbconvert --execute 4-predictr.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
done
wait


for ((i=0; i<K; i++)); do
    echo "Formatting results for fold $i"

    cd ~
    cd "fold$i/learn/prediction"

    jupyter nbconvert --execute eval_results.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
done
wait


for ((i=0; i<K; i++)); do
    echo "Generating graphs for fold $i"

    cd ~
    cd "fold$i/learn/prediction"

    jupyter nbconvert --execute eval_curves.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
done
wait

echo "Finished entire pipeline"
