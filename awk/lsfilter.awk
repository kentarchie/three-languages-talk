ls -l | gawk '
BEGIN { 
	print "File\tSize\tOwner";
	totalSize = 0;
}

 /^-/ { 
	printf "%s\t%d\t%s\n",$9, $5, $3;
	totalSize += $5;
}

END { 
	printf "total size = %d\n",totalSize;
	print " - DONE -" 
}
'
