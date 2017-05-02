#!/usr/bin/bash
# ----------------------------------------------------------------#
# Matthew Miller						  #
# IT240-452							  #
# Final Project							  #
#-----------------------------------------------------------------#
# Comments: 							  #
#	1. File must be chmod +x for the script to loop properly  #
# --------------------------------------------------------------- #
echo `clear`
echo "(Ensure the systemAdminHelpher.sh has been chmod +x for proper looping)"
echo "Welcome to the System's Admin Helper Script!";
echo "---------------------";
echo " Menu";
echo "---------------------";
echo "1. Disk/Memory Usage"; 
echo "2. Network Information";
echo "3. Backup a Directory";
echo "4. Search for File";
echo "5. Set Reminder";
echo "6. Montior Log File(s)";
echo "7. Exit";
echo "---------------------";
echo -n "Enter Option [1-7]: "
read option; 
##################################################################
# Grabs Disk/Memory/CPU Usage, formats into a more readable form
##################################################################
function diskUsage()
{
echo "----------------------------------------------";
echo "Disk/Memory Usage";
echo "----------------------------------------------";

echo `free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'`;

echo `df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'`;
echo `top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'`; 

	echo -n "Perform another function? [y/n]: ";
	read reply
	if [ "$reply" == "y" ]
	then
		echo `clear`;
		exec ./systemAdminHelper.sh
	else
		echo `clear`;
		exit 1
	fi

}
####################################################################################
# Get Network Info, using ip addr piping the results to grep and formating with awk
####################################################################################
function getNetInfo()
{
	echo `clear`
	echo
	echo -n "Networking Information for "
		ip addr show | grep -w inet | grep -v 127.0.0.1 | awk '{print $8}'
	echo "------------------------------------------------"
echo " IPv4"
	echo -n "      Current IPv4 Address: "
		ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}'
	echo -n "      Network Mask: "
		ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{ print $4 }' | cut -d ":" -f 2
	echo -n "      MAC Address: "
		ip addr show | grep -w ether | awk '{ print $2 }'
	echo "------------------------------------------------"
echo " IPv6"
	echo -n "      Current IPv6 Address: "
		ip addr | grep -w inet6 | grep -v ::1 | awk '{print $2}' | cut -d "/" -f 1
	echo -n "      Prefix: "
		ip addr | grep -w inet6 | grep -v ::1 | awk '{ print $2 }' | cut -d "/" -f 2
	echo "------------------------------------------------"
	echo
#####################
# Recall the script
#####################
echo -n "Perform another function? [y/n]: ";
        read reply
        if [ "$reply" == "y" ]
        then
                echo `clear`;
                exec ./systemAdminHelper.sh
        else
                echo `clear`;
                exit 1
        fi


}
function locateFile()
{
	echo "----------------------------------------------";
	echo "Find a File"
	echo "----------------------------------------------";
	echo
	echo -n "Enter filename: ";
	read fileToFind

	if [ -z "$fileToFind" ]
	then
		echo "Error! You did not enter a filename!"
	else
		fileSearch=`locate -i $fileToFind`
		if [ "$fileSearch" ]
		then
			echo "--------------------------------------------"
			echo "List of files that have matched your search:"
        	        echo "--------------------------------------------"
				echo "$fileSearch";
				echo -n "Search for another file? [y/n] :"
				read response
			
				if [ "$response" == "y" ]
				then
				   locateFile;
				elif [ "$response" == "n" ]
				then
				  echo -n "Perform another function?[y/n]: "
				  read response_two
					if [ "$response_two" == "y" ]
					then
						echo `clear`
						exec ./systemAdminHelper.sh
					elif [ "$response_two" == "n" ]
					then
						echo `clear`
						exit 1
					else
						exit 1
					fi
				else
					echo `clear`
					exit 1
					 
				fi
		else
			echo "-----------------------------------"
			echo "No such file exist!";
			echo "-----------------------------------"
			
			echo -n "Search for another file? [y/n] :"
                                read response

                                if [ "$response" == "y" ]
                                then
                                   locateFile;
                                elif [ "$response" == "n" ]
                                then
                                  echo -n "Perform another function?[y/n]: "
                                  read response_two
                                        if [ "$response_two" == "y" ]
                                        then
                                                echo `clear`
                                                exec ./systemAdminHelper.sh
                                        elif [ "$response_two" == "n" ]
                                        then
                                                echo `clear`
                                                exit 1
                                        else
                                                exit 1
                                        fi
                                else
                                        echo `clear`
                                        exit 1

                                fi
		fi
		echo
		
	fi

}
##################################################################################
# Backsup a user specified directory and stores it in newly created backup folder
##################################################################################
function backUpDir()
{


        mkdir /home/student/Desktop/tempBackupFilesMrm36
        mkdir /home/student/Desktop/backups
        echo `clear`

echo "----------------------------------------------";
echo "Directory Backup Script"
echo "----------------------------------------------";
echo
echo


        echo -n "Enter the path of the directory you wish to backup: ";
        read targetDir
        echo -n "Enter name for backup: "
        read backupName
        TIME=`date +%b-%d-%y`
        checkBackup=`ls /home/student/Desktop/backups/ | grep "$backupName"-backup-"$TIME"`

        if [ ! $checkBackup ]
        then
                TIME=`date +%b-%d-%y`
                cp -a $targetDir /home/student/Desktop/tempBackupFilesMrm36/
                tar -czvf "$backupName"-backup-"$TIME".tar.gz /home/student/Desktop/tempBackupFilesMrm36/
                mv "$backupName"-backup-"$TIME".tar.gz /home/student/Desktop/backups/
                backupFolder="$backupName"-backup-"$TIME".tar.gz
                rm -r /home/student/Desktop/tempBackupFilesMrm36/
                echo `clear`
         	
		echo "----------------------------------------------";
		echo "Directory Backup Script"
		echo "----------------------------------------------";
		echo
		echo


		echo "Success! Backup Folder located at: /home/student/Desktop/backups/$backupFolder"
        else
                rm -r /home/student/Desktop/tempBackupFilesMrm36/
                echo `clear`
                echo "Error: Backup Folder already exist"
        fi
echo
echo -n "Perform another function? [y/n]: ";
        read reply
        if [ "$reply" == "y" ]
        then
                echo `clear`;
                exec ./systemAdminHelper.sh
        else
                echo `clear`;
                exit 1
        fi
 

}

function monitorLog()
{
echo "----------------------------------------------";
echo "Choose Option";
echo "----------------------------------------------";
echo "1. Monitor 1 File"
echo "2. Montior 2 Files"
echo "Type 'quit' to go back"
echo
echo -n "Enter option: "
read logOption

	if [ "$logOption" == "1" ]
	then
		echo `clear`
		echo "----------------------------------------------";
		echo "Log Monitor";
		echo "----------------------------------------------";

		echo -n "Enter path to log file: "
		read logFile
		echo -n "Enter pattern to look for: "
		read logPattern
		echo `clear`
		echo "----------------------------------------------";
		echo "Log Monitor for "$logFile" ";
		echo "----------------------------------------------";
		echo "[Will trigger live updates from "$logFile" where pattern "$logPattern" occurs.]"
		while true
		do
			if tail -f "$logFile" | grep "$logPattern"
			then
				echo -n "Pattern found: "
				echo `tail -f "$logFile" | grep "$logPattern"`
				echo " in $logFile"
			fi 
		done 

	elif [ "$logOption" == "2" ]
	then
		echo `clear`
                echo "----------------------------------------------";
                echo "Log Monitor";
                echo "----------------------------------------------";
 
                echo -n "Enter path to first log file: "
                	read logFile
				if [ -z "$logFile" ]
				then
					echo `clear`
					echo "---------------------------"
		
					echo "Error: No path provided for path 1"
					monitorLog
				fi
		echo -n "Enter path to second log file: "
			read logFileTwo
				if [ -z "$logFileTwo" ]
                                then
                                        echo `clear`
					echo "---------------------------"

					echo "Error: No path provided for path 2"
                                        monitorLog
                                fi
                echo -n "Enter pattern to look for: "
                	read logPattern
				if [ -z "$logPattern" ]
                                then
					echo `clear`
                                        echo "Error! No pattern provided"
					echo "--------------------------"
                                        monitorLog
                                fi
                echo `clear`
                echo "----------------------------------------------";
                echo "Log Monitor for "$logFile" and "$logFileTwo" ";
                echo "----------------------------------------------";
                echo "[Will trigger live updates from "$logFile" & "$logFileTwo" where pattern "$logPattern" occurs.]"
              	
		while true
		do
		  if tail -f "$logFile" -f "$logFileTwo" | grep "$logPattern"
		  then
				echo -n "Pattern found: "
                                echo `tail -f "$logFile" -f "$logFileTwo" | grep "$logPattern"`                        
		  fi 
		done
	elif [ -z "$logOption" ]
	then
		echo `clear`
		echo "**Error! No option chosen. Try Again!**"
		echo
		monitorLog
	elif [ "$logOption" == "quit" ]
	then
		exec ./systemAdminHelper.sh
	else
		echo `clear`
		echo "**Invalid option entered. Try Again!**"
		echo
		monitorLog
	fi

}
#######################################################################################
# Simple warning script to inform the user of what the backup script will accomplish
#######################################################################################
function backUpWarn()
{
echo "----------------------------------------------";
echo "Warning! Please Read!";
echo "----------------------------------------------";
echo "The following backup script creates 2 directories"
echo "on the users Desktop labled 'backups' and 'tempBackupFileMrm36'"
echo "and will remove 'tempBackupFilesMrm36' after the script completes"
echo "if this folder exists on your Desktop it is recommended you do not run this option!"
echo
echo

echo -n "Do you wish to continue? [y/n]: "
read response 

if [ "$response" == "y" ]
then
	echo `clear`
	backUpDir
elif [ "$response" == "n" ]
then
	echo `clear`
	exec ./systemAdminHelper.sh
else
	echo Error!
	exit 1
fi
}
#################################################################################
# Sets a reminder for the user which takes a set time and an additional message
#################################################################################
function setReminder()
{
echo "----------------------------------------------";
echo "Set Reminder";
echo "----------------------------------------------";
echo -n "Enter reminder time(ex. 00:00): "
read setTime
echo -n "Enter reminder message: "
read setReminder

set_alarm="$setTime"
echo `clear`

echo "----------------------------------------------";
echo "Alarm will trigger at: $setTime";
echo "----------------------------------------------";

if [ ! `echo "$set_alarm" | sed -n '/[0-2][[:digit:]]:[00-60]/p'` ]
then
        echo "Incorrect Format: Try Again!"
        exit 1
fi
 
second=1
alarmMessage="$setReminder"


	check_interval ()
	{
        	sleep $second
        	check_time
	}

	check_time ()
	{
        	currentTime=`date +%H:%M`
        	if [ "$currentTime" = "$set_alarm" ]
        	then
                	triggerAlarm
        	else
                	check_interval
        	fi
	}
 
	triggerAlarm ()
	{
        	echo -n "`echo "$set_alarm"`: "; echo "`echo "$alarmMessage"`"
        	$alarmtype
        	sleep 1
        	triggerAlarm
	}

	check_interval

}


###################################################################
# List of User options which redirect to the function which
# satisfies their needs
###################################################################

if [ "$option" == "1" ]
then
	echo `clear`;
	diskUsage;
elif [ "$option" == "2" ]
then
	echo `clear`;
	getNetInfo;
elif [ "$option" == "3" ]
then
        echo `clear`;
	backUpWarn;
elif [ "$option" == "4" ]
then
        echo `clear`;
	locateFile;
elif [ "$option" == "5" ]
then
	echo `clear`;
        setReminder;
elif [ "$option" == "6" ]
then
	echo `clear`;
	monitorLog;
elif [ "$option" == "7" ]
then
	echo `clear`;
	exit 1
fi

