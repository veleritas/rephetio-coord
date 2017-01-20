fold=$1

echo "Starting fold $fold permutation"

cd "fold$fold/integrate"
jupyter nbconvert --execute permute.ipynb --inplace --ExecutePreprocessor.timeout=-1

echo "Finished fold $fold permutation"
