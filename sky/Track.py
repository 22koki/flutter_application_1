import phonenumbers
from phonenumbers import geocoder 
phone_number1 = phonenumbers.parse("+254717396334")
phone_number2 = phonenumbers.parse("+254721728539")
phone_number3 = phonenumbers.parse("+254725429407")
print("\nPhone Numbers Location\n")
print(geocoder.description_for_number(phone_number1,"en"));
print(geocoder.description_for_number(phone_number2,"en"));
print(geocoder.description_for_number(phone_number3,"en"));