# Use latest stable channel SDK.
# FROM dart:stable AS build
FROM dart:latest


WORKDIR /app
COPY pubspec.* .
RUN  dart pub get
COPY . .
RUN  dart pub get --offline
RUN  dart compile exe bin/server.dart
FROM subfuzion/dart-scratch
COPY --from=0 /app/bin/server.exe /app/bin/server.exe


EXPOSE 8080
CMD ["/app/bin/server.exe"]