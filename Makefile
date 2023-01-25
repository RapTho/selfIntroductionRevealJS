# Makefile for Node-RED using IBM Container Registry and IBM Code Engine

ICR_ID=de.icr.io/codeengine-selfintro-raph-3e7a
IMG_NAME:="selfintro-raphael-tholl"
IMG_VERSION:="1.0"
CE_PROJECT_NAME="selfintro-raphael-tholl-revealjs"
CE_APP="selfintro-raphael-tholl"
API_KEY=

default: build rm-old push code-engine-update

build:
	podman build --rm -t $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION) --layers=false .
	podman image prune --filter label=stage=builder --force

run:
	podman run -d \
          --name ${IMG_NAME} \
          -p 8000:8000 \
          --restart unless-stopped \
          $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION)

stop:
	@podman rm -f ${IMG_NAME} >/dev/null 2>&1 || :

clean:
	@podman rmi -f $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION) >/dev/null 2>&1 || :
	podman image prune --filter label=stage=builder --force

login:
	ibmcloud login --sso
	ibmcloud cr region-set eu-central
	ibmcloud target -g Default
	ibmcloud cr login --client podman

rm-old:
	ibmcloud cr image-rm $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION)

push:
	podman push $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION)

apikey-create:
	ibmcloud iam api-key-create makefile-selfintro -d "API Key for Makefile Automation of my selfintro"

apikey-delete:
	ibmcloud iam api-key-delete -f makefile-selfintro

code-engine-create:
	ibmcloud ce project create -n $(CE_PROJECT_NAME)
	ibmcloud ce registry create --name ibm-container-registry --server de.icr.io --username iamapikey --password $(API_KEY)
	ibmcloud ce app create --name node-red --image $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION) --registry-secret ibm-container-registry  --port 8000 --max-scale 1 --cpu 0.25 --memory 0.5G 

code-engine-update:
	ibmcloud ce project select -n $(CE_PROJECT_NAME)
	ibmcloud ce app get -n $(CE_APP)
	ibmcloud ce app update --name $(CE_APP) --image $(ICR_ID)/$(IMG_NAME):$(IMG_VERSION) --registry-secret ibm-container-registry --port 8000 --max-scale 1 --cpu 0.25 --memory 0.5G
	ibmcloud ce app logs --name $(CE_APP)

code-engine-delete:
	ibmcloud ce project delete -n $(CE_PROJECT_NAME) --hard --no-wait -f

.PHONY: build run push stop clean