### - Basic Shell Script Template w/License and Colour Formating - CH - September 2020 - ###
### - Intended to be used with selfnamed configuration file for efficiency - ###

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
 
### -  Set up Colours - ###
# Use colours only if connecting to an interactive terminal that supports them 
black='\e[0;30m'
blue='\e[0;34m'
lgt_blue='\e[0;94m'
cyan='\e[0;36m'
lgt_cyan='\e[0;96m'
drk_gray='\e[0;90m'
green='\e[0;32m'
lgt_green='\e[0:92m'
purple='\e[0;35m'
lgt_purple='\e[0;95m'
red='\e[0;31m'
lgt_red='\e[0;91m'
white='\e[0;37m'
yellow='\e[0;33m'
lgt_yellow='\e[0;93m'

### - Set Up Text Formatting Options - ###
t_reset='\e[0m'
t_bold='\e[1m'
t_dim='\e[2m'
t_undlin='\e[4m'
t_blink='\e[5m'
t_invert='\e[7m'

### - Start Configuration Ingestion - ###
# Activities to complete
# Use correct reserved variables
# Access self filename $FILENAME
FILENAME_BEF=${0##*/}
FILENAME=${FILENAME_BEF%.sh}
# Access config file $CFG_FILE
CFG_FILE=${FILENAME}.cfg
# Access log file $LOG_FILE

echo \"${red}${t_bold}🗲Starting Script Name🗲${t_reset}\"
echo "Filename with path" - ${green}${t_bold}$0${t_reset}
echo "Filename with path & without extension" - ${green}${t_bold}${0%.sh}${t_reset}
echo "Filename without path" - ${green}${t_bold}${0##*/}${t_reset}
echo "Filename without path & without extension" - ${green}${t_bold}$FILENAME${t_reset}
echo "Configuration Filename" - ${green}${t_bold}$CFG_FILE${t_reset}
echo \"${red}${t_bold}🏁Finished Daily Update🏁${t_reset}\" 
