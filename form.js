// Below Function Executes On Form Submit
function ValidationEvent() {
// Storing Field Values In Variables
"use strict";
var name = document.getElementById("name").value;
var email = document.getElementById("email").value;
var contact = document.getElementById("contact").value;
// Conditions
if (name !== '' && email !== '' && contact !== '') {
if (contact.length > 0) {
alert("Thank You!");
return true;
} else {
alert("Please fill in all fields");
return false;
}
} else {
alert("Please fill in all fields");
return false;
}
}

