# mssql-server-polybase
# Maintainers: Microsoft Corporation
# GitRepo: https://github.com/Microsoft/mssql-docker

# Base OS layer: Latest Ubuntu LTS
FROM ubuntu:16.04

#RUN apt -o Acquire::https::No-Cache=True -o Acquire::http::No-Cache=True update

RUN apt-get update

RUN apt-get install -yq apt-transport-https curl
RUN apt-get install -yq software-properties-common

#RUN add-apt-repository -r 'deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/mssql-server-preview xenial main'
#RUN add-apt-repository -r 'deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/mssql-server-preview xenial main'

RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-preview.list)"

#apt-get update -m && \
# Install prerequistes including repo config for SQL server and PolyBase.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    #apt-get install -yq apt-transport-https curl && \
    # Get official Microsoft repository configuration
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-preview.list  | tee /etc/apt/sources.list.d/mssql-server-preview.list  && \
    apt-get update && \
    # Install PolyBase will also install SQL Server via dependency mechanism.
    apt-get install -y mssql-server-polybase && \
    # Cleanup the Dockerfile
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Run SQL Server process
CMD /opt/mssql/bin/sqlservr
