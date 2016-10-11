Code Book
============


There are four features in the data set:

# activity (type:character)
	The activity is simply one of six activities: 
	1 WALKING
	2 WALKING_UPSTAIRS
	3 WALKING_DOWNSTAIRS
	4 SITTING
	5 STANDING
	6 LAYING
	And each of these comes right out of the activity labels file.

# subject (type:integer)
	This is a number representing one of the 30 subjects. 
	To preserve anonymity, no other identifying information about the subject is in the data.

# sensor (type: character)
	This is a character representing the type of sensor and data.

# avg_reading (type:double)
	This is the average of all the readins of this sensor, on this subject during this activity.