#Download Bison from http://ftp.gnu.org/gnu/bison/
#bison-3.5.tar.gz
#Assuming Bison folder is in ~/Downloads
cd ..
cd Downloads
tar -zxvf bison-3.5.tar.gz
cd bison-3.5
sudo ./configure
sudo make
sudo make install
