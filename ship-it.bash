#!/bin/sh
HOST=lolindrath.com

if [[ "prod" = $1 ]]; then
	HUGO_OPTIONS=
	BASE_URL=https://lolindrath.com/
	BUCKET_NAME=lolindrath.com
else
	HUGO_OPTIONS=-DF # drafts and futures will show on Staging
	BASE_URL=https://staging.lolindrath.com/
	BUCKET_NAME=staging.lolindrath.com
fi

#&& rsync -avz --delete public/ ${HOST}:${DIR} 
hugo --baseUrl $BASE_URL $HUGO_OPTIONS
mkdir -p public/.well-known/
cp keybase.txt public/.well-known
aws s3 sync --acl "public-read" --exclude .DS_Store public/ s3://$BUCKET_NAME  

exit 0
