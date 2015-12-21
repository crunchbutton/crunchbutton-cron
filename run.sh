#!/bin/bash
if [ "$#" -eq 0 ]; then
	echo "No command/process type specified"
        exit 1
fi

if [[ $TUTUM_TRIGGER_BODY =~ ^GIT_BRANCH:.*$ ]]; then
	echo "Using \$GIT_BRANCH from \$TUTUM_TRIGGER_BODY"
	GIT_BRANCH=$(echo "$TUTUM_TRIGGER_BODY" | sed -E 's#GIT_BRANCH:(.*)#\1#g')
fi

if [[ $TUTUM_TRIGGER_BODY =~ ^GIT_VERSION:.*$ ]]; then
	echo "Using \$GIT_VERSION from \$TUTUM_TRIGGER_BODY"
	GIT_BRANCH=$(echo "$TUTUM_TRIGGER_BODY" | sed -E 's#GIT_VERSION:(.*)#\1#g')
fi

if [ -d "/app" ]; then
	rm -Rf /app
fi

if [ -n "$GIT_REPO" ]; then
	if [ -n "$GIT_VERSION" ]; then
		git clone "$GIT_REPO" /app
		git --git-dir /app/.git fetch
		git --git-dir /app/.git checkout $GIT_VERSION
	else
		if [ -n "$GIT_BRANCH" ]; then
			git clone --single-branch --depth 1 -b "$GIT_BRANCH" "$GIT_REPO" /app
		else
			echo "No \$GIT_BRANCH environment variable defined, assuming MASTER"
			git clone --single-branch --depth 1 "$GIT_REPO" /app
		fi
	fi
	if [ -f "/app/build.sh" ]; then
		/app/build.sh
	fi

else
	echo "No \$GIT_REPO environment variable defined"
	exit 1
fi

exec "$@"
