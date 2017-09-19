--barcodereader.app AppleScript
--Robin O'Donoghue

set daysoftheweek to {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"} as list

--The next two lines must be edited when the prices indicated by the Price code digits are changed 

set pricecodesguardian to {"£2.10", "£2.20", "£2.30", "£2.40", "£1.20", "£1.30", "£1.40", "£1.50", "£1.60"} as list
set pricecodesobserver to {"£1.00", "£2.80", "£2.20", "£2.90", "£2.30", "£2.40", "£2.50", "£2.60", "£2.70"}
set thelength to ""
global thecode
global oddsum
global bigsum
global evensum
global checksumchar
global thetotal

--when the scan button is pressed the scanner passes the result to the keyboard hence the input dialog below

tell application "Finder"
	activate
	
	
	
	display dialog "Press the scan button now" default answer "" buttons "OK" default button "OK"
	
	set thecode to text returned of result as string
	
	set thelength to length of thecode
	
	--display dialog thelength
	
	--check that the script has the right number of digits
	
	if thelength as string is not equal to "15" then
		
		display dialog "The barcode appears to be of the wrong length" with icon stop
		
		
		--Verifies the checksum, see library doc for details
		
	end if
	getchecksum() of me
	set verified to result as boolean
	
	if not verified then
		display dialog "There was an error with the checksum"
		--else 977026130795849
		
		--display dialog "Checksum verified"
	end if
	
	--This section interprets the numbers read in the previous section once the length and checksum have been verified
	
	--end repeat
	try
		set theweek to characters 14 thru 15 of thecode as string
		set thepublication to characters 4 thru 10 of thecode as string
		set daycode to character 12 of thecode as number
		set theday to item daycode of daysoftheweek
		set pricecode to character 11 of thecode as number
		
		if thepublication = "0261307" then
			set thepaper to "The Guardian"
			set theprice to item (pricecode) of pricecodesguardian
		else
			if thepublication = "0029771" then
				set thepaper to "The Observer"
				set theprice to item (pricecode) of pricecodesobserver
				set theday to "Sunday"
			else
				display dialog "There may be an error with the Publication Code" buttons {"Cancel"} default button "Cancel" with icon stop
			end if
		end if
		
		--9770261307958  977026130795848
		---The most likely error is that the barcode has scanned wrongly
		
		display dialog "Day: " & theday & return & "Week: " & theweek & return & "Publication: " & thepaper & return & "Price: " & theprice buttons {"OK"} default button "OK"
	on error
		display dialog "Most errors are caused by incorrect scanning, please try again" buttons {"OK"} default button "OK" with icon note
	end try
	
end tell

--The precise details of the method of calculating the checksum are to be found in the doc in the IT library


on getchecksum()
	--display dialog "Verifying checksum" buttons {} giving up after 1
	set oddsum to 0
	set bigsum to 0
	set evensum to 0
	set checksumchar to character 13 of thecode as number
	(* 
repeat with loopVar from 1 to 12 by 1
	
	set bignumber to character loopVar of thecode as number
	
	set bigsum to (bigsum + bignumber)
end repeat
 *)
	repeat with loopVar from 1 to 11 by 2
		
		set oddnumber to character loopVar of thecode as number
		
		set oddsum to (oddsum + oddnumber)
		
		--display dialog (oddnumber as string) & " " & (oddsum as string) giving up after 2
		
	end repeat
	
	repeat with loopVar from 2 to 12 by 2
		
		set evennumber to character loopVar of thecode as number
		
		set evensum to (evensum + evennumber)
		
		
		
	end repeat
	set thetotal to ((evensum * 3) + oddsum) mod 10
	if (thetotal + checksumchar) is not equal to 10 then
		if (thetotal + checksumchar) is not equal to 0 then
			return false
		end if
		return true
	else
		return true
	end if
end getchecksum
