# Script for preparing the cross validation directory
# Installs into the directory above the current directory

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
jupyter nbconvert --execute crossval/split_gold_standard.ipynb --inplace --FilesWriter.build_directory=crossval --executePreprocessor.timeout=-1

echo "Finished running gold standard splitting notebook"

cd crossval

git status

echo "Git status should be clean"

cd $TOP

echo "Finished crossval preprocessing"
