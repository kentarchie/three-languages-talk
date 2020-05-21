gawk '
# get the extension part of a file name
function getExtension(file) 
{
   n = split(file, a, "."); # split the file name into parts
   return(a[n]);  # last element of the array
} # getExtension

BEGIN { 

	print "File\tType";

	# get list of file, skip the total line and squeeze the spaces
	cmd = "ls -l | egrep '^-'| tr -s \" \" ";
   while ( ( cmd | getline result ) > 0 )
  	{
   	n = split(result, parts, " ");
		# lines look like
		# -rwxrwxr-x 1 kent kent 932 May 7 22:25 awkWeb.awk
		# file name is the last field
		type = getExtension(parts[length(parts)]);
		types[type] += 1;
   }
   close(cmd);
	for (t in types) {
		printf("%s\t%d\n", t,types[t]);
	}
	print " - DONE -" 
}
'
