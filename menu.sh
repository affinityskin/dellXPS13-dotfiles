#!/bin/bash
OPTIONS="Hello Quit"
select opt in $OPTIONS; do
	if [ "$opt" = "Quit" ]; then
		echo Goodbye
		exit
	elif [ "$opt" = "Hello" ]; then
		echo Hello World
	else
		clear
		echo bad option
	fi
done
