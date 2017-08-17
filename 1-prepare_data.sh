# Script for preparing the cross validation directory
# Installs into the directory above the current directory

# check that user decided which dataset to use
if [ $# -eq 0 ]; then
    echo "Please enter the gold standard name: 'gold' or 'rare'"
    exit 1
fi

dataset=$1

echo "Starting gold standard splitting with '$dataset' dataset..."


# directory above current
TOP=$(dirname "$PWD")

echo "Create anaconda environment"
conda env create -f environment.yml

echo "Preparing the cross validation data repository"

cd $TOP
if [ -d "crossval" ]; then
    echo "Skipping crossval directory cloning"
else
    echo "Cloning crossval directory"
    git clone https://github.com/veleritas/crossval.git
fi

echo "Finished crossval directory setup"

echo "Starting up environment"
source activate integrate

echo "Running data preparation notebook"
jupyter nbconvert --execute "crossval/split_${dataset}_standard.ipynb" --inplace --FilesWriter.build_directory=crossval --executePreprocessor.timeout=-1

echo "Finished running gold standard splitting notebook"

source deactivate

echo "Finished crossval preprocessing"
