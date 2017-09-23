#!/bin/bash

filesToPlot=()
error=false
regexConfigurationDetectionSearch='^(.*/){1}([0-9]{18})_([0-9]+)_([0-9]+)_([0-9]+)\..+$'
regexConfigurationDetection='^(.*/){1}([0-9]{18})_([0-9]+)_([0-9]+)_([0-9]+)$'

while IFS= read -d $'\0' -r file; do
    if [[ -d $file ]]; then
        echo "$file is a directory"
    elif [[ -f $file ]]; then

        if [[ $file == *".txt" ]]; then
            fileToPlot=${file/.txt/}

            if [[ -f "$fileToPlot" ]]; then
                echo "Plot file exists, please delete it if you want to replot the file: $fileToPlot"
            else
                filesToPlot+=("$fileToPlot")
            fi
        fi
    fi
done < <(find plots -regextype posix-extended -regex "${regexConfigurationDetectionSearch}" -type f -print0)

echo  "-------------------------------------------------------"
echo  "-------------------------------------------------------"

if [[ $error == true ]]; then
    echo "Error"
elif (( ${#filesToPlot[@]} >= 1 )); then
    for file in "${filesToPlot[@]}"; do
        if [[ $file =~ $regexConfigurationDetection ]]; then
            echo "Plot configuration found: ${BASH_REMATCH[1]}${BASH_REMATCH[2]}_${BASH_REMATCH[3]}_${BASH_REMATCH[4]}_${BASH_REMATCH[5]}"
            ./mdcct/plotavx2 -k ${BASH_REMATCH[2]} -x 2 -d "${BASH_REMATCH[1]}" -s ${BASH_REMATCH[3]} -n ${BASH_REMATCH[4]} -m ${BASH_REMATCH[5]} -t 2 &
            echo  "-------------------------------------------------------"
        fi
    done
    wait
    echo "Done plotting"
    #for file in "${filesToPlot[@]}"; do
        #if [[ $file =~ $regexConfigurationDetection ]]; then
            #echo "Plot configuration found: ${BASH_REMATCH[1]}${BASH_REMATCH[2]}_${BASH_REMATCH[3]}_${BASH_REMATCH[4]}_${BASH_REMATCH[5]}"
            #./mdcct/optimize "${BASH_REMATCH[1]}${BASH_REMATCH[2]}_${BASH_REMATCH[3]}_${BASH_REMATCH[4]}_${BASH_REMATCH[5]}" -t 2 &
        #fi
    #done
    #wait
    #echo "Done optimizing"
else
    echo "No plot configurations found"
fi