echo "Assuming current desktop is typhoon."
echo "All .zip files will be copied from ~/Downloads/bemuse."
echo "This script will continue in two seconds..."
sleep 2

if [ -d ./working ]
then
	echo "Cleaning ./working directory."
	rm -rf ./working
fi

mkdir working
cd working
scp kmo@typhoon:~/Downloads/bemuse/* .
unzip -q '*.zip'
rm -rf *.zip

for dir in ./*/
do
	dir=${dir%*/}
	echo "Running pack on $dir:"
	bemuse-tools pack "$dir"
done

echo "Copying files to staging..."
cd ..
cp -r ./working/* ./server

echo "Indexing the stage..."
cd server
bemuse-tools index

echo "Copying over to /var/www/bemuse..."
sudo rm -rf /var/www/bemuse/*
sudo cp -r . /var/www/bemuse

echo "Done."
