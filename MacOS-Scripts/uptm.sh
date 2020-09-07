###- MacOS console excerpt to track Timemachine Backups - CH - May-2019 ###

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### - Set up Colours - ###
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  MAGENTA="$(tput setaf 5)"
  CYAN="$(tput setaf 6)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  MAGENTA=""
  CYAN=""
  BOLD=""
  NORMAL=""
fi

### - Set up Functions - ###
### - Function to categorise bytes by size - ###
### - Bytes Length: (7<=KB, 9=MB, 10>=GB)
sort_bytes ()
{
#echo Hello I am sort_bytes
### - Sort out current bytes copied - ###
### - Set up flag variables - ###
tm_bytes_kb=false
tm_bytes_mb=false
tm_bytes_gb=false
tm_totalBytes_mb=false
tm_totalBytes_gb=false

  if [[ ! -z "$tm_bytes" ]]; then
    #echo Bytes Length ${#tm_bytes}
    tm_bytes_length=${#tm_bytes}
    if (( ${tm_bytes_length} < 5 )); then
      #echo Bytes Length ${#tm_bytes} is less than 7 so units is KB
      tm_bytes_kb=true
      tm_bytes_trimmed=${tm_bytes:0:1}
    elif (( ${tm_bytes_length} >= 5 && ${tm_bytes_length} < 6 )); then
      #echo Bytes Length ${#tm_bytes} is less than 7 so units is KB
      tm_bytes_kb=true
      tm_bytes_trimmed=${tm_bytes:0:2}
    elif (( ${tm_bytes_length} >= 6 && ${tm_bytes_length} < 7 )); then
      #echo Bytes Length ${#tm_bytes} is less than 7 so units is KB
      tm_bytes_kb=true
      tm_bytes_trimmed=${tm_bytes:0:3}
    elif (( ${tm_bytes_length} >= 7 && ${tm_bytes_length} < 10 )); then
      #echo Bytes Length ${#tm_bytes} is between 7-10 so units is MB
      tm_bytes_mb=true
      if [[ ${tm_bytes_length} == "7" ]]; then
        #echo Bytes Length ${#tm_bytes} is 7 so units is MB
        tm_bytes_trimmed=${tm_bytes:0:3}
        tm_bytes_trimmed_first=${tm_bytes:0:1}
        tm_bytes_trimmed_last=${tm_bytes:1:2}
      elif [[ ${tm_bytes_length} == "8" ]]; then
        #echo Bytes Length ${#tm_bytes} is 8 so units is MB
        tm_bytes_trimmed=${tm_bytes:0:3}
        tm_bytes_trimmed_first=${tm_bytes:0:2}
        tm_bytes_trimmed_last=${tm_bytes:2:1}
     elif [[ ${tm_bytes_length} == "9" ]]; then
       #echo Bytes Length ${#tm_bytes} is 9 so units is MB
        tm_bytes_trimmed=${tm_bytes:0:4}
        tm_bytes_trimmed_first=${tm_bytes:0:3}
        tm_bytes_trimmed_last=${tm_bytes:3:1}
     fi
      tm_bytes_trimmed=$"$tm_bytes_trimmed_first.$tm_bytes_trimmed_last";
      #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} MB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
    elif (( ${tm_bytes_length} >= 10 && ${tm_bytes_length} < 11 )); then
      #echo Bytes Length ${#tm_bytes} is between 10-12 so units is GB
      tm_bytes_gb=true
      tm_bytes_trimmed=${tm_bytes:0:3}
      tm_bytes_trimmed_first=${tm_bytes:0:1}
      tm_bytes_trimmed_last=${tm_bytes:1:2}
      tm_bytes_trimmed=$"$tm_bytes_trimmed_first.$tm_bytes_trimmed_last";
      #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
    elif (( ${tm_bytes_length} >= 11 && ${tm_bytes_length} < 12 )); then
      #echo Bytes Length ${#tm_bytes} is between 12-14 so units is GB
      tm_bytes_gb=true
      tm_bytes_trimmed=${tm_bytes:0:4}
      tm_bytes_trimmed_first=${tm_bytes:0:2}
      tm_bytes_trimmed_last=${tm_bytes:2:2}
      tm_bytes_trimmed=$"$tm_bytes_trimmed_first.$tm_bytes_trimmed_last";
      #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
    elif (( ${tm_bytes_length} >= 12 && ${tm_bytes_length} < 14 )); then
      #echo Bytes Length ${#tm_bytes} is between 12-14 so units is GB
      tm_bytes_gb=true
      tm_bytes_trimmed=${tm_bytes:0:5}
      tm_bytes_trimmed_first=${tm_bytes:0:3}
      tm_bytes_trimmed_last=${tm_bytes:3:2}
      tm_bytes_trimmed=$"$tm_bytes_trimmed_first.$tm_bytes_trimmed_last";
      #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
    fi
  fi
  ### - Sort out totalBytes target - ###
    if [[ ! -z "$tm_totalBytes" ]]; then
      #echo Bytes Length ${#tm_bytes}
      tm_totalBytes_length=${#tm_totalBytes}
      if (( ${tm_totalBytes_length} >= 7 && ${tm_totalBytes_length} < 10 )); then
        #echo Bytes Length ${#tm_totalBytes} is between 7-10 so units is MB
        tm_totalBytes_mb=true
        tm_totalBytes_trimmed=${tm_totalBytes:0:4}
        tm_totalBytes_trimmed_first=${tm_totalBytes:0:3}
        tm_totalBytes_trimmed_last=${tm_totalBytes:3:1}
        tm_totalBytes_trimmed=$"$tm_totalBytes_trimmed_first.$tm_totalBytes_trimmed_last";
        #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} MB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
      elif (( ${tm_totalBytes_length} >= 10 && ${tm_totalBytes_length} < 11 )); then
        #echo Bytes Length ${#tm_totalBytes} is between 10-11 so units is GB
        tm_totalBytes_gb=true
        tm_totalBytes_trimmed=${tm_totalBytes:0:3}
        tm_totalBytes_trimmed_first=${tm_totalBytes:0:1}
        tm_totalBytes_trimmed_last=${tm_totalBytes:1:2}
        tm_totalBytes_trimmed=$"$tm_totalBytes_trimmed_first.$tm_totalBytes_trimmed_last";
        #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
      elif (( ${tm_totalBytes_length} >= 11 && ${tm_totalBytes_length} < 12 )); then
        #echo Bytes Length ${#tm_totalBytes} is between 11-12 so units is GB
        tm_totalBytes_gb=true
        tm_totalBytes_trimmed=${tm_totalBytes:0:4}
        tm_totalBytes_trimmed_first=${tm_totalBytes:0:2}
        tm_totalBytes_trimmed_last=${tm_totalBytes:2:2}
        tm_totalBytes_trimmed=$"$tm_totalBytes_trimmed_first.$tm_totalBytes_trimmed_last";
        #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
      elif (( ${tm_totalBytes_length} >= 12 && ${tm_totalBytes_length} < 14 )); then
       #echo Bytes Length ${#tm_totalBytes} is between 12-14 so units is GB
       tm_totalBytes_gb=true
       tm_totalBytes_trimmed=${tm_totalBytes:0:5}
       tm_totalBytes_trimmed_first=${tm_totalBytes:0:3}
       tm_totalBytes_trimmed_last=${tm_totalBytes:3:2}
       tm_totalBytes_trimmed=$"$tm_totalBytes_trimmed_first.$tm_totalBytes_trimmed_last";
       #echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes}, ${tm_files} of ${tm_totalFiles} items"
     fi
   fi

    ### - Select correction size statement to echo out - ###
    ### - 2 tm_bytes states with tm_totalBytes as MB - ###
    ### - 3 tm_bytes states with tm_totalBytes as GB - ###
    if [[ "$tm_bytes_kb" == "true" ]] && [[ "$tm_totalBytes_mb" == "true"  ]]; then ### - bytes is KB totalBytes is MB - ###
      echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${GREEN}Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} KB of ${tm_totalBytes_trimmed} MB, ${tm_files} of ${tm_totalFiles} items, ${tm_backup_phase_percentage}% completed${NORMAL}"
    elif [[ "$tm_bytes_mb" == "true" ]] && [[ "$tm_totalBytes_mb" == "true"  ]]; then ### - bytes is MB totalBytes is MB - ###
      echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${GREEN}Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} MB of ${tm_totalBytes_trimmed} MB, ${tm_files} of ${tm_totalFiles} items, ${tm_backup_phase_percentage}% completed${NORMAL}"
    elif [[ "$tm_bytes_kb" == "true" ]] && [[ "$tm_totalBytes_gb" == "true"  ]]; then ### - bytes is KB totalBytes is GB - ###
      echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${GREEN}Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} KB of ${tm_totalBytes_trimmed} GB, ${tm_files} of ${tm_totalFiles} items, ${tm_backup_phase_percentage}% completed${NORMAL}"
    elif [[ "$tm_bytes_mb" == "true" ]] && [[ "$tm_totalBytes_gb" == "true"  ]]; then ### - bytes is MB totalBytes is GB - ###
      echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${GREEN}Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} MB of ${tm_totalBytes_trimmed} GB, ${tm_files} of ${tm_totalFiles} items, ${tm_backup_phase_percentage}% completed${NORMAL}"
    elif [[ "$tm_bytes_gb" == "true" ]] && [[ "$tm_totalBytes_gb" == "true"  ]]; then ### - bytes is GB totalBytes is GB - ###
      echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${GREEN}Currently ${tm_backup_phase_output}: ${tm_bytes_trimmed} GB of ${tm_totalBytes_trimmed} GB, ${tm_files} of ${tm_totalFiles} items, ${tm_backup_phase_percentage}% completed${NORMAL}"
    fi
}

### - Functon to sort through log error output - ###
sort_errors ()
{
  #echo Hello I am sort_error
  ### - Check log error output for Copy or Fatal errors - ###
  ### - Set up internal functions - ###
  count_copy_stage() {
  grep -c "Copy stage" ${HOME}/tmp/uptmerr2.tmp
  }
  count_failed_to() {
  grep -c "Failed to" ${HOME}/tmp/uptmerr2.tmp
}

  if [[ -s ${HOME}/tmp/uptmerr2.tmp ]]; then
  #echo "${this_time} (TimeMachine)  uptmerr2 is not empty" ### - carry out further analysis
    if grep -q "Copy stage" ${HOME}/tmp/uptmerr2.tmp; then
      [ $? -eq 0 ] && echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${RED}Error output contained a 'Copy stage' error $(count_copy_stage) times, see: ${BLUE}${HOME}/tmp/uptmerrref.txt${NORMAL}"
    fi
    if grep -q "Failed to" ${HOME}/tmp/uptmerr2.tmp; then
      [ $? -eq 0 ] && echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${MAGENTA}Error output contained 'Failed to' error $(count_failed_to) times, see: ${BLUE}${HOME}/tmp/uptmerrref.txt${NORMAL}"
    fi
  else
  echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${BLUE}Currently no errors to report${NORMAL}"
  fi
}

### - Functon to sort percentage size - ###
sort_percent ()
{
  #echo Hello I am sort_percent
  if [[ ! -z "$tm_backup_phase_progress" ]]; then
    #echo "Initial captured percent variable: ${tm_backup_phase_progress}"
    #echo Processing percent variable
    tm_backup_phase_progress=`echo ${tm_backup_phase_progress} | tr -d "\n"`
    tm_backup_phase_progress=${tm_backup_phase_progress%%\"\"*}
    tm_backup_phase_progress=(${tm_backup_phase_progress})
    #echo "Processed percent variable: ${tm_backup_phase_progress}"
    #echo Percent Length ${#tm_backup_phase_progress}
    if [[ $tm_backup_phase_progress == *"e-"* ]]; then ###- check if percentage is less than 1 % - ###
      #echo "${this_time} (TimeMachine)  Currently less than 1% complete, updating ${tm_backup_phase_percentage}"
      tm_backup_phase_percentage=0.00
      #echo "${this_time} (TimeMachine)  Updated percentage completed: ${tm_backup_phase_percentage}%"
    elif [ "${#tm_backup_phase_progress}" -eq 1 ]; then
        percentage_first=${tm_backup_phase_progress:0:1}
        #echo "percentage_first_check = ${percentage_first_check}"
          if [[ "$percentage_first" = "1" ]]; then
          percentage_last=00
          fi
        #echo "percentage_first-2 = ${percentage_first}"
        tm_backup_phase_percentage=$"$percentage_first$percentage_last";
     elif [ "${#tm_backup_phase_progress}" -ge 1 ]; then
        tm_backup_phase_percentage=${tm_backup_phase_progress:1:5}
        #echo "${this_time} (TimeMachine)  Trimmed percent completed: ${tm_backup_phase_percentage}%" >> ${HOME}/tmp/uptmref.txt
        percentage_first=${tm_backup_phase_percentage:2:2}
        #echo "percentage_first-1 = ${percentage_first}"
        percentage_first_check=${percentage_first:0:1}
        #echo "percentage_first_check = ${percentage_first_check}"
          if [[ "$percentage_first_check" = "0" ]]; then
            percentage_first=${percentage_first:1:1}
          fi
        #echo "percentage_first-2 = ${percentage_first}"
        percentage_last=${tm_backup_phase_percentage:4:1}
        tm_backup_phase_percentage=$"$percentage_first.$percentage_last";
    fi
  fi
}

### - Main section of script - ###
### - Check working directory exists and clean out previous temporary files - ###
if [[ -d ${HOME}/tmp/ ]]; then
    #echo "Working directory: ${BLUE}${HOME}/tmp/${NORMAL} exists script continuing and cleaning out previous temporary files"
    rm -f ${HOME}/tmp/up*
  else
    echo "${RED}Error: ${HOME}/tmp/ does not exist - please add so script can run correctly - script exiting${NORMAL}"
    exit -1
fi


### - Overwrite latest console excerpt for Timemachine Backups to txt files - ###
log show --predicate '(subsystem == "com.apple.TimeMachine") && (category == "TMLogInfo")' --info --last 1h > ${HOME}/tmp/uptminf.txt
log show --predicate '(subsystem == "com.apple.TimeMachine") && (category == "TMLogError")' --info --last 1h > ${HOME}/tmp/uptmerr.txt

### - Read through files and manipulate as necessary - ###
awk '{ print($1,substr($2,0,6), substr($9,1,1)"\033[33m"substr($9,2,11)"\033[m"substr($9,13,1)); }' ${HOME}/tmp/uptminf.txt > ${HOME}/tmp/uptminf1.tmp ### - gets timestamp info from log info output - ###
awk '{ print($1,substr($2,0,6), substr($9,1,1)"\033[33m"substr($9,2,11)"\033[m"substr($9,13,1)); }' ${HOME}/tmp/uptmerr.txt > ${HOME}/tmp/uptmerr1.tmp ### - gets timestamp info from log error output - ###
awk -F\] '$0=$2' ${HOME}/tmp/uptminf.txt > ${HOME}/tmp/uptminf2.tmp ### - get log activity from log info output - ###
awk -F\] '$0=$2' ${HOME}/tmp/uptmerr.txt > ${HOME}/tmp/uptmerr2.tmp ### - get log activity from log error output - ###
### - uses ed to remove unnecessary characters from each line, and outputs log info & log error into separate readable files - ###
if [[ -s ${HOME}/tmp/uptminf2.tmp ]]; then
ed -s ${HOME}/tmp/uptminf2.tmp <<< $'1i\n Timemachine Output\n.\nwq'
paste ${HOME}/tmp/uptminf1.tmp ${HOME}/tmp/uptminf2.tmp > ${HOME}/tmp/uptminfref.txt
fi
if [[ -s ${HOME}/tmp/uptmerr2.tmp ]]; then
ed -s ${HOME}/tmp/uptmerr2.tmp <<< $'1i\n Timemachine Output\n.\nwq'
paste ${HOME}/tmp/uptmerr1.tmp ${HOME}/tmp/uptmerr2.tmp > ${HOME}/tmp/uptmerrref.txt
fi

### - If Timemachine is active print out percentage completed else current backup phase - ###
### - Set up TimeMachine variables - ###
this_time=$(date +"%F %H:%M:")
tm_backup_phase_output=$(tmutil status | awk '/BackupPhase/{print $3}' | tr -d ";")
tm_bytes=$(tmutil status | awk '/bytes/{print $3}' | tr -d ";")
tm_files=$(tmutil status | awk '/files/{print $3}' | tr -d ";")
tm_totalBytes=$(tmutil status | awk '/totalBytes /{print $3}' | tr -d ";")
tm_totalFiles=$(tmutil status | awk '/totalFiles/{print $3}' | tr -d ";")
tm_setting=$(defaults read /Library/Preferences/com.apple.TimeMachine | awk '/AutoBackup/{print $3}' | tr -d ";")
tm_state=$(tmutil status | awk '/Running/{print $3}' | tr -d ";")

if [[ "$tm_state" = "1" ]] && [[ "$tm_backup_phase_output" == *"Copying"*  ]]; then ### - only continue backup is active - ###
##tm_backup_phase_progress=$(tmutil status | awk '/_raw_Percent/{print $3}' | tr -d ";")
tm_backup_phase_progress=$(tmutil status | awk '/Percent/{print $3}' | tr -d ";")
### - Call to sort_percent, sort_errors and sort_bytes functions here and append to log info output file - ###
sort_percent >> ${HOME}/tmp/uptminfref.txt
sort_errors >> ${HOME}/tmp/uptminfref.txt
sort_bytes >> ${HOME}/tmp/uptminfref.txt

#echo "***- New Stuff -***" >> ${HOME}/tmp/uptmref.txt
#echo "${this_time} (TimeMachine)  Currently ${tm_backup_phase_output}: bytes copied: ${tm_bytes} of ${tm_totalBytes}" >> ${HOME}/tmp/uptmref.txt
#echo "***- End of New Stuff -***" >> ${HOME}/tmp/uptmref.txt
else
  if [[ ! -z "$tm_backup_phase_output" ]]; then ### - test if TimeMachine is no longer active - ###
  sort_errors >> ${HOME}/tmp/uptminfref.txt
  echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  Current active phase is ${GREEN}${tm_backup_phase_output}${NORMAL}" >> ${HOME}/tmp/uptminfref.txt
  else
  sort_errors >> ${HOME}/tmp/uptminfref.txt
  echo "${this_time} (${YELLOW}TimeMachine${NORMAL})  ${BLUE}Currently not active${NORMAL}" >> ${HOME}/tmp/uptminfref.txt
  fi
fi
### - Cat out refined uptmref.txt - ###
cat ${HOME}/tmp/uptminfref.txt
