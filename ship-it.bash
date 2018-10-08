#!/bin/sh
#HOST=lolindrath.com
HOST=web1

if [[ "prod" = $1 ]]; then
	HUGO_OPTIONS=
	BASE_URL=https://lolindrath.com/
	BUCKET_NAME=lolindrath.com
	DIR=/var/www/lolindrath
else
	HUGO_OPTIONS=-DF # drafts and futures will show on Staging
	BASE_URL=https://staging.lolindrath.com/
	BUCKET_NAME=staging.lolindrath.com
	DIR=/var/www/lolindrath-staging
fi


mkdir -p public/.well-known/
cp keybase.txt public/.well-known
hugo --baseUrl $BASE_URL $HUGO_OPTIONS && rsync -avz --delete public/ ${HOST}:${DIR}
aws s3 sync --acl "public-read" --exclude .DS_Store public/ s3://$BUCKET_NAME  

exit 0
