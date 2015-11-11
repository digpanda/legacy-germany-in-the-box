 $(document).ready(function(){
        $('#send-message').click(function(e){
            
            //Stop form submission & check the validation
            e.preventDefault();
            
            // Variable declaration
            var error = false;
            var name = $('#name').val();
            var email = $('#email').val();
            var subject = $('#subject').val();
            var message = $('#message').val();
            var alert = 'form-alert-';
            
         	// Form field validation
            if(name.length == 0){
                var error = true;
                $('#' + alert + 'name').fadeIn(500);
            }else{
                $('#' + alert + 'name').fadeOut(500);
            }
            if(email.length == 0 || email.indexOf('@') == '-1'){
                var error = true;
                $('#' + alert + 'email').fadeIn(500);
            }else{
                $('#' + alert + 'email').fadeOut(500);
            }
            // if(subject.length == 0){
            //     var error = true;
            //     $('#subject_error').fadeIn(500);
            // }else{
            //     $('#subject_error').fadeOut(500);
            // }
            if(message.length == 0){
                var error = true;
                $('#' + alert + 'message').fadeIn(500);
            }else{
                $('#' + alert + 'message').fadeOut(500);
            }
            
            // If there is no validation error, next to process the mail function
            if(error == false){
               // Disable submit button just after the form processed 1st time successfully.
                $('#send-message').attr({'disabled' : 'true', 'value' : 'Sending...' });
                
				/* Post Ajax function of jQuery to get all the data from the submission of the form as soon as the form sends the values to email.php*/
                $.post("includes/mail/index.php", $("#contact-form").serialize(),function(result){
                    //Check the result set from email.php file.
                    if(result == 'sent'){
                        //If the email is sent successfully, remove the submit button
                         $('#send-message').remove();
                        //Display the success message
                        $('#' + alert + 'success').fadeIn(500);
                    }else{
                        //Display the error message
                        $('#' + alert + 'fail').fadeIn(500);
                        // Enable the submit button again
                        $('#send-message').removeAttr('disabled').attr('value', 'Send The Message');
                    }
                });
            }
        });    
    });