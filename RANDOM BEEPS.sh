# beep -f 2200 -l 20  && beep -f 2350 -l 500 && beep -f 2000 -l 250 && beep -f 1780 -l 250 && beep -f 2000 -l 500
# sleep 2

read -p "Enter the time between beeps in ms: " msvalue
echo "Press any key to stop."

while [ "$key" = "" ]; do
    beep -f $(($RANDOM / 10)) -l $msvalue
    read -rsn1 -t 0.00001 key
done
