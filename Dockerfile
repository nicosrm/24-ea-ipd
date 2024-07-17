FROM swift:5.10

WORKDIR /ipd

COPY src .

RUN mkdir -p logs && \
    swift package resolve && \
    swift build
