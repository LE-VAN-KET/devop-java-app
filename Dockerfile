FROM openjdk:8-jre
WORKDIR /demojenkins
COPY /target/*.jar application-demo.jar
ENTRYPOINT [ "java", "-jar", "/demojenkins/application.jar" ]