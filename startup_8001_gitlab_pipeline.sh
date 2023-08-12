#!/bin/sh
if [ $# -eq 1 ]; then
    APP_VERSION=${1}
fi
java -javaagent:./contrast-agent-${AGENT_VERSION}.jar \
-Dcontrast.api.url=${CONTRAST_URL} \
-Dcontrast.api.api_key=${API_KEY} \
-Dcontrast.api.service_key=${SERVICE_KEY} \
-Dcontrast.api.user_name=${USER_NAME} \
-Dcontrast.server.environment=${ENVIRONMENT} \
-Dcontrast.server.name=${SERVER_NAME} \
-Dcontrast.agent.java.standalone_app_name=${APP_NAME} \
-Dcontrast.application.version=${APP_VERSION} \
-Dcontrast.override.appversion=${APP_VERSION} \
-Dcontrast.agent.contrast_working_dir=contrast-8001/ \
-Dcontrast.agent.logger.level=INFO \
-Dcontrast.agent.polling.app_activity_ms=3000 \
-Dcontrast.agent.polling.server_activity_ms=3000 \
-Dcontrast.api.timeout_ms=1000 \
-jar ./target/spring-petclinic-1.5.1.jar --server.port=8001
