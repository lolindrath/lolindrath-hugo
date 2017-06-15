#!/bin/sh
HOST=lolindrath.com

if [[ "prod" = $1 ]]; then
	DIR=/var/www/blog
	BASE_URL=https://lolindrath.com/
else
	DIR=/var/www/staging-blog
	BASE_URL=http://staging.lolindrath.com/
fi

hugo --baseUrl $BASE_URL && rsync -avz --delete public/ ${HOST}:${DIR}

exit 0