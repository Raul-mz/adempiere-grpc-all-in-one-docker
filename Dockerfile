FROM openjdk:8-jre-alpine

LABEL maintainer="ysenih@erpya.com; EdwinBetanc0urt@outlook.com" \
	description="ADempiere gRPC All In One Server"

ENV URL_REPO="https://github.com/adempiere/adempiere-gRPC-Server" \
	BASE_VERSION="rt-16.0" \
	BINARY_NAME="adempiere-gRPC-Server.zip" \
	SERVER_PORT="50059" \
	DB_HOST="localhost" \
	DB_PORT="5432" \
	DB_NAME="adempiere" \
	DB_PASSWORD="adempiere" \
	DB_TYPE="PostgreSQL" \

RUN	mkdir -p /opt/Apps && \
	cd /opt/Apps && \
	apk --no-cache add curl && \
	curl --output "$BINARY_NAME" \
		-L "$URL_REPO/releases/download/$BASE_VERSION/$BINARY_NAME" && \
	unzip -o $BINARY_NAME && \
	mv adempiere-gRPC-Server ADempiere-gRPC-Server && \
	rm $BINARY_NAME

# Add connection template
COPY all_in_one_connection.yaml /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml

CMD sed i "s/50059/$SERVER_PORT/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml && \
    sed i "s/localhost/$DB_HOST/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml && \
    sed i "s/5432/$DB_PORT/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml && \
    sed i "s/adempieredb/$DB_NAME/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml && \
    sed i "s/adempiereuser/$DB_USER/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml && \
    sed i "s/adempierepass/$DB_PASSWORD/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml && \
    sed i "s/PostgreSQL/$DB_TYPE/g"  /opt/Apps/ADempiere-gRPC-Server/bin/all_in_one_connection.yaml 
    
WORKDIR /opt/Apps/ADempiere-gRPC-Server/bin/

CMD 'sh' 'adempiere-all-in-one-server' 'all_in_one_connection.yaml'