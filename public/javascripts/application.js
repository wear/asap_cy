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

function send_verify(mobile) { 
  var reg0=/^13\d{5,9}$/;   //130--139。至少7位
  var reg1=/^153\d{8}$/;  //联通153。至少7位
  var reg2=/^159\d{8}$/;  //移动159。至少7位
  var reg3=/^158\d{8}$/;
  var reg4=/^150\d{8}$/;
  var my=false;
  if (reg0.test(mobile))my=true;
  if (reg1.test(mobile))my=true;
  if (reg2.test(mobile))my=true;
  if (reg3.test(mobile))my=true;
  if (reg4.test(mobile))my=true;
	 if (!my){
		alert('对不起，您输入的手机号码错误。');
	 }else{
		$.get("/send_verify_code/" + mobile, function(data){
		  alert("发送结果: " + data);
		});
	 }  	
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
