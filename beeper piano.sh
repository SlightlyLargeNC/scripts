#          -+- Beeper Piano -+-
#           -+- Ver. 0.1.1 -+-
#  Contains some of the worst code written.

read -p "Enter beep length (ms, shorter values will beep shorter but allow notes to be played faster): " i
echo "keyboard range is from Z to I"
echo "preset kick, snare, and \"\"hihat\"\" sounds are mapped to 1, 4, and 8 respectively"
echo "i have no fuckin idea how to make this thing quit so just make sure no beeps are playing then press ^C"

b() { # just to make typing this script shorter
    beep -f $1 -l $i
}

intkick() {
    beep -f 1000 -l 10
    beep -f 700 -l 10
    beep -f 500 -l 10
}

intsnare() {
    beep -f 2700 -l 5
    beep -f 1800 -l 10
    beep -f 2200 -l 5
    beep -f 1100 -l 10
}


while true; do
    read -rsn1 -t 0.00001 k
    if [[ $k == "q" ]] || [[ $k == "," ]]; then
        b 2093
    elif [[ $k == "2" ]] || [[ $k == "l" ]]; then
        b 2217
    elif [[ $k == "w" ]] || [[ $k == "." ]]; then
        b 2349
    elif [[ $k == "3" ]] || [[ $k == ";" ]]; then
        b 2489
    elif [[ $k == "e" ]] || [[ $k == "/" ]]; then
        b 2637
    elif [[ $k == "r" ]] || [[ $k == "'" ]]; then
        b 2794
    elif [[ $k == "5" ]]; then
        b 2960
    elif [[ $k == "t" ]]; then
        b 3136
    elif [[ $k == "6" ]]; then
        b 3322
    elif [[ $k == "y" ]]; then
        b 3520
    elif [[ $k == "7" ]]; then
        b 3729
    elif [[ $k == "u" ]]; then
        b 3951
    elif [[ $k == "i" ]]; then
        b 4186
    elif [[ $k == "z" ]]; then
        b 1047
    elif [[ $k == "s" ]]; then
        b 1109
    elif [[ $k == "x" ]]; then
        b 1175
    elif [[ $k == "d" ]]; then
        b 1245
    elif [[ $k == "c" ]]; then
        b 1319
    elif [[ $k == "v" ]]; then
        b 1397
    elif [[ $k == "g" ]]; then
        b 1480
    elif [[ $k == "b" ]]; then
        b 1568
    elif [[ $k == "h" ]]; then
        b 1661
    elif [[ $k == "n" ]]; then
        b 1760
    elif [[ $k == "j" ]]; then
        b 1865
    elif [[ $k == "m" ]]; then
        b 1976
    elif [[ $k == "1" ]]; then
        intkick
    elif [[ $k == "4" ]]; then
        intsnare
    elif [[ $k == "8" ]]; then
        beep -f 2600 -l 2
    fi
done
