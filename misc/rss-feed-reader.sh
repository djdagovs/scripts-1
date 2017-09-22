#!/bin/bash
# A simple script that parses raw RSS feeds into a nice, readable format.
# Base script from: http://www.linuxjournal.com/content/parsing-rss-news-feed-bash-script
# Modified by simonizor

RSS_FEEDS="
https://news.ycombinator.com/rss
http://feeds2.feedburner.com/webupd8
http://feeds.feedburner.com/d0od
"

xmlgetnext () {
   local IFS='>'
   read -d '<' TAG VALUE
}

rssparse () {
cat $1 | while xmlgetnext ; do
case $TAG in
    'item')
        title=''
        link=''
        pubDate=''
        description=''
        ;;
    'title')
        title="$VALUE"
        ;;
    'link')
        link="$VALUE"
        ;;
    'pubDate')
        # convert pubDate format for <time datetime="">
        datetime=$( date --date "$VALUE" --iso-8601=minutes )
        pubDate=$( date --date "$VALUE" '+%D %H:%M%P' )
        ;;
    'description')
        # convert '&lt;' and '&gt;' to '<' and '>'
        description=$( echo "$VALUE" | sed -e 's/&lt;/</g' -e 's/&gt;/>/g' )
        ;;
    '/item')
        cat<<EOF
$(tput setaf 4)$title$(tput sgr0)
$link
$description
$datetime $pubDate

EOF
        ;;
    esac
done
}

for feed in $RSS_FEEDS; do
    FEED_NAME="$(echo "$feed" | cut -f3- -d"/" | cut -f1 -d"?")"
    echo "$(tput bold)$(tput setaf 4)-- $FEED_NAME --$(tput sgr0)"
    echo
    wget --quiet "$feed" -O - | rssparse | cat | sed '/<*..*>/d'
    echo
done
