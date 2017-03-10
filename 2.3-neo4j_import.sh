# sub script for building hetnets

fold=$1

echo "Beginning fold $fold hetnet construction"

source activate integrate

cd "fold$fold/integrate"

jupyter nbconvert --execute prepare_neo4j_import_csvs.ipynb --inplace --ExecutePreprocessor.timeout=-1

jupyter nbconvert --execute prep_import.ipynb --inplace --ExecutePreprocessor.timeout=-1

echo "Finished fold $fold hetnet construction"
