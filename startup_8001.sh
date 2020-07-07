export wd=`pwd`

java -javaagent:${wd}/contrast.jar \
-Dcontrast.config.path=${wd}/contrast_security.yaml \
-Dcontrast.server.environment=development \
-Dcontrast.server.name=MacBookPro-Yuya \
-Dcontrast.agent.java.standalone_app_name=PetClinic_8001-Yuya-Training \
-Dcontrast.application.version=v8001 \
-Dcontrast.agent.contrast_working_dir=contrast-8001/ \
-Dcontrast.agent.logger.level=INFO \
-Dcontrast.agent.polling.app_activity_ms=3000 \
-Dcontrast.agent.polling.server_activity_ms=3000 \
-Dcontrast.api.timeout_ms=1000 \
-jar ${wd}/target/spring-petclinic-1.5.1.jar --server.port=8001
