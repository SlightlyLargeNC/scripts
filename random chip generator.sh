IFS=$'\n'
warnstart=$(tput setaf 11)
criticalstart=$(tput setaf 1)
ansiend=$(tput sgr0)

generatebasechsc(){
    chipsBase=(
    'Yamaha YM2612 (OPN2)'
    'Yamaha YM2612 (OPN2) Extended Channel 3'
    'Yamaha YM2612 (OPN2) CSM'
    'Yamaha YM2612 (OPN2) with DualPCM'
    'Yamaha YM2612 (OPN2) Extended Channel 3 with DualPCM and CSM'
    'TI SN76489'
    'Game Boy'
    'PC Engine/TurboGrafx-16'
    'NES (Ricoh 2A03)'
    'Commodore 64 (SID 8580)'
    'Commodore 64 (SID 6581)'
    'Yamaha YM2151 (OPM)'
    'SegaPCM'
    'SegaPCM (compatible 5-channel mode)'
    'Neo Geo CD'
    'Neo Geo CD Extended Channel 2'
    'Yamaha YM2610 (OPNB)'
    'Yamaha YM2610 (OPNB) Extended Channel 2'
    'Yamaha YM2610B (OPNB2)'
    'Yamaha YM2610B (OPNB2) Extended Channel 3'
    'T6W28'
    'AY-3-8910'
    'Amiga'
    'PC Speaker'
    'Pokémon Mini'
    'ZX Spectrum Beeper'
    'ZX Spectrum Beeper (QuadTone Engine)'
    'Yamaha YMU759 (MA-2)'
    'Dummy System'
    'tildearrow Sound Unit'
    'Yamaha YM2203 (OPN)'
    'Yamaha YM2203 (OPN) Extended Channel 3'
    'Yamaha YM2608 (OPNA)'
    'Yamaha YM2608 (OPNA) Extended Channel 3'
    'Yamaha YM2413 (OPLL)'
    'Yamaha YM2413 (OPLL) with drums'
    'Konami VRC7'
    'Yamaha Y8950'
    'Yamaha Y8950 with drums'
    'Yamaha YM3812 (OPL2)'
    'Yamaha YM3812 (OPL2) with drums'
    'Yamaha YMF262 (OPL3)'
    'Yamaha YMF262 (OPL3) with drums'
    'Yamaha YM2414 (OPZ)'
    'Atari TIA'
    'Phillips SAA1099'
    'Microchip AY8930'
    'POKEY'
    'Atari Lynx'
    'Capcom QSound'
    'Seta/Allumer X1-010'
    'WonderSwan'
    'Virtual Boy'
    'VERA'
    'Konami Bubble System WSG'
    'Namco 163'
    'Commodore PET'
    'Commodore VIC-20'
    'Konami VRC6'
    'Famicom Disk System (chip)'
    'MMC5'
    'Ensoniq ES5506'
    'Konami SCC'
    'Konami SCC+'
    'Yamaha YMZ280B (PCMD8)'
    'Namco WSG'
    'Namco C15 WSG'
    'Namco C30 WSG'
    'OKI MSM6258'
    'OKI MSM6295'
    'Ricoh RF5C68'
    'SNES'
    'OKI MSM5232'
    'Konami K007232'
    'Irem GA20'
    'Sharp SM8521'
    'Casio PV-1000'
    'Konami K053260'
    'MOS Technology TED'
    'Namco C140'
    'Namco C219'
    'Game Boy Advance DMA Sound'
    'Game Boy Advance MinMod'
    'Generic PCM DAC'
    'ESS ES1xxx series (ESFM)'
    'Pong'
    'PowerNoise'
    'Dave'
    'Nintendo DS'
    '5E01'
    'Bifurcator'
    'SID2'
    'Yamaha YMF278B (OPL4)'
    'Yamaha YMF278B (OPL4) with drums'
    'Watara Supervision'
    'NEC μPD1771C'
    'SID3'
)
}

mainask(){
    trap - SIGINT
    if [[ $wipprompt == 1 ]]; then # leftover from when i had `clear -x` at the start of every menu that i'm too lazy to change
        echo "This is a work in progress!"
        let "wipprompt++"
    fi
    echo    # (optional) move to a new line
    echo "Select a function (Press Q to quit): "
    read -p "Random System (1), Add a chip (2), Remove a chip (3), Delete the chip schema (4), Echo the chip schema (5) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Qq]$ ]]; then
        quitTheProgram
    elif [[ $REPLY == 1 ]]; then
        randsys
    elif [[ $REPLY == 2 ]]; then
        addchip
    elif [[ $REPLY == 3 ]]; then
        removechip
    elif [[ $REPLY == 4 ]]; then
        clearchsc
    elif [[ $REPLY == 5 ]]; then
        echo "$(<.extChipSchema)" # it's literally just one line so it's more work to make an entire function
        mainask
    elif [[ $REPLY =~ ^[Dd]$ ]]; then
        debugmenu
    elif [[ $REPLY =~ ^[Ss]$ ]]; then
        stupidfunctionsmenu
    else
        echo "what in the everfuck"
        mainask
    fi
}

randsys(){
    read -p "Enter the name of your system: " namesys
    read -p "Select how many chips you want: " count
    echo
    if [[ count -ge "1024" ]]; then
        randomglobal=$RANDOM
        echo "${warnstart}Output too large!${ansiend} echoing into file..."
        echo "The $namesys:" >> chipout_$randomglobal.txt
        for ((i=0; i<count; i++)); do # ChatGPT is saving my ass right now lmao
            index=$((RANDOM % ${#chipsBase[@]}))  # Get a random index
            echo "${chipsBase[index]}" >> chipout_$randomglobal.txt             # Echo the random item
        done
        echo "Echoed into \"chipout_$randomglobal.txt\"."
    else
        echo "The $namesys:"
        for ((i=0; i<count; i++)); do # ChatGPT is saving my ass right now lmao
            index=$((RANDOM % ${#chipsBase[@]}))  # Get a random index
            echo "${chipsBase[index]}"             # Echo the random item
        done
    fi
    mainask
}

addchip(){
    read -p "Enter the name of the chip: " addedchip
    echo "$addedchip" >> .extChipSchema
    addtochsc
    mainask
}

removechip(){
    echo "The list of externally added chips is: "
    echo "$(<.extChipSchema)"
    echo    # (optional) move to a new line
    read -p "Type the name of the chip you would like to remove (or press Esc then Enter to leave): " removedchip
    case $REPLY in
        $'\e') mainask
    esac
    sed "/$removedchip/d" .extChipSchema > .tmpfile && mv .tmpfile .extChipSchema
    chipsBase=( ${chipsBase[@]/$removedchip/} )
    mainask
}

clearchsc(){
    read -p "${criticalstart}THIS WILL DELETE THE EXTERNAL CHIP SCHEMA!!${ansiend} Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        read -p "Are you *sure*? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            rm .extChipSchema # delete the external chip schema
            touch .extChipSchema # create a new empty chip schema
            chipsBase=() # delete the chip schema of the current instance
            generatebasechsc # regenerate the chip schema with the base chips
            mainask
        fi
    fi
    mainask
}

debugmenu(){
    echo
    echo "Select a debug function (N to return to the main menu, Q to quit) (Note that the function or purpose of these may not always be clear): "
    read -p "Echo the chip schema (1), Purge the chip schema (2), Test ESC key detection (3), Test quitTheProgram (4) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        mainask
    elif [[ $REPLY =~ ^[Qq]$ ]]; then
        quitTheProgram
    elif [[ $REPLY == 1 ]]; then
        echo "${chipsBase[@]}"
    elif [[ $REPLY == 2 ]]; then
        read -p "${criticalstart}ARE YOU SURE??${ansiend} This will delete EVERY SINGLE CHIP that is currently in this session's schema!! " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "ARE YOU ABSOLUTELY SURE?? Type \"I understand that this will erase the entire schema for this instance of this program.\": " -r
            echo    # (optional) move to a new line
            if [[ $REPLY == "I understand that this will erase the entire schema for this instance of this program." ]]; then
                chipsBase=()
            else
                debugmenu
            fi
        else
            debugmenu
        fi
    elif [[ $REPLY == 3 ]]; then
        read -p "Escape!!" -n 1 -r
        echo
        case $REPLY in
            $'\e') echo "Escaped."; exit 0
        esac
    elif [[ $REPLY == 4 ]]; then
        quitTheProgram
    fi
    debugmenu
}

addtochsc(){
    generatebasechsc
    for line in $(cat .extChipSchema); do
        chipsBase+=("$line")
    done
}

stupidfunctionsmenu(){
    echo
    echo "Welcome to the menu to fuck around and have fun. Enter a number or press N to go back to the main menu."
    echo
    echo "Your options are:"
    echo "Re-echo the ext. chip schema into the current chip instance's schema (causing external chips to show up more often) (1)"
    echo "PLACEHOLDER TEXT HERE (2)"
    read -p "" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY == 1 ]]; then
        read -p "WHAT IS IT THAT YE WISH FOR IN TERMS OF NUMERICS? " whatsit
        for ((i=0; i<whatsit; i++)); do
            for line in $(cat .extChipSchema); do
                chipsBase+=("$line")
            done
        done
    elif [[ $REPLY == 2 ]]; then
        echo "Place holded."
        stupidfunctionsmenu
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        mainask
    fi
    stupidfunctionsmenu
}

quitTheProgram(){
    echo "Exiting..."
    sleep 0.2
    clear -x
    exit 0
}

# template code:
bp_genericmenuDONOTCALL(){
    read -p "PLACEHOLDER (1) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY == 1 ]]; then
        echo "what in the everfuck"
    fi
}


generatebasechsc
for line in $(cat .extChipSchema); do
    chipsBase+=("$line")
done

if [[ -e .extChipSchema ]]; then
    wipprompt=1
    clear -x
    mainask
else
    trap "" SIGINT # we don't want the user exiting here in the extremely rare chance that they accidentally exit while the file is being created
    echo "External chip schema not detected, creating..."
    touch .extChipSchema
    wipprompt=1
    sleep 1
    clear -x
    mainask
fi
