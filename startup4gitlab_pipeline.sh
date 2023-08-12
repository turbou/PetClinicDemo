#!/bin/sh
if [ $# -eq 1 ]; then
    APP_VERSION=${1}
fi
java -javaagent:../target/contrast-agent-5.2.2.jar \
-Dcontrast.api.url=https://eval.contrastsecurity.com/Contrast \
-Dcontrast.api.api_key=EFhK6pIuD6mh5RX6YQ2iMOOavh9Mc52u \
-Dcontrast.api.service_key=L3EWY1E2OKWVZ4G0 \
-Dcontrast.api.user_name=agent_442311fd-c9d6-44a9-a00b-2b03db2d816c@Tabocom \
-Dcontrast.server.environment=development \
-Dcontrast.server.name=Gitlab-Pipeline \
-Dcontrast.agent.java.standalone_app_name=PetClinic_8001_GitlabDemo \
-Dcontrast.application.version=${APP_VERSION} \
-Dcontrast.override.appversion=${APP_VERSION} \
-Dcontrast.agent.contrast_working_dir=contrast-8001/ \
-Dcontrast.agent.logger.level=INFO \
-Dcontrast.agent.polling.app_activity_ms=3000 \
-Dcontrast.agent.polling.server_activity_ms=3000 \
-Dcontrast.api.timeout_ms=1000 \
-jar ../target/spring-petclinic-1.5.1.jar --server.port=8001
