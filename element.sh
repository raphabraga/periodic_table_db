#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
    then
        if [[ $1 =~ ^[0-9]+$ ]]
            then
                CONDITION="atomic_number=$1"
            else
                CONDITION="symbol='$1' OR name='$1'"
        fi
        ELEMENT_RESULT=$($PSQL "SELECT atomic_number, atomic_mass, 
        name, symbol, t.type, melting_point_celsius, 
        boiling_point_celsius 
        FROM elements 
        INNER JOIN properties USING (atomic_number) 
        INNER JOIN types AS t USING (type_id) 
        WHERE $CONDITION")

        if [[ -z $ELEMENT_RESULT ]]
            then
                echo "I could not find that element in the database."
            else
                echo $ELEMENT_RESULT | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR NAME BAR SYMBOL BAR TYPE BAR MELTING_POINT BAR BOILING_POINT
                    do
                        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
                    done
        fi
else
    echo "Please provide an element as an argument."
fi
