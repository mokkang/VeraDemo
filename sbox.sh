echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo "			Usage: ./S2P.sh <Veracode Application Profile>  	ex: ./S2P.sh VeraDemo 						  "
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo "Pull down and parse out the latest Sandbox scan thdddrough AppID to build_Id"
#echo $1
#export $1
curl -sO https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/22.6.10.2/vosp-api-wrappers-java-22.6.10.2.jar
chmod +x vosp-api-wrappers-java-22.6.10.2.jar
appid=$(java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetAppBuilds -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY | grep Verademo-Sbox-Policy | tail -n 2 | head -n 1 |awk '{print $2}' |sed 's/[^0-9]*//g')
set | grep appid
printenv | grep appidss
echo $appid
echo "Get Sandboxid"
sandboxID=$(java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetSandboxList -appid=$appid -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY | grep sandbox_id | awk '{print $6}' | tail -n 1 | sed 's/[^0-9]*//g')
echo $sandboxID | awk '{print $1}'
set | grep sandboxID
printenv | grep sandboxID
echo $sandboxID
java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetBuildList -appid $appid -sandboxid $sandboxID
echo "Parsing steps"
java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetBuildList -appid $appid -sandboxid $sandboxID -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY | grep build_id | awk '{print $2}' 
java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetBuildList -appid $appid -sandboxid $sandboxID -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY | grep build_id | awk '{print $2}' | tail -n 1 
echo "run java -jar "
java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetBuildList -appid $appid -sandboxid $sandboxID -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY | grep build_id | awk '{print $2}' | tail -n 1 | sed 's/[^0-9]*//g'
echo "set.env"
buildID=$(java -jar vosp-api-wrappers-java-22.6.10.2.jar -action GetAppBuilds -appid $appid -sandboxid $sandboxID -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY | grep build_id | awk '{print $2}' | tail -n 1 | sed 's/[^0-9]*//g')
echo $buildID
set | grep buildID
printenv | grep buildID
echo "Prep for Promotion"
java -jar vosp-api-wrappers-java-22.6.10.2.jar -action PromoteSandbox -buildid=$buildID 
#java -jar vosp-api-wrappers-java-22.6.10.2.jar -action PromoteSandbox -buildid=$buildID -appid $appid -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY
java -jar vosp-api-wrappers-java-22.6.10.2.jar -action PromoteSandbox -buildid=$buildID -appid $appid -sandboxid $sandboxID -vid=$VERACODE_API_ID -vkey=$VERACODE_API_KEY
#echo "Promoted"
