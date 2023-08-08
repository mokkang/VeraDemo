#!/bin/bash
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo "			Usage: ./S2P.sh <Veracode Application Profile>  	ex: ./S2P.sh VeraDemo 						  "
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
export $1
echo "Pull down and parse out the latest Sandbox scan through AppID to build_Id"
sappid=$(java -jar /Users/jmok/VeracodeJavaAPI.jar -action GetAppBuilds | grep $1 | tail -n 2 | head -n 1 |awk '{print $2}' |sed 's/[^0-9]*//g')
set | grep sappid
printenv | grep sappid
echo $sappid
echo "Get Sandboxid"
sandboxID=$(java -jar /Users/jmok/VeracodeJavaAPI.jar -action GetSandboxList -appid=$sappid -vid="$VID" -vkey="$VKEY" | grep sandbox_id | awk '{print $6}' | tail -n 1 | sed 's/[^0-9]*//g')
echo $sandboxID | awk '{print $1}'
set | grep sandboxID
printenv | grep sandboxID
echo $sandboxID
buildID=$(java -jar /Users/jmok/VeracodeJavaAPI.jar -action GetBuildList -appid $sappid -sandboxid $sandboxID | grep build_id | awk '{print $2}' | tail -n 1 | sed 's/[^0-9]*//g')
echo $buildID
set | grep buildID
printenv | grep buildID
echo "Prep for Promotion"
java -jar /Users/jmok/VeracodeJavaAPI.jar -action PromoteSandbox -buildid $buildID
echo "Promoted"
