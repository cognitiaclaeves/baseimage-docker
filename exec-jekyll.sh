#!/bin/sh

cd /home/vagrant/data
docker stop jekyll_runtime 2> /dev/null
docker rm -v jekyll_runtime 2> /dev/null

drafts=''


if [ ! -f /home/vagrant/data/_config.yml ];then
	echo "Initializing Jekyll Environment!"

	cd /home/vagrant/data
	docker run \
		--label=jekyll \
		--publish 4000:4000 \
		--rm \
		--volume="$(pwd):/srv/jekyll" \
		jekyll/jekyll:pages jekyll new . --force
fi

if [ -f '/vagrant/drafts' ]; then
  drafts='--drafts'
fi

echo "Running Jekyll!"

cd /home/vagrant/data
docker run \
	--env FORCE_POLLING=true \
	--env JEKYLL_ENV=development \
	--env VERBOSE=true \
	--label=jekyll \
	--name=jekyll_runtime \
	--publish "0.0.0.0:4000:80" \
	--rm \
	--volume="$(pwd):/srv/jekyll" \
	jekyll/jekyll:pages jekyll build --watch "$drafts"

