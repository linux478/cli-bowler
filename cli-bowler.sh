#!/bin/bash

DEBUG=1
CONF="cli-bowlerrc"
DATABASE="cli-bowler.db"
FILE_REMOVE="rm -i"
FILE_REMOVE_FORCE="rm -f"
RESET=0
DB=$(which sqlite3)

DBC="${DB} ${DATABASE}"

function config { 
	if [ ! -f "${CONF}" ]; then
		echo "DB=${DB}" > ${CONF}
		echo "DATABASE=${DATABASE}" >> ${CONF}
	fi
} 
function bowler-add {
	local FNAME
	if [ -z $1 ]; then read -p "Enter first name: " FNAME; else FNAME=$1; fi
	if [ -z $2 ]; then read -p "Enter last name: " LNAME; else LNAME=$2; fi
	if [ -z $3 ]; then read -p "Enter Handed[L/R/U]: " HAND; else HAND=$3; fi
	if [ -z $4 ]; then read -p "Enter Sanction ID: " SANCTION; SANCTION=$4; fi

	person-add ${FNAME} ${LNAME}

	PERSON=$(person-getId ${FNAME} ${LNAME})
	ID=$(database-nextid "bowlers")

	${DBC} <<EOF
		INSERT OR REPLACE INTO bowlers (id, fk_person, fk_hand, sanction, active) VALUES
		(${ID},${PERSON},"${HAND}","${SANCTION}",1);
EOF
}
function databases {
	database-addresses
	database-bowlers
	database-centers
	database-handtypes
	database-people
	database-eventtypes
	database-zipcodes
}
function database-addresses {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS addresses (
   id integer not null,
   address1 varchar(30),
	address2 varchar(30),
	zipcode integer references zipcodes(zipcode),
	primary key (address1,address2,zipcode)
);
EOF
}
function database-bowlers {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS bowlers (
   id integer not null,
	fk_person integer,
	fk_hand char,
	sanction varchar(30),
	active boolean NOT NULL,
		primary key (fk_person,fk_hand),
		foreign key (fk_person) references people(id),
		foreign key (fk_hand) references handtype(id)
);
EOF
}
function database-centers {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS centers (
	id integer not null,
	name varchar(30) not null,
	address references addresses(id),
	lanes integer not null,
	primary key (name,address)
);

insert or ignore into centers (name,address,lanes) VALUES ("Unknown",NULL,0);
EOF
}
function database-people {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS people (
   id integer not null,
	firstname varchar(30) NOT NULL,
   lastname  varchar(30) NOT NULL,
	primary key (firstname,lastname)
);
EOF
person-add "Unknown" "Unknown"
}
function database-handtypes {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS handtypes (
	id char NOT NULL,
	description varchar(30) NOT NULL,
	primary key (id)
);

handtype-add "L" "Left Hand"
handtype-add "R" "Right Hand"
handtype-add "U" "Unknown Hand"
EOF
}
function database-nextid {
	num=$(${DBC} "select max(id) from ${1}")
	echo $((${num} + 1))
}
function database-eventtypes {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS eventtypes (
	id char NOT NULL,
	description varchar(30) NOT NULL,
	primary key (id)
);
EOF

eventtype-add "OPEN" "Open 10 Pin Bowling"
eventtype-add "L-MEN" "League 10 Pin Bowling"
eventtype-add "L-WOMEN" "League 10 Pin Bowling"
eventtype-add "L-MIXED" "League 10 Pin Bowling"
eventtype-add "T-MEN" "Tournament 10 Pin Bowling"
eventtype-add "T-WOMEN" "Tournament 10 Pin Bowling"
eventtype-add "T-MIXED" "Tournament 10 Pin Bowling"
}
function database-zipcodes {
   ${DB} ${DATABASE} <<EOF
CREATE TABLE IF NOT EXISTS zipcodes (
	zipcode integer NOT NULL,
	city varchar(30),
	state varchar(2),
	primary key (zipcode)
);

insert or ignore into zipcodes (zipcode,city,state) VALUES (13332,"Earlville","NY");
EOF
}
function handtype-add {
	if [ -z $1 ]; then read -p "Enter symbol for hand: " $1; fi
	if [ -z $2 ]; then read -p "Enter description for ${1}: " $2; fi

   ${DB} ${DATABASE} <<EOF
		insert or ignore into handtypes (id,description) 
		VALUES ("${1}","${2}");
EOF
}
function menu-data {
	clear
	OPTIONS=("Add Bowler" "Quit")
	select OPT in "${OPTIONS[@]}"; do
		case $OPT in
			"Add Bowler") bowler-add; break;;
			"Quit") break ;;
		esac
		clear
	done
}
function menu-main {
	clear
	OPTIONS=("Enter Data" "Quit")
	select opt in "${OPTIONS[@]}"; do
		case $opt in
			"Enter Data") menu-data; break ;;
			"Quit") break ;;
		esac
		clear
	done
}
function person-add {
	if [ -z $1 ]; then read -p "Enter first name: " $1; fi
	if [ -z $2 ]; then read -p "Enter last name: " $2; fi

   ${DBC} "insert or ignore into people values ($(database-nextid \"people\"),\"${1}\",\"${2}\")"
}
function person-getId {
	${DBC} <<EOF
		SELECT id
		FROM people
		WHERE firstname = "${1}"
				AND lastname = "${2}";
EOF
}
function eventtype-add {
	if [ -z $1 ]; then read -p "Enter symbol for event : " $1; fi
	if [ -z $2 ]; then read -p "Enter description for ${1}: " $2; fi

   ${DB} ${DATABASE} <<EOF
		insert or ignore into eventtypes (id,description) 
		VALUES ("${1}","${2}");
EOF
}
function reset {
	${FILE_REMOVE} ${DATABASE}
}
function reset-force {
	${FILE_REMOVE_FORCE} ${DATABASE}
}
function views {
	view-bowlers
}
function view-bowlers {
   ${DB} ${DATABASE} <<EOF
		CREATE VIEW v_bowlers AS
		SELECT lastname, firstname, fk_hand AS hand, sanction
		FROM bowlers
		INNER JOIN people ON people.id = fk_person;
EOF
}
function setup {
	databases
	views
}

if [ ${RESET} -eq 1 ]; then
	reset
fi
if [ ${DEBUG} -eq 1 ]; then
	reset-force
	config
fi

source ${CONF}
setup
menu-main
