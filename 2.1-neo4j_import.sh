# sub script for building hetnets

fold=$1

echo "Beginning fold $fold hetnet construction"

cd "fold$fold/integrate"
jupyter nbconvert --execute neo4j-import.ipynb --inplace --ExecutePreprocessor.timeout=-1
echo "Finished fold $fold hetnet construction"
