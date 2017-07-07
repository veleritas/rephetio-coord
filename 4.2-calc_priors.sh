fold=$1

TOP=$(dirname "$PWD")

cd "$TOP/fold$fold/learn/prior/"

echo "Starting prior calculations for fold $fold"

source activate integrate
python 1-prior.py

echo "Finished prior calculations for fold $fold"
