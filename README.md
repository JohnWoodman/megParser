# megParser
A quick script to help parse [tomnomnom's meg tool](https://github.com/tomnomnom/meg).

You can parse by status code and set a threshold to help exclude false positives.
## Help Page
```
This is a super basic script that lets you grab the important information from Meg scanner

Usage:
./megParser.sh [options] [meg directory]

[meg directory]:        the directory of the meg scanner output (default is 'out')

options:
-h, --help      show help page
-c              specify the status code to return results for (default is 200)
-t              specify the max number of acceptable potential false postivites for a specific domain (default is 5)
-o              specify the file to output results to (default is standard out)
-k              specify a keyword to search in HTML response to include in output
-e              specify a keyword to search in HTML response to not include in output (opposite of -k)
-l				show content length of response (cannot be used with -k or -e flag yet)

Example:
./megParser.sh -c 302 -t 10 -o myoutput.txt meg_directory
```
