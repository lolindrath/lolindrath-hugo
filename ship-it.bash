#!/bin/sh
HOST=lolindrath.com

if [[ "prod" = $1 ]]; then
	#DIR=/var/www/blog
	BASE_URL=https://lolindrath.com/
	BUCKET_NAME=lolindrath.com
else
	#DIR=/var/www/staging-blog
	BASE_URL=http://staging.lolindrath.com/
	BUCKET_NAME=staging.lolindrath.com
fi

#&& rsync -avz --delete public/ ${HOST}:${DIR} 
hugo --baseUrl $BASE_URL
mkdir -p public/.well-known/
cp keybase.txt public/.well-known
aws s3 sync --acl "public-read" --exclude .DS_Store public/ s3://$BUCKET_NAME  

exit 0
