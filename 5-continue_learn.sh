# Continue the learning paradigm

K=5

# assumes all prior steps have completed successfully

TOP=$(dirname "$PWD")

echo "Activating learning environment"
source activate integrate


cd $TOP

#echo "Creating feature matrix"
#for ((i=0; i<K; i++)); do
#    cd "fold$i/learn/all-features"
#    jupyter nbconvert --execute 4-matrixfy.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
#    cd $TOP
#done
#wait


cd $TOP
echo "Calculating primary AUCs"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    jupyter nbconvert --execute 5-primary-aucs.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd $TOP
done
wait


cd $TOP
echo "Calculating DWPCs"
for ((i=0; i<K; i++)); do
    cd "fold$i/learn/all-features"
    jupyter nbconvert --execute 5.5-transplit-DWPCs.ipynb --inplace --ExecutePreprocessor.timeout=-1 &
    cd $TOP
done
wait

source deactivate

echo "Finished"
