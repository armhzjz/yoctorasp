FROM openjdk:17-jdk-alpine as DOCS

# ARG PLANTUML_VERSION="1.2022.7"

RUN apk add --update --no-cache bash make graphviz curl git ttf-droid ttf-droid-nonlatin zsh
RUN mkdir /docs/ \
    && curl -o /usr/local/bin/plantuml.jar -JLsS http://sourceforge.net/projects/plantuml/files/plantuml.jar/download \
    && chmod -x /usr/local/bin/plantuml.jar

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

WORKDIR /docs/

ENTRYPOINT [ "java", "-jar", "/usr/local/bin/plantuml.jar" ]
CMD [ "-h" ]
