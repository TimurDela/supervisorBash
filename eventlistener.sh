#go to ready state
echo "READY"
read -r -a header # read event header as an array
for item in "${header[@]}"
do
    sep=$((`expr match "$item" 'len:'`))
    if (( $sep > 0 ))
    then
        break
    fi
done
>&2 echo "Incoming REMOTE_COMMUNICATION: ${item:$sep} characters will be read" # Print PAYLOAD_LENGTH to stderr
read -N ${item:$sep} -r msg # read the entire event message (including line break)
sep=$((`expr index "$msg" $"\r"`)) # find line break index
if (( $sep > 0 ));
then
    type=${msg:5:$sep-5} #store event type in $type
    data=${msg:$sep+1} #store event data in $data
    >&2 echo "$type -- data:$data" # print message content to stderr
    echo "RESULT 2" 
    echo "OK" # do not use \n here even with $''
else
    echo "RESULT 4"
    echo "FAIL" # do not use \n here even with $''
fi
echo "READY"
