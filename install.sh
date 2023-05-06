#!/bin/bash

EXECUTION_PATH='/usr/local/bin'
USER=$(whoami)
cd ~/
HOME_PATH=$(pwd)
cd -

if [ ! $(grep '\-save_history_installed$' ~/.bashrc | wc -l) -gt 0 ]; then 

    ## Prepare service file
    sed -i.bak 's|EXECUTION_PATH|'"$EXECUTION_PATH"'|g' save_history.service
    sed -i.bak 's|HOME_PATH|'"$HOME_PATH"'|g' save_history.sh
    sed -i 's|USER|'"$USER"'|g' save_history.sh

    ## Save execution script in selected path
    sudo cp save_history.sh $EXECUTION_PATH

    ## Save service file in /etc/systemd/system/
    sudo cp save_history.service /etc/systemd/system/
    
    ## Insert artificial line into .bash_history every time a terminal is initiated
    echo '' >> ~/.bashrc
    echo '# Execute command to see in ~/.bash_history how many terminals are opened during the day -save_history_installed' >> ~/.bashrc
    echo 'echo "#NEW TERMINAL" $(tty) $(date) $(hostname) $(pwd) >> ~/.bash_history # -save_history_installed' >> ~/.bashrc
    echo '' >> ~/.bashrc

    ## Append all the commands to ~/.bash_history real-time
    echo '' >> ~/.bashrc
    echo '# Append all the commands from different terminals to ~/.bash_history real-time -save_history_installed' >> ~/.bashrc
    echo "export PROMPT_COMMAND='history -a' # -save_history_installed" >> ~/.bashrc
    echo '' >> ~/.bashrc

    ## Remove current parameters HISTSIZE and HISTFILESIZE
    sed -i '/^HISTSIZE=/d' ~/.bashrc
    sed -i '/^HISTFILESIZE=/d' ~/.bashrc

    ## Set new values for history lenght and size
    echo '' >> ~/.bashrc
    echo "# Set history length with HISTSIZE and HISTFILESIZE -save_history_installed" >> ~/.bashrc
    echo "HISTSIZE=100000" >> ~/.bashrc
    echo "HISTFILESIZE=200000" >> ~/.bashrc
    echo '' >> ~/.bashrc

    ## Activate service
    sudo systemctl enable save_history.service
    sudo systemctl start save_history.service
    #sudo systemctl status save_history.service
    #sudo systemctl stop save_history.service
    #sudo systemctl daemon-reload
    #sudo journalctl -u save_history.service


    # Create a temporary file for the crontab
    CRONTAB_FILE=$(mktemp)
    
    # Add the cron job to the file
    echo "55 23 * * * /bin/bash "$EXECUTION_PATH"/save_history.sh" >> "$CRONTAB_FILE"
    
    # Install the crontab 
    crontab $CRONTAB_FILE
    
    # Remove the temporary file
    rm -f $CRONTAB_FILE

fi
