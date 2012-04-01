count=0
for item in $(cat FunctionMap)
do
	echo "const int kFunction_$item = $count;"
	count=$(($count+1))
done 
for item in $(cat FunctionMap)
do
	echo "extern int kFunction_$item;"
done
for item in $(cat FunctionMap)
do
	echo "case kFunction_$item:"
	echo "	return @\"$item\";"
done

