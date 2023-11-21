FROM ubuntu:latest

USER root

RUN apt-get update && apt-get install curl -y

RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --init none \
  --no-confirm
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
    && nix-channel --update \
    && nix-env -iA nixpkgs.jdk nixpkgs.maven

COPY . /
RUN mvn package
COPY target/*.jar /app.jar

CMD java -jar /app.jar