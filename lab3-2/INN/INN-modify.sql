-- Kyaw Lwin Soe
-- ksoe@calpoly.edu
-- Kaitlin Bleich
-- kbleich@calpoly.edu

/*
• Add to the table which stores information about the rooms an attribute to store the description
of a room. The room description is a short text (about double the standard tweeter message
length).
• Create a somewhat meaningful description for each room and place the description into the
record for the respective room. The descriptions should be loosely based on the name of the
room and other observable (from the table) room features. For example, for "Thrift and
accolade" room, a description might be
3
“Experience the luxury of our Bed & Breakfast for half the price! Cozy room overlooking
picturesque garden.”
Please note that vulgarity is not creative and will result in a decreased score.
• Output the contents of the rooms table using the following SQL command:
SELECT *
FROM <rooms-table>
ORDER BY <Room-ID> \G
replacing <rooms-table> with the name of your rooms table and <Room-id> with the name of
the attribute for the three-letter room code. Note the \G at the end of the query (in this case,
mySQL is case-sensitive). This will force mySQL to show results in a row-by-row fashion, rather
than in a table.

*/

ALTER TABLE Rooms
	ADD (info VARCHAR(1000));

UPDATE Rooms
	SET info = 'Experience the luxury of our Bed & Breakfast for half the price! Cozy room overlooking picturesque garden.'
	WHERE roomName = 'Thrift and accolade';

UPDATE Rooms
	SET info = 'Enjoy the solitute like an angler fish while you stay in our whole house at the top of the hill with mustard grass surrounding.'
	WHERE roomName = 'Recluse and defiance';

UPDATE Rooms
	SET info = 'Experience a healthy living like never before while you stay in our garden house with therapy sessions.'
	WHERE roomName = 'Interim but salutary';

UPDATE Rooms
	SET info = 'Live in a secret like a mafia in our spacious room hidden away.'
	WHERE roomName = 'Mendicant with cryptic';

UPDATE Rooms
	SET info = 'Enjoy our 1900s-style room with legacy from the past.'
	WHERE roomName = 'Harbinger but bequest';

UPDATE Rooms
	SET info = 'Experience our spacious room with all the utitilies that can be provided.'
	WHERE roomName = 'Convoke and sanguine';

UPDATE Rooms
	SET info = 'Experience the beauty of nature in our tuckaway cabin.'
	WHERE roomName = 'Riddle to exculpate';

UPDATE Rooms
	SET info = 'Enjoy simple living in our peaceful minimal living house.'
	WHERE roomName = 'Frugal not apropos';

UPDATE Rooms
	SET info = 'Live in a high tech room with everything under voice control to accomodate your fast-paced living style.'
	WHERE roomName = 'Abscond or bolster';

UPDATE Rooms
	SET info = 'Enjoy our prehistoric style room with high-tech embedded under the radar.'
	WHERE roomName = 'Immutable before decorum';

SELECT * FROM Rooms
	ORDER BY RoomId \G