AT() { # Attention Tone
    beep -f 2200 -l $1
}

DT() { # Double attention Tone
    beep -f $1 -l 50
    sleep 0.05
    beep -f $2 -l 50
}

Bopus() {
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 1k "cluster_result/$1_One Thousand Bopus_$RANDOM.opus"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 8k "cluster_result/$1_Eight Thousand Bopus_$RANDOM.opus"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 16k "cluster_result/$1_Sixteen Thousand Bopus_$RANDOM.opus"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 32k "cluster_result/$1_Thirty-Two Thousand Bopus_$RANDOM.opus"
    AtTheEnd
}

MainAsk() {
    beep -f 2000 -l 150
    read -p "Type the name of the file: " file
    infile="${file%.*}" # credit to Architect for these lines
    extension="${file##*.}" # credit to Architect for these lines
    beep -f 2000 -l 50
    echo "Select a function:"
    echo "Bopus (1)"
    read -p "" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY == "1" ]]; then
        Bopus "$infile" "$extension"
    fi
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

MainAsk
