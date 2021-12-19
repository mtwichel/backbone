################
FROM google/dart:2.14

# Add any other local dependencies your service expects here
WORKDIR /app
COPY /functions_objects /functions_objects
WORKDIR /app
COPY /backend/pubspec.yaml /app/pubspec.yaml
RUN dart pub get
COPY /backend .
RUN dart pub get --offline

RUN dart compile exe bin/server.dart -o bin/server

########################
FROM subfuzion/dart:slim
COPY --from=0 /app/bin/server /app/bin/server
EXPOSE 8080
ENTRYPOINT ["/app/bin/server"]
