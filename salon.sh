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
    EXISTING_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # phone number doesn't exist, ask for name
    if [[ -z $EXISTING_CUSTOMER_NAME ]]
    then
      echo -e "\nLooks like you're a new customer. What's your name?"
      read CUSTOMER_NAME
      $($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      TIME_PICKER
    else
      TIME_PICKER
    fi
  fi
}

TIME_PICKER() {
  echo -e "\nWhat time would you like to make this appointment?"
  read SERVICE_TIME
  GET_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  $($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$GET_ID', '$SERVICE_ID_SELECTED')")
  # confirm appointment details
  GET_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  GET_TIME=$($PSQL "SELECT time FROM appointments INNER JOIN customers USING(customer_id) WHERE phone = '$CUSTOMER_PHONE' AND service_id = '$SERVICE_ID_SELECTED'")
  GET_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nI have put you down for a $(echo $GET_SERVICE | sed 's/^ *//g') at $(echo $GET_TIME | sed 's/^ *//g'), $(echo $GET_NAME | sed 's/^ *//g')."
}

MAIN_MENU
