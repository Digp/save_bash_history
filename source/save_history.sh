#!/bin/bash


echo Start saving history!

## Define directory to save history
home=HOME_PATH
CLIhist=$home/CLIhistory

## If GoodPractices directory does not exist, create it
if ! [ -d $CLIhist ]; then
    mkdir $CLIhist
fi

## Define function that saves the intended files
function savehist {
    ## Save date and hostname variables
    d=$(date "+%Y-%m-%d")

    ## Save history in appropriate directory
    if [ -f $CLIhist/$d.txt ]; then
        cat $home/.bash_history >> $CLIhist/$d.txt
    else
        cp $home/.bash_history $CLIhist/$d.txt
        sudo chown USER: $CLIhist/$d.txt
    fi
    cat /dev/null > $home/.bash_history
    chmod 600 $CLIhist/$d.txt
}

## Count number of lines in .bash_history
x=$(wc -l $home/.bash_history | awk '{ print $1 }')

## If a minnimum work is detected (10 lines), execute previous function
if [[ $x -gt 10 ]]; then savehist; fi

echo Done!

