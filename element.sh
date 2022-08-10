#!/bin/bash
 
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
 
Check_empty() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    check_id=$1
    conition_atomic
  fi
}
 
conition_atomic() {
  if [[ $check_id =~ ^[0-9]+$ ]]
  then
    #number, id
    atomic_id=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$check_id")
  else
    if [[ $check_id =~ ^[A-Z][a-z]?$ ]]
    then
      atomic_id=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$check_id'")
    else
      atomic_id=$($PSQL "SELECT atomic_number FROM elements WHERE name='$check_id'")
    fi
  fi
  atomic_id_checking
}
 
atomic_id_checking() {
  if [[ -z $atomic_id ]]
  then
    echo "I could not find that element in the database."
  else
    find_value
  fi
}
 
 
find_value() {
  E_symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$atomic_id")
  E_name=$($PSQL "SELECT name FROM elements WHERE atomic_number=$atomic_id")
  P_mass=$($PSQL "SELECT properties.atomic_mass FROM elements JOIN properties USING(atomic_number) WHERE atomic_number=$atomic_id")
  P_melting=$($PSQL "SELECT properties.melting_point_celsius FROM elements JOIN properties USING(atomic_number) WHERE atomic_number=$atomic_id")
  P_boiling=$($PSQL "SELECT properties.boiling_point_celsius FROM elements JOIN properties USING(atomic_number) WHERE atomic_number=$atomic_id")
  T_type=$($PSQL "SELECT types.type FROM elements JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$atomic_id")
  get_sentense
}
 
get_sentense() {
  echo "The element with atomic number $atomic_id is $E_name ($E_symbol). It's a $T_type, with a mass of $P_mass amu. $E_name has a melting point of $P_melting celsius and a boiling point of $P_boiling celsius." | sed -E 's/ +/ /g; s/\( /\(/'
}
 
 
Check_empty $1
 

