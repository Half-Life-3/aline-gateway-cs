FROM adoptopenjdk/openjdk11:alpine-jre
COPY ./target/aline-gateway-0.0.1-SNAPSHOT.jar /
EXPOSE 4000
CMD ["java", "-jar", "aline-gateway-0.0.1-SNAPSHOT.jar"]
