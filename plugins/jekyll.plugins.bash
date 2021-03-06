#!/bin/bash

newpost() {

	# 'builtin cd' into the local jekyll root

	builtin cd "$JEKYLL_LOCAL_ROOT/_posts"

	# Get the date for the new post's filename

	FNAME_DATE=$(date "+%Y-%m-%d")

	# If the user is using markdown formatting, let them choose what type of post they want. Sort of like Tumblr. 

	OPTIONS="Text Quote Image Audio Video"
	
	if [ $JEKYLL_FORMATTING = "markdown" -o $JEKYLL_FORMATTING = "textile" ]
	then
		select OPTION in $OPTIONS
		do
			if [[ $OPTION = "Text" ]] 
			then
				POST_TYPE="Text"
				break
			fi

			if [[ $OPTION = "Quote" ]]
			then
				POST_TYPE="Quote"
				break
			fi
		
			if [[ $OPTION = "Image" ]]
			then
				POST_TYPE="Image"
				break
			fi

			if [[ $OPTION = "Audio" ]]
			then
				POST_TYPE="Audio"
				break
			fi

			if [[ $OPTION = "Video" ]]
			then
				POST_TYPE="Video"
				break
			fi
		done
	fi

	# Get the title for the new post

	read -p "Enter title of the new post: " POST_TITLE

	# Convert the spaces in the title to hyphens for use in the filename

	FNAME_POST_TITLE=`echo $POST_TITLE | tr ' ' "-"`

	# Now, put it all together for the full filename

	FNAME="$FNAME_DATE-$FNAME_POST_TITLE.$JEKYLL_FORMATTING"

	# And, finally, create the actual post file. But we're not done yet...

	touch "$FNAME"

	# Write a little stuff to the file for the YAML Front Matter

	echo "---" >> $FNAME

	# Now we have to get the date, again. But this time for in the header (YAML Front Matter) of
	# the file

	YAML_DATE=$(date "+%B %d %X")

	# Echo the YAML Formatted date to the post file

	echo "date: $YAML_DATE" >> $FNAME

	# Echo the original post title to the YAML Front Matter header

	echo "title: $POST_TITLE" >> $FNAME

	# And, now, echo the "post" layout to the YAML Front Matter header

	echo "layout: post" >> $FNAME

	# Close the YAML Front Matter Header

	echo "---" >> $FNAME
	echo >> $FNAME

	# Generate template text based on the post type

	if [[ $JEKYLL_FORMATTING = "markdown" ]]
	then
		if [[ $POST_TYPE = "Text" ]]
		then
			true
		fi

		if [[ $POST_TYPE = "Quote" ]]
		then
			echo "> Quote" >> $FNAME
			echo >> $FNAME
			echo "&mdash; Author" >> $FNAME
		fi

		if [[ $POST_TYPE = "Image" ]]
		then
			echo "![Alternate Text](/path/to/image/or/url)" >> $FNAME
		fi

		if [[ $POST_TYPE = "Audio" ]]
		then
			echo "<html><audio src=\"/path/to/audio/file\" controls=\"controls\"></audio></html>" >> $FNAME
		fi

		if [[ $POST_TYPE = "Video" ]]
		then
			echo "<html><video src=\"/path/to/video\" controls=\"controls\"></video></html>" >> $FNAME
		fi
	fi

	if [[ $JEKYLL_FORMATTING = "textile" ]]
	then
		if [[ $POST_TYPE = "Text" ]]
		then
			true
		fi

		if [[ $POST_TYPE = "Quote" ]]
		then
			echo "bq. Quote" >> $FNAME
			echo >> $FNAME
			echo "&mdash; Author" >> $FNAME
		fi

		if [[ $POST_TYPE = "Image" ]]
		then
			echo "!url(alt text)" >> $FNAME
		fi

		if [[ $POST_TYPE = "Audio" ]]
		then
			echo "<html><audio src=\"/path/to/audio/file\" controls=\"controls\"></audio></html>" >> $FNAME
		fi

		if [[ $POST_TYPE = "Video" ]]
		then
			echo "<html><video src=\"/path/to/video\" controls=\"controls\"></video></html>" >> $FNAME
		fi
	fi

	# Open the file in your favorite editor

	$EDITOR $FNAME
}
