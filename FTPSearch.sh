#!/bin/bash
#in this code I tried to make a search engine for FTP server.
# as you may know it is do hard to find out a subject that you are looking for there for using a code like this will be so helpful
# there are ways that you can go on to be able to sereach in FTP as a file there for you must first make a shadow of FTP in your linux invoirnment. I there use to mount FTP as a file in my \mnt file.

#for colors
RED='\033[0;31m'
NC='\033[0m'

cat << EOF


 .;'                     ,;,    
 .;'  ,;'             ,;,  ,;,   Welcome to FTPSearch!
.;'  ,;'  ,;'     ;,  ,;,  ,;,  
::   ::   :   ( )   :   ::   ::  Simple search engine with REGEX support
':.  ':.  ':. /_\ ,:'  ,:'  ,:'  
 ':.  ':.    /___\    ,:'  ,:'   designed for Linux by Navid Malek and Tina Salehi
  ':.       /_____\      ,:'     navidmalekedu@gmail.com
           /       \       	 navidmalek.blog.ir


EOF



# For adding program to bash shell we can use bellow code:
if [ ! -f /usr/bin/FTPSearch ]; 
then
   sudo cp ./FTPSearch.sh /usr/bin/FTPSearch
   echo -e "> ${RED}Added to Bash shell${NC}" 
fi



# here I made a man page for my bashscript and this means that you can run this code just by calling its name in terminal.

if [ ! -f /usr/share/man/man1/FTPSearch.1.gz ];
then
	sudo cp ./FTPSearch-manpage /usr/share/man/man1/FTPSearch.1
	sudo gzip /usr/share/man/man1/FTPSearch.1
	echo -e "> ${RED} Now you can use your manpage too! ${NC}"
fi


#control if user exits by ctrl+c
trap trap_handler INT

function trap_handler() {
	echo ""
        echo -e "> ${RED}cleaning up...${NC}"
	if [ -d "/mnt/FTPSearch" ]; then
		cd
  	 	sudo umount /mnt/FTPSearch/
	 	sudo rm -rf /mnt/FTPSearch/
	fi
		echo "> bye!"
		sleep 1
		exit
}

# This is the mounter function it mounts the url of the FTP that was given as input 
mounter(){

# check if curlftpfs is installed or not
if [ $(dpkg-query -W -f='${Status}' curlftpfs 2>/dev/null | grep -c "ok installed") -eq 0 ]
then
	apt-get install curlftpfs
fi
sudo mkdir -p /mnt/FTPSearch


echo "> Just a moment please..."
echo -e "> What is the ${RED}FTP url${NC} you wish to search in?"
read herurl

sudo curlftpfs -o allow_other $herurl /mnt/FTPSearch

while [ $? -ne 0 ]
do 
	echo -e "> ${RED}OOPS!${NC}"
	echo -e "> What is the ${RED}FTP url${NC} you wish to search in?"
	read herurl
	sudo curlftpfs -o allow_other $herurl /mnt/FTPSearch
done

echo "> Success! connected to the ftp"
cd /mnt/FTPSearch


# Connected to FTP URl 
echo -e "> Now that you are connected to your url \n> type ${RED}help${NC} to get the list of commands!"

commander
}

# This function is the function that has all the code related to the commands that user is going to give.
commander(){

#here I ask the user what her command is. and command can be help, ls, cd, and ... and must of them work as the normal
echo "> what is your comand ?"

while [ true ] 
do  
read comnd
her_command=$(echo $comnd | cut -d' ' -f 1)  

# ls command	
if [ $her_command = ls ]
then
	
	$comnd --color

# cd command
elif [ $her_command = cd ]
then
	#control the cd command, can't go anywhere you like!
	PREVDIR="$(pwd)"
	$comnd
	CURRENTDIR="$(pwd)"
	CTRL=0
	if [[ $CURRENTDIR != /mnt/FTPSearch* ]] 
		then
			cd $PREVDIR
			echo -e "> ${RED}can't go there, stay in the FTP!${NC}"
			echo -e "> inorder to go to the home directory type: ${RED}cd /mnt/FTPSearch${NC}"
			CTRL=1
	fi	
	if [ $CTRL -eq "0" ] 
		then
		echo "> changed directory!"
	fi	
	
# exit the code by command exit	
elif [ $her_command = exit ]
then 
	echo "> Good luck ;)"
	cd
	sudo umount /mnt/FTPSearch/
	sudo rm -rf /mnt/FTPSearch/
	exit
	
# cleanup command which will clean all the folders that you made
elif [ $her_command = cleanup ]
then
	echo -e "${RED}cleaning up...${NC}"
	cd
	sudo umount /mnt/FTPSearch/
	sudo rm -rf /mnt/FTPSearch/
	mounter
	break

# help command that shows every thing about commands
elif [ $her_command = help ]
then 
	echo -e "> ls [UNIX_ls_ARGUMENTS]: UNIX ls with all supported options of your current ls app installed on your system\n
> cd [UNIX_cd_ARGUMENTS]: UNIX cd with all supported options of your current cd app installed on your system\n
> search [OPTIONS] "REGEX": search with desired option in the current directory with the REGEX entered\n
> if REGEX is null, it will be like simple ls commands\n
>	OPTIONS => -R : means in current and all sub directories\n
>	OPTIONS => -C : means in current directory only\n
>	OPTIONS => not specified : works like -R\n
> dl ABSOLOUTE_PATH_TO_DESIRED_FILE ABSOLOUTE_PATH_TO_LOCAL_DESTINATION\n
> cleanup : disconnects all the created connections to FTP server and reverts any other changes that program did and \n> returns to the beginning of app\n> exit : exits the program and cleanup\n> help : shows this screen"

# dl command for download the part you wish from FTP
elif [ $her_command = dl ]
then
	echo -e "> download started ...\n"
	echo "> wait till i say Done"
	cp /mnt/FTPSearch$(echo $comnd | cut -d' ' -f 2) $(echo $comnd | cut -d' ' -f 3)
	echo -e ">${RED} Done!${NC}"
	
#search command is the actual part of code:
elif [ $her_command = search ]
then
	#here we seprate the different part of the input and based on what user 
	#we will search:	
	sep_comnd=$(echo $comnd | cut -d ' ' -f 2)
	reg=$(echo $comnd | cut -d ' ' -f 3)
	type=$(echo $sep_comnd | head -c 1)
	
	if [ $type = "-" ]
	then
		if [ ${sep_comnd} = "-R" ]
		then
			if [ -z "$reg" ]
			then			
				ls -LR
			else 	
				eval "find . -name $reg"

			fi
		elif [ ${sep_comnd} = "-C" ]
		then
			if [ -z ${reg} ]
			then
				ls
			else
				omit_semi=${reg/'"'}
				omit_semi=${omit_semi/'"'}
				ls $omit_semi
			fi
		fi
	echo -e "> ${RED}Done searching${NC}"
	fi
else	
	echo " "
	echo -e "Please ${RED}enter valid command!${NC} type ${RED}help${NC} to see available commands"
	echo " "
fi
done
}
mounter
