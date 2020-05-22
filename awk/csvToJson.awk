#!/usr/bin/gawk -f
@include "csv.awk" # from http://lorance.freeshell.org/csv/
# https://stackoverflow.com/questions/9985528/how-can-i-trim-white-space-from-a-variable-in-awk
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

BEGIN { #run once before processing lines
		#print "START" 
		lines = 0;
		# formats is from the command line
		# ./csvToJson.awk -v formats="ssssssssssssssssdsssssddddssssssssssssssss" 
		# < ../data/MediumVoterData.csv 
		nf = split(formats,formatList,"")
		supportedFormats = "sdf"; # to check for errors
		formatStrings["s"] = "\"%s\" : \"%s\"\n";
		formatStrings["d"] = "\"%s\" : %d\n";
		formatStrings["f"] = "\"%s\" : %f\n";
		print "["; # start of JSON array
}

{
		if(lines++ == 0) { # first line is titles
			num_titles = csv_parse($0, titles, ",", "\"", "\"", "\\n", 1)
			next;
		}
		else {
			num_fields = csv_parse($0, csv, ",", "\"", "\"", "\\n", 0)
			if (num_fields < 0) {
				printf("ERROR: %d (%s) -> %s\n", num_fields, csv_err(num_fields), $0);
				next;
		 	}
			if(lines > 2) print(","); # row seperator
			printf "{"; # start of JSON object
			for (i=1; i <= length(titles); i++) {
				if(i > 1) printf(","); # field seperator
				format = (index(supportedFormats,formatList[i]) != 0) ?  formatStrings[formatList[i]] : formatStrings["s"];
				gsub(/\"/,"",csv[i]); # remove quotes
				finalValue = trim(csv[i]); #remove spaces
				printf(format, titles[i], finalValue);
			}
			print "}"; # end of JSON object
		} # all other lines
}

END   { # run once after processing lines
		print "]"; # end of JSON array
		#printf("END: processed %d lines\n",lines-1);
}
