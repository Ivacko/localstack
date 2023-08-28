FROM localstack/localstack:latest

RUN echo "Upgrading localstack CLI..."
RUN pip install --upgrade localstack localstack-ext
RUN localstack --version
