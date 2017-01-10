fold=$1

cd ~
cd "fold$fold/learn/all-features"

echo "Starting feature extraction for fold $fold"

jupyter nbconvert --execute 3-extract.ipynb --inplace --ExecutePreprocessor.timeout=-1

echo "Finished feature extraction for fold $fold"
