name=$1
out=$(objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')
echo "---------- opcodes -------"
echo "$out"
echo "--------------------------"
if [[ $out  =~ "\x00" ]]
then 
    echo "attention, null byte found:"
    echo $out | grep --color=auto "\x00" 
    echo "--------"
    objdump -D $1 -M intel | grep 00
    echo "--------"
fi
if [[ $out  =~ "\x0a" ]]
then 
    echo "attention, new line byte found:"
    echo $out | grep --color=auto "\x0a" 
    echo "--------"
    objdump -D $1 -M intel | grep 0a
    echo "--------"
fi

