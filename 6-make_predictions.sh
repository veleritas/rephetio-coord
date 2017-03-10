K=5

MAX_FOLD=1

echo "Activating python environment"
source activate integrate


cd ~
for ((i=0; i<K; i++)); do
    echo "Preparing for making predictions for fold $i"

    cd "fold$i/learn/prediction/"
    jupyter nbconvert --execute 1-prepare.ipynb --inplace --ExecutePreprocessor.timeout=-1 &

    cd ~
done
wait


echo "Starting prediction feature extraction"
for ((i=0; i<K; i++)); do echo $i; done | parallel --ungroup -j$MAX_FOLD --no-notice bash 6.1-predict_extract.sh
echo "Finished prediction extraction"


cd ~
for ((i=0; i<K; i++)); do
    echo "Running matrixfy for fold $i"
    cd "fold$i/learn/prediction"
    jupyter nbconvert --execute 3-matrixfy.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd ~
done
wait

echo "Finished preparation for prediction calculation"
