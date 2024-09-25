#      -+- ClusterScript -+-
#  -+- Rev. 2.4_LINPRERELEASE -+-

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

LowQualitize() {
    DT 2000 2000
    echo "This function is still in beta!"
    mkdir "cluster_result"
    sleep 1
    # the initial 5
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 1k "cluster_result/$1_1kbopus_$RANDOM.ogg"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -c:a libopus -b:a 8k "cluster_result/$1_8kbopus_$RANDOM.ogg"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -b:a 8k -ar 8000 "cluster_result/$1_8kbmp3_$RANDOM.mp3"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -ar 8000 -b:a 1k -acodec libspeex "cluster_result/$1_1kbspeex_$RANDOM.ogg"
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -ar 8000 -b:a 8k -acodec libspeex "cluster_result/$1_8kbspeex_$RANDOM.ogg"

    # 3 bit depth 4192hz and dpcm8192
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" "$1_tmp.wav"
    ./aud2aafc -i "$1_tmp.wav" --bps 3 -ar 4096 # aafc pass 1
    ./aafc2wav "aafc_conversions/$1_tmp.aafc" "cluster_result/$1_3bitdepth4096hz_$RANDOM"
    ./aud2aafc -i "$1_tmp.wav" -n -m --dpcm -ar 8192 # aafc pass 2, OVERWRITE DISTHINGKFXLKZJ
    ./aafc2wav "aafc_conversions/$1_tmp.aafc" "cluster_result/$1_dpcm8192hz_$RANDOM"
    rm "aafc_conversions/$1_tmp.aafc" "$1_tmp.wav"

    # CODify
    ffmpeg -hide_banner -loglevel error -y -i "$1.$2" -ar 8000 -b:a 1k -acodec libspeex "TEMPSPEEX_$1.$2.ogg" # encode to speex for Effect(tm)
    ffmpeg -hide_banner -loglevel error -y -i "TEMPSPEEX_$1.$2.ogg" -c:a libopus -b:a 1k "TEMPOPUS_$1.$2.ogg" # encode that speex with OPUS
    rm "TEMPSPEEX_$1.$2.ogg"
    ffmpeg -hide_banner -loglevel error -y -i "TEMPOPUS_$1.$2.ogg" -filter:a "volume = 35dB" "TEMPLOUD_$1.$2.wav" # make it loud for that COD Quality(tm)
    rm "TEMPOPUS_$1.$2.ogg"
    ffmpeg -hide_banner -loglevel error -y -i "TEMPLOUD_$1.$2.wav"  -c:a libopus -b:a 1k "cluster_result/$1_codlobby_$RANDOM.ogg" # encode it with opus again for that Extra Quality(tm)
    rm "TEMPLOUD_$1.$2.wav"
    AtTheEnd
}

WavConv() {
    DT 2000 2000
    mkdir "cluster_result"
    ffmpeg -hide_banner -loglevel error -i "$1.$2" "cluster_result/$1.wav"
    AtTheEnd
}

OtherFormatConv() {
    DT 2000 2000
    read -p "Enter the extension of the output file: " outextension
    mkdir "cluster_result"
    ffmpeg -hide_banner -loglevel error -i "$1.$2" "cluster_result/$1_converted.$outextension"
    AtTheEnd
}

WhyDidIWriteThis() {
    beep -f 2500 -l 1500 & echo "You are not supposed to be here. How did you get here?"
    sleep 1
    echo "In fact, how did *we* get here at all?"
    sleep 1
    echo "You, the user running this, had to make many miniscule decisions to get to this point in time."
    sleep 1
    echo "I, the developer writing these lines that nobody will likely see, also made tons of miniscule decisions to get here."
    sleep 1
    echo "The countless engineers at IBM had to plan out and design the Personal Computer alongside allowing clones of it."
    sleep 1
    echo "So much had to happen just for your eyes to meet with these words and my hands to type them."
    sleep 2
    echo "Goodbye."
    sleep 3
    exit 1
}


MainAsk() {
    beep -f 2000 -l 150
    read -p "Type the extension of the file: " extension
    beep -f 2500 -l 25
    read -p "Type the name of the file: " infile
    beep -f 2000 -l 50
    read -p "Do you want to convert to WAV? (Y/N) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        WavConv "$infile" "$extension"
    else
        beep -f 2000 -l 50
        read -p "Do you want to convert to a specifiable format? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            OtherFormatConv "$infile" "$extension"
        else
            LowQualitize "$infile" "$extension"
        fi
    fi
}

MainAsk
