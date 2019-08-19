(function ($) {
 "use strict";

  $("#form").submit(function(){ //Handle the sumbit here.           
            var url = $("#form").attr("action");
            var formData = $("#form").serialize();
            console.log(url);
            $.post(url, formData, function(response){
                console.log(response);
            });//end post
            
            
	$("body").on("click", "[data-ma-action]", function(e) {
        e.preventDefault();
        var $this = $(this),
            action = $(this).data("ma-action");
        switch (action) {
            case "nk-login-switch":
                var loginblock = $this.data("ma-block"),
                   $.post(loginblock, function(response){
                console.log(response);
            });
                break;
				case "print":
                window.print();
                break;
        }
    });
    
      $(document).on("click","#signUpBig",function(evt){
    evt.preventDefault();    
    if (canSubmit()) {
        $("#form").submit(); //Trigger the Submit Here
    } else {
        console.log("the forms info is not valid");
    }
});

 
})(jQuery); 