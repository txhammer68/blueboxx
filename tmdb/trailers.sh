while read line; do
link=`echo $line`
yt-dlp --format=mp4 -o "trailers/%(title)s.%(ext)s" $link
done < trailers.txt
