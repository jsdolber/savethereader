$(document).ready(function(){
   
   $('a.hook').bind('inview', function(e,visible) {
    if( visible ) {
      $.getScript($(this).attr("href"));
     }
   });


   $("#modal-err").hide();

   $('.subscription-group').click(function() {
      $("#selectionGroup").html($(this).text())
   });
  
   $("#subs-url").keyup(function() {
    if (validateUrl($(this).val())) {
      toggleSaveBtn(true);
    }
    else {
      toggleSaveBtn(false);
    }
   }).keyup();

   $(".btn-save").click(function() {
      createSubscription($("#subs-url").val(), 
                        $("#selectionGroup").html()); 
   });

   $('.feed-link').first().addClass('active');

   function createSubscription(url, group) {
      isSaving(true);
      $.post("/subscriptions.json",
              initSubscription(url, group) 
      )
      .done(function(data) { 
        $('#subscriptionModal').modal('hide'); 
        addNewSubscription(data); 
      })
      .fail(function() {
        $("#modal-err .msg").text('We were unable to create this subscription.');
        $("#modal-err").show(); 
      })
      .always(function(data, textStatus) { isSaving(false); }); 
   }

   function initSubscription(url, group) {
      if (group != 'Group...')
        return {url: url, group: group};
      return {url: url};
   }

   function toggleSaveBtn(enabled) {
      if (enabled) {
        $(".btn-save").fadeTo(0, 1);
        $(".btn-save").removeAttr('disabled');
      }
      else {
        $(".btn-save").fadeTo(0, 0.5);
        $(".btn-save").attr('disabled','disabled');
      } 
   }

   function isSaving(enabled) {
     if (enabled) {
       $(".btn-save").html("Saving...");
     }
     else {
       $(".btn-save").html("Save Changes");
     }
     toggleSaveBtn(!enabled);
   }

   function addNewSubscription(data) {
        //alert(data); 
        toggleSaveBtn(true);
        isSaving(false); 
        $("#subs-url").val('');
        $("#selectionGroup").html("Group...");
   }

});


