
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo "			Usage: ./S2P.sh <Veracode Application Profile>  	ex: ./S2P.sh VeraDemo 						  "
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo "Pull down and parse out the latest Sandbox scan through AppID to build_Id"
curl -sO https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/22.6.10.2/vosp-api-wrappers-java-22.6.10.2.jar VeracodeJavaAPI.jar 
chmod +x VeracodeJavaAPI.jar
appid=$(java -jar VeracodeJavaAPI.jar -action GetAppBuilds | grep Verademo-Sbox-Policy | tail -n 2 | head -n 1 |awk '{print $2}' |sed 's/[^0-9]*//g')
set | grep sappid
printenv | grep sappid
echo $appid
echo "Get Sandboxid"
sandboxID=$(java -jar VeracodeJavaAPI.jar -action GetSandboxList -appid=$appid -vid="$(VERACODE_API_ID)" -vkey="$(VERACODE_API_KEY)" | grep sandbox_id | awk '{print $6}' | tail -n 1 | sed 's/[^0-9]*//g')
echo $sandboxID | awk '{print $1}'
set | grep sandboxID
printenv | grep sandboxID
echo $sandboxID
buildID=$(java -jar VeracodeJavaAPI.jar -action GetBuildList -appid $appid -sandboxid $sandboxID | grep build_id | awk '{print $2}' | tail -n 1 | sed 's/[^0-9]*//g')
echo $buildID
set | grep buildID
printenv | grep buildID
echo "Prep for Promotion"
java -jar VeracodeJavaAPI.jar -action PromoteSandbox -buildid $buildID
echo "Promoted"
