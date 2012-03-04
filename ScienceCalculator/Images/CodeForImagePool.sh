count=0
for item in *.png
do
	name="`echo $item | sed s/\.png//g`"
	echo "POOLIMAGE($count,@\"$name\",@\"$item\");"
	count=$(($count+1))
done
count=0
for item in *.png
do
	name="`echo $item | sed s/\.png//g`"
	echo "#define kImage_$name $count"
	count=$(($count+1))
done

