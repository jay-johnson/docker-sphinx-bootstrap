#!/bin/bash

log="/tmp/start.log"

echo "$(date +'%m-%d-%y %H:%M:%S') Starting Container" > $log
date >> $log
env | sort >> $log
echo "$(date +'%m-%d-%y %H:%M:%S') " >> $log

echo "$(date +'%m-%d-%y %H:%M:%S') Using Doc Dir($ENV_DEFAULT_ROOT_VOLUME)" >> $log
pushd $ENV_DEFAULT_ROOT_VOLUME &>> $log

echo "$(date +'%m-%d-%y %H:%M:%S') Configuring GA Code($ENV_GOOGLE_ANALYTICS_CODE) to File($ENV_DOC_SOURCE_DIR/_templates/layout.html)" >> $log
sed -i "s|GOOGLE_ANALYTICS_CODE|$ENV_GOOGLE_ANALYTICS_CODE|g" $ENV_DOC_SOURCE_DIR/_templates/layout.html

echo "$(date +'%m-%d-%y %H:%M:%S') Building Sphinx Doc Source($ENV_DOC_SOURCE_DIR) Output($ENV_DOC_OUTPUT_DIR)" >> $log
sphinx-build -b html $ENV_DOC_SOURCE_DIR $ENV_DOC_OUTPUT_DIR &>> $log

echo "$(date +'%m-%d-%y %H:%M:%S') Configuring GA Code($ENV_GOOGLE_ANALYTICS_CODE) to File($ENV_DOC_OUTPUT_DIR/_templates/layout.html)" >> $log
sed -i "s|GOOGLE_ANALYTICS_CODE|$ENV_GOOGLE_ANALYTICS_CODE|g" $ENV_DOC_OUTPUT_DIR/_templates/layout.html

echo "$(date +'%m-%d-%y %H:%M:%S') Done Building Sphinx Docs" >> $log


sitemap="$ENV_DOC_OUTPUT_DIR/sitemap.xml"
echo "$(date +'%m-%d-%y %H:%M:%S') Building sitemap.xml for BaseDomain($ENV_BASE_DOMAIN) Path($sitemap)" >> $log
basedomain="$ENV_BASE_DOMAIN"

echo '<?xml version="1.0" encoding="UTF-8"?>' > $sitemap
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"' >> $sitemap
echo '        xmlns:mobile="http://www.google.com/schemas/sitemap-mobile/1.0"' >> $sitemap
echo '        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' >> $sitemap
echo '        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">' >> $sitemap

siteentries=`ls /opt/blog/repo/source/*.rst | sed -e 's|/| |g' | awk '{print $NF}' | sed -e 's/rst/html/g'`
for entry in $siteentries; do
    siteurl="$basedomain/$entry"
    echo "$(date +'%m-%d-%y %H:%M:%S') Adding Entry($entry) with full SiteURL($siteurl)" >> $log
    echo "   <url>" >> $sitemap
    echo "      <loc>$siteurl</loc>" >> $sitemap
    echo "   </url>" >> $sitemap
done
echo "</urlset>" >> $sitemap

chmod 666 $sitemap

popd &>> $log

echo "$(date +'%m-%d-%y %H:%M:%S') Done Starting" >> $log

echo "$(date +'%m-%d-%y %H:%M:%S') Preventing the container from exiting" >> $log
tail -f /tmp/start.log
echo "$(date +'%m-%d-%y %H:%M:%S') Done preventing the container from exiting" >> $log

exit 0
