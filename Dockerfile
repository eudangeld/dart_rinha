FROM dart:stable as build
COPY . /dart-server

COPY pubspec.* .

WORKDIR /dart-server

RUN mkdir build
RUN dart pub get
RUN dart compile exe ./bin/server.dart -o ./build/dartserver


FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /dart-server/build/dartserver /app/bin/
CMD ["/app/bin/dartserver"]