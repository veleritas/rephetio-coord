K=5

MAX_FOLD=1

TOP=$(dirname "$PWD")

echo "Activating python environment"
source activate integrate


cd $TOP
for ((i=0; i<K; i++)); do
    echo "Preparing for making predictions for fold $i"

    cd "fold$i/learn/prediction/"
    jupyter nbconvert --execute 1-prepare.ipynb --inplace --ExecutePreprocessor.timeout=-1 &

    cd $TOP
done
wait

for ((i=0; i<K; i++)); do
    echo "Starting new extract and matrixify for fold$i"

    cd "$TOP/fold$i/learn/prediction"
    jupyter nbconvert --execute new_predict_extract.ipynb --inplace --ExecutePreprocessor.timeout=-1
done

source deactivate

echo "Finished preparation for prediction calculation"
