code="200"
threshold="5"
output_file="/dev/stdout"
meg_directory="out"
keyword=""
exclude=""
while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "This is a super basic script that lets you grab the important information from Meg scanner"
			echo " "
			echo "Usage:"
			echo "$0 [options] [meg directory]"
			echo " "
			echo "[meg directory]:	the directory of the meg scanner output (default is 'out')"
			echo " "
			echo "options:"
			echo "-h, --help	show help page"
			echo "-c		specify the status code to return results for (default is 200)"
			echo "-t		specify the max number of acceptable potential false postivites for a specific domain (default is 5)"
			echo "-o		specify the file to output results to (default is standard out)"
			echo "-k		specify a keyword to search in HTML response to include in output"
			echo "-e		specify a keyword to search in HTML response to not include in output (opposite of -k)"
			echo " "
			echo "Example:"
			echo "./megParser.sh -c 302 -t 10 -o myoutput.txt meg_directory"
			echo " "
			exit 0
			;;
		-c)
			shift
			if test $# -gt 0; then
				code="$1"
			else
				echo "Error, no status code specified. See help page (-h)"
				exit 1
			fi
			shift
			;;
		-t)
			shift
			if test $# -gt 0; then
				threshold="$1"
			else
				echo "Error, no threshold specified. See help page (-h)"
				exit 1
			fi
			shift
			;;
		-o)
			shift
			if test $# -gt 0; then
				output_file="$1"
			else
				echo "Error, no output file specified. See help page (-h)"
				exit 1
			fi
			shift
			;;
		-k)
			shift
			if test $# -gt 0; then
				keyword="$1"
			else
				echo "Error, no keword specified. See help page (-h)"
				exit 1
			fi
			shift
			;;
		-e)
			shift
			if test $# -gt 0; then
				exclude="$1"
			else
				echo "Error, no exclude keyword specified. See help page (-h)"
				exit 1
			fi
			shift
			;;
		*)
			meg_directory="$1"
			break
			;;
	esac
done

while read p; do 

	if [[ ! -z "$keyword" ]]; then
		grep -r -Hno -i "$keyword" "$meg_directory"/"$p" | awk -F':' '{if ($2 != '1') {print $1}}' | xargs -I{} grep -l -i "HTTP.*$code" {} | xargs -I{} head -n 1 {} | sort -u
	elif [[ ! -z "$exclude" ]]; then
		grep -r -L -i "$exclude" "$meg_directory"/"$p" |  xargs -I{} grep -l -i "HTTP.*$code" {} | xargs -I{} head -n 1 {} | sort -u
	else
		grep -i "($code" "$meg_directory"/index | grep "$p" | cut -d" " -f2
	fi

done < <(grep "($code" "$meg_directory"/index | cut -d " " -f2 | cut -d "/" -f3 | sort | uniq -c | awk -v threshold="$threshold" '{if($1<threshold){print $2}}') > "$output_file"

#move threshold variable into each if statement
#also properly grep for code status in each if statment (seems to not be working)
