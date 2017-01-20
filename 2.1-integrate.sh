fold=$1

echo "Starting fold $fold hetnet integration"

cd "fold$fold/integrate"
jupyter nbconvert --execute integrate.ipynb --inplace --ExecutePreprocessor.timeout=-1

echo "Finished fold $fold hetnet integration"
