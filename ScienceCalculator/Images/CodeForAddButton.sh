count=0
for item in $(cat ButtonMap)
do
	echo "#define kButton_$item $count"
	count=$(($count+1))
done
count=0
for item in $(cat ButtonMap)
do
    echo "ADDBUTTON($count,@\"$item\",kImage_$item);"
	count=$(($count+1));
done
