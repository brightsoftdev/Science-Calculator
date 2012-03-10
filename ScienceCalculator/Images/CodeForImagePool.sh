mv background.png background.png2
mv screen.png screen.png2
count=0
for item in *.png
do
	name="`echo $item | sed s/\.png//g`"
	echo "POOLIMAGE($count,@\"$name\",@\"$item\");"
	count=$(($count+1))
done
for item in *.png
do
    name="`echo $item | sed s/\.png//g`"
    echo "extern const int kImage_$name;"
done
count=0
for item in *.png
do
	name="`echo $item | sed s/\.png//g`"
	echo "const int kImage_$name = $count;"
	count=$(($count+1))
done
mv screen.png2 screen.png
mv background.png2 background.png

