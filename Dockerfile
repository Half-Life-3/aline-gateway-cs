FROM maven:3.8.5-jdk-11
COPY . /
ARG APP_SERVICE_HOST
ENV APP_SERVICE_HOST=${APP_SERVICE_HOST}
RUN git submodule deinit --all -f
RUN git submodule init
RUN git submodule sync
RUN git submodule update
RUN mvn clean install -DskipTests
RUN mvn clean package -DskipTests
EXPOSE 4000
CMD ["mvn", "spring-boot:run"]
