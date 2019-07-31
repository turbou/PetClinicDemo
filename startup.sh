#export MAVEN_OPTS="-javaagent:contrast-eop/contrast.jar -Dcontrast.dir=contrast-eop/ -Dcontrast.override.appname=PetClinic -Dcontrast.server=PetClinic-SpringBoot"

#./mvnw spring-boot:run


java -javaagent:/Users/turbou/contrast/agents/Java/contrast.jar -Dcontrast.override.appname=PetClinic -Dcontrast.override.appversion=v1.1 -Dcontrast.dir=contrast-eop/ -Dcontrast.server.activity.period=5000 -Dcontrast.timeout=10 -Dcontrast.level=DEBUG -jar ./target/spring-petclinic-1.5.1.jar

