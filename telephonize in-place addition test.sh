AT() { # Attention Tone
    beep -f 2200 -l $1
}

DT() { # Double attention Tone
    beep -f $1 -l 50
    sleep 0.05
    beep -f $2 -l 50
}

AtTheEnd() { # it seems to not matter
    AT 300
    read -p "Do you want to convert another file? (Y/N) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        MainAsk
    else
        beep -f 2000 -l 175
        exit 1
    fi
}

Telephonize(){
    DT 2000 2200 # rising dual attention tone
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 8k "TEMPOPUS_$1.$2.ogg" # encode to Eight Thousand Bopus
    ffmpeg -hide_banner -loglevel error -y -i "TEMPOPUS_$1.$2.ogg" -filter:a "volume = 35dB" "TEMPLOUD_$1.$2.wav" # make it loud
    rm "TEMPOPUS_$1.$2.ogg" # remove the of 8kbopus
    ffmpeg -hide_banner -loglevel error -y -i "TEMPLOUD_$1.$2.wav" -c:a libopus -b:a 8k "TEMPOPUS2_$1.$2.ogg" # encode it yet again into Eight Thousand Bopus
    rm "TEMPLOUD_$1.$2.wav" # remove the loud
    ffmpeg -hide_banner -loglevel error -y -i "TEMPOPUS2_$1.$2.ogg" -filter:a "volume = 32dB" "TEMPLOUD2_$1.$2.wav" # make it loud again
    rm "TEMPOPUS2_$1.$2.ogg" # remove the 2rd iteration of 8kbopus
    ffmpeg -hide_banner -loglevel error -y -i "TEMPLOUD2_$1.$2.wav" -c:a libopus -b:a 8k "cluster_result/$1 but it's being shouted at you through a telephone_$RANDOM.opus"
    rm "TEMPLOUD2_$1.$2.wav"
    AtTheEnd # exit out of this clusterfuck
}

MainAsk() {
    beep -f 2000 -l 150
    read -p "Type the name of the file: " file
    infile="${file%.*}" # credit to Architect for these lines
    extension="${file##*.}" # credit to Architect for these lines
    beep -f 2000 -l 50
    echo "Select a function:"
    echo "Telephonize (1)"
    read -p "" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY == "1" ]]; then
        Telephonize "$infile" "$extension"
    fi
}

MainAsk
