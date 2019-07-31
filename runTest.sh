export MAVEN_OPTS="-javaagent:contrast-eop/contrast.jar -Dcontrast.dir=contrast-eop/ -Dcontrast.standalone.appname=PetClinic-Maven -Dcontrast.server=PetClinic-Maven -Dcontrast.level=DEBUG"

mvn test


