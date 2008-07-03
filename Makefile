NAME=rabbitmq-dotnet
NAME_VSN=${NAME}-${RABBIT_VSN}

RELEASE_DIR=releases/${NAME}/v${RABBIT_VSN}

STAGE_RELEASE_DIR=charlotte:/home/rabbitmq/stage-extras/releases/rabbitmq-dotnet
LIVE_RELEASE_DIR=charlotte:/home/rabbitmq/live-extras/releases/rabbitmq-dotnet

RSYNC_CMD=rsync -irvl --delete-after

TMPXMLZIP=${NAME_VSN}-tmp-xmldoc.zip

ifeq "$(RABBIT_VSN)" ""
rabbit-vsn:
	@echo "RABBIT_VSN is not set"
	@false
else
rabbit-vsn: 
endif

deploy-stage: rabbit-vsn ensure-deliverables
	${RSYNC_CMD} --exclude=${TMPXMLZIP} releases/rabbitmq-dotnet/ ${STAGE_RELEASE_DIR}

deploy-live: rabbit-vsn ensure-deliverables
	${RSYNC_CMD} --exclude=${TMPXMLZIP} releases/rabbitmq-dotnet/ ${LIVE_RELEASE_DIR}

ensure-deliverables: rabbit-vsn
	file ${RELEASE_DIR}/${NAME_VSN}.zip
	file ${RELEASE_DIR}/${NAME_VSN}-api-guide.pdf
	file ${RELEASE_DIR}/${NAME_VSN}-user-guide.pdf
	file ${RELEASE_DIR}/${NAME_VSN}-wcf-service-model.pdf
	file ${RELEASE_DIR}/${NAME_VSN}-net-2.0.zip
	file ${RELEASE_DIR}/${NAME_VSN}-net-2.0-htmldoc.zip
	file ${RELEASE_DIR}/${NAME_VSN}-net-2.0-htmldoc
	file ${RELEASE_DIR}/${NAME_VSN}-net-3.0-wcf.zip
	file ${RELEASE_DIR}/${NAME_VSN}-net-3.0-wcf-htmldoc.zip
	file ${RELEASE_DIR}/${NAME_VSN}-net-3.0-wcf-htmldoc

ensure-prerequisites: rabbit-vsn
	dpkg -p htmldoc plotutils transfig graphviz > /dev/null

ensure-release-dir: rabbit-vsn
	touch ${RELEASE_DIR}/

ensure-docs: rabbit-vsn
	file ${RELEASE_DIR}/${NAME_VSN}-net-2.0-htmldoc.zip
	file ${RELEASE_DIR}/${TMPXMLZIP}

doc: rabbit-vsn ensure-prerequisites ensure-release-dir ensure-docs
	./build-docs.sh
