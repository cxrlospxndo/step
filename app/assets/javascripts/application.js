//
//= require jquery
//= require jquery_ujs
//= require_tree .

function completeAndRedirect(){
    location.href='/data/'+document.forms[0].elements[0].value;
}
