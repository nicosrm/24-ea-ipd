FROM swift:5.10

WORKDIR /ipd

COPY src .

RUN swift package resolve && \
    swift build
