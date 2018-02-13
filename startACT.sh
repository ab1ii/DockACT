#!/bin/bash
#jmt67 2018 build and run ACT web client container
echo
tput setaf 6;echo 'The first build of this image will take several minutes.'
echo 'Command results stored in ACTstart.log';tput sgr0
echo
bldArg="--build-arg "
tput setab 4 tput setaf 0;read -p 'Enter in your SHRINE URL: ' inShrine
read -p 'Enter in your domain: ' inDomain
read -p 'Enter in your PM cell URL: ' inPM;tput sgr0
echo
iShrine="$bldArg shrineURL=$inShrine"
iDomain="$bldArg i2b2Domain=$inDomain"
iPM="$bldArg i2b2PM=$inPM"
bldCmd="docker build -t act_image $iShrine $iDomain $iPM ."
echo -e "build command $bldCmd\n" > ACTstart.log
tput setaf 6;echo 'Now building the act image. Please wait...';tput sgr0
bldResults=$(echo $($bldCmd))
echo $bldResults >> ACTstart.log
#known issue docker always has a return code of 0 so we can't branch on the $? value, we just have to run the next command
echo
tput setaf 6;echo 'Now starting the ACT container. Please wait...';tput sgr0
echo
runCmd="docker run --name=act_container -d -p 5001:80 act_image"
echo -e "run command: $runCmd\n" >> ACTstart.log
runResults=$(echo $($runCmd))
echo $runResults >> ACTstart.log
echo
tput setaf 2;echo 'ACT container should be running at http://your_hostname:5001/';tput sgr0
echo
