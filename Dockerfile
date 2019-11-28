FROM registry.access.redhat.com/ubi8/ubi-minimal:8.0
RUN microdnf install --nodocs java-1.8.0-openjdk-headless && microdnf clean all
ENV JAVA_OPTIONS="-Dkie.maven.settings.custom=/opt/m2/settings.xml -Dorg.guvnor.m2repo.dir=/opt/m2/repository" M2_HOME=/opt/m2 GC_MAX_METASPACE_SIZE=512
COPY root /
EXPOSE 8090
WORKDIR /opt/spring-service/
CMD ["sh","-c", "java ${JAVA_OPTIONS} -jar /opt/spring-service/business-application-service-1.0-SNAPSHOT.jar"]