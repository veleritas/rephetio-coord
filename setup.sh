# Install necessary dependencies to a fresh AWS Ubuntu 16.04 instance

sudo apt-get update
sudo apt-get install -y htop parallel

# Install Anaconda
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
bash Anaconda3-4.2.0-Linux-x86_64.sh
rm Anaconda3-4.2.0-Linux-x86_64.sh


# Java is needed for Neo4j
sudo apt-get install -y default-jdk

# Install the latest R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'

sudo apt-get update
sudo apt-get install -y r-base

# Needed for R Ipython kernel
sudo apt-get install -y libcurl4-openssl-dev libssl-dev
