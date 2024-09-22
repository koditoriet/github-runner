VERSION = 5
REGISTRY = registry.koditoriet.se
IMAGE = github-runner:${VERSION}
IMAGE_FULL = ${REGISTRY}/${IMAGE}

.PHONY: image
image:
	podman manifest rm ${IMAGE_FULL} || true
	podman manifest create ${IMAGE_FULL}
	podman build --platform linux/amd64 -t ${IMAGE}-amd64 .
	podman build --platform linux/arm64/v8 -t ${IMAGE}-arm64 .
	podman manifest add ${IMAGE_FULL} ${IMAGE}-amd64
	podman manifest add ${IMAGE_FULL} ${IMAGE}-arm64

.PHONY: push
push: image
	podman manifest push --all ${IMAGE_FULL}
