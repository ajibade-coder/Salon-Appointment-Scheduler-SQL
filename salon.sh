#!/bin/bash 

# psql varaibale command
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"


SALON_MENU () {
  if [[  $1 ]]
then
  echo -e "\n$1"
fi

# grapical heading
echo -e "\n======== WELCOME TO SALON =================\nHow can I help you ?\n"



  # getting available services from database
  AVAILABLE_SERVICE=$($PSQL "SELECT * FROM services")

  #getting the number of service in database
TOTAL_NUM_SERVICE=$($PSQL "SELECT COUNT(name) FROM services")


  echo "$AVAILABLE_SERVICE" |  while read SERVICE 
  do
  echo "$(echo $SERVICE | sed  's/|/) /')"
  done
  echo -e "\n"

  #take input from user in reply variable
  read SERVICE_ID_SELECTED





# if reply is not a number or the num is not among the service input code
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ || $SERVICE_ID_SELECTED > $TOTAL_NUM_SERVICE ]]
  then
      SALON_MENU "!ERROR: wrong input"
    fi

   


}







BOOKINGS () {
# collect customer info
echo -e "\n==================\nPls insert ur phone num bellow\n==========\n"
read CUSTOMER_PHONE

# check if customer is already a regisetered member

CUSTOMER_INFO=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE' ")


# if customer dont exist
if [[ -z $CUSTOMER_INFO ]] 
then
    # get customers name

    echo -e "\nCant get ur details\n you are a new member, let register u\nWhat's your name?"
    read CUSTOMER_NAME

    # insert new  customer into database
    INSERT_NEWCUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

      
  fi

  # welcome user
   echo -e "\n welcome $CUSTOMER_INFO,\n which time would u love to book for?"
   read SERVICE_TIME

   #get customer id
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ")

  

   INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')" )
  
  if [[ $INSERT_APPOINTMENT == 'INSERT 0 1' ]]
  then

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1" )

    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  fi


}



###############

SALON_MENU

 BOOKINGS "$SERVICE_ID_SELECTED"
################################


