# sub script for building hetnets

fold=$1

echo "Beginning fold $fold hetnet construction"

cd "fold$fold/integrate"

bash build.sh

echo "Finished fold $fold hetnet construction"
