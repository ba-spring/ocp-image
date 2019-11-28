# create maven settings
cat << EOF > root/opt/m2/settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
http://maven.apache.org/xsd/settings-1.0.0.xsd">
 <localRepository>/opt/m2/repo</localRepository>
 <offline>true</offline>
</settings>
EOF
# build service 
cd ../business-application-service
mvn clean package
mv target/business-application-service-1.0-SNAPSHOT.jar ../ocp-image/root/opt/spring-service/
# build kjar
cd ../business-application-kjar/
# deploy kjar in the local repo
mvn clean install -P docker
rm -rf ../ocp-image/root/opt/m2/repo/*
cp -R target/local-repository/maven/* ../ocp-image/root/opt/m2/repo/
cp target/classes/business-application-service.xml ../ocp-image/root/opt/spring-service/
# build openshift image
if [ "$#" -eq  "0" ] 
then
  echo "create built, imange, application"
  oc new-build --binary --strategy=docker --name openshift-kie-springboot
  oc start-build openshift-kie-springboot --from-dir=. --follow
  oc new-app openshift-kie-springboot
else
  echo "update image"
  oc start-build openshift-kie-springboot --from-dir=. --follow
fi
