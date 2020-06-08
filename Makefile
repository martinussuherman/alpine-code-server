# https://gist.github.com/coolcow/213653bef387855349593dcd16923637

include make.env

IMAGE_NAME = $(NAMESPACE)/$(NAME)

# ---

default: update-dependencies build

# ---

update-dependencies:
	@for dependency in $(DEPENDENCIES); do \
	  docker pull $$dependency; \
	done

# ---

build:
	@ \
	IMAGE_NAME=$(IMAGE_NAME) \
	VCS_REF=`git rev-parse --short HEAD` \
	BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	hooks/build \
      .

# ---

inspect:
	@docker inspect $(IMAGE_NAME):$(VERSION)

# ---

run:
	@docker run --rm $(IMAGE_NAME):$(VERSION) $(ENVIRONMENTS) $(VOLUMES)

# ---

start:
	@docker run -d --name $(NAME)-$(INSTANCE) $(ENVIRONMENTS) $(VOLUMES) $(IMAGE_NAME):$(VERSION)

# ---

stop:
	@docker rm -f $(NAME)-$(INSTANCE)

# ---

exec:
	docker exec -it $(NAME)-$(INSTANCE) /bin/sh

# ---

shell:
	@docker run --rm -it $(IMAGE_NAME):$(VERSION) /bin/sh

# ---

release:
	@docker push $(IMAGE_NAME):$(VERSION) 
