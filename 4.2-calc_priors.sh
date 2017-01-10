fold=$1

cd ~
cd "fold$fold/learn/prior/"

echo "Starting prior calculations for fold $fold"

source activate integrate

python 1-prior.py

#jupyter nbconvert --execute 1-prior.ipynb --inplace --ExecutePreprocessor.timeout=-1

echo "Finished prior calculations for fold $fold"
