#!/bin/sh

APP_VERSION="CODEBUILD_TEST_$1"
java -javaagent:./contrast.jar \
-Dcontrast.server.environment=development \
-Dcontrast.server.name=ec2_CentOS7 \
-Dcontrast.agent.java.standalone_app_name=PetClinic_8081 \
-Dcontrast.application.version=$APP_VERSION \
-Dcontrast.agent.contrast_working_dir=/tmp/contrast-8081/ \
-Dcontrast.agent.logger.level=INFO \
-Dcontrast.agent.polling.app_activity_ms=3000 \
-Dcontrast.agent.polling.server_activity_ms=3000 \
-Dcontrast.api.timeout_ms=1000 \
-jar ./spring-petclinic-1.5.1.jar --server.port=8081
