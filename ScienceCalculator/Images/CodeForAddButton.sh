count=0
for item in $(cat ButtonMap)
do
	echo "const int kButton_$item = $count;"
	count=$(($count+1))
done
count=0
for item in $(cat ButtonMap)
do
    echo "ADDBUTTON($count,$item,buttonPressed:);"
	count=$(($count+1));
done
for item in $(cat ButtonMap)
do
    echo "extern const int kButton_$item;"
done

