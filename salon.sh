#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ The CLI Salon ~~\n"

MAIN_MENU() {
  echo -e "Type in a number next to one of our services:\n"
  # list services
  SERVICE_LIST=$($PSQL "SELECT * FROM services ORDER BY service_id")
  echo "$SERVICE_LIST" | while read ID BAR SERVICE_NAME
  do
    echo "$ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  # check if service picked exists
  if [[ -z $SERVICE_ID_SELECTED || ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # phone number doesn't exist, ask for name
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nLooks like you're a new customer. What's your name?"
      read $CUSTOMER_NAME
      # NAME_TO_INSERT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
  fi
  # choose a time
  # confirm appointment details
}

MAIN_MENU
