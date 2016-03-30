$( function () {
    $.magnificPopup.instance.close = function () {
        var t = this.st.el[0]

        if (t.id == 'sign_in_link') {
            $.ajax({dataType: 'json', url: '/cancel_login'})
        }

        if (t.id == 'sign_up_link') {
            $.ajax({dataType: 'json', url: '/cancel_signup'})
        }

        $.magnificPopup.proto.close.call(this);
    };

    if ($('#login_advice_counter').length) {
        $('#sign_in_link').click();
    }

    if ($('#signup_advice_counter').length) {
        $('#sign_up_link').click();
    }
});

$( function(){
    $(".img-file-upload").each(function() {
        var fileElement = $(this)
        $(this).change(function(event){
            var input = $(event.currentTarget);
            var file = input[0].files[0];
            var reader = new FileReader();
            reader.onload = function(e){
                image_base64 = e.target.result;
                $(fileElement.attr('img_id')).attr("src", image_base64);
            };
            reader.readAsDataURL(file);
        });
    });
});

function validateImgFile(inputFile) {
    var maxExceededMessage = "#{I18n.t(:max_exceeded_message, scope: :image_upload)}";
    var extErrorMessage = "#{I18n.t(:ext_error_message, scope: :image_upload)}";;
    var allowedExtension = ["jpg", "jpeg", "png"];

    var extName;
    var maxFileSize = 1048576;
    var sizeExceeded = false;
    var extError = false;

    $.each(inputFile.files, function() {
        if (this.size && maxFileSize && this.size > maxFileSize) {sizeExceeded=true;};
        extName = this.name.split('.').pop();
        if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
    });
    if (sizeExceeded) {
        window.alert(maxExceededMessage);
        $(inputFile).val('');
    };

    if (extError) {
        window.alert(extErrorMessage);
        $(inputFile).val('');
    };
}


