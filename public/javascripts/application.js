// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// 
//  
$j = jQuery; 
$j.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} });
jQuery(document).ready(function($) {
    // Binding focus and blur events for query input box
    $('#query').
        focus(function() {
        if (this.value == "如:川菜") {
            this.value = "";
        }
    }).
        blur(function() {
        if (this.value == "") {
            this.value = "如:川菜";
        }
    });
});  

function add_tag(tag) {
  $('tags').value +=  ' ' + tag;
}   

function add_dish(dish) {
  $('dishes').value +=  ' ' + dish;      	
} 

function mark_for_destroy(element) { 
  $(element).next('.should_destroy').value = 1 
  $(element).up('.attachment').hide(); 
}            

function clear_query_box(id) {
    if(jQuery('.' + id).val() == '如:川菜') {
        jQuery('.' + id).val('*')
    }
	jQuery('.' + id).parent().parent().submit();
}