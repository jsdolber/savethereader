$(document).ready(function(){
   
   $('a.hook').bind('inview', function(e,visible) {
    if( visible ) {
      $.getScript($(this).attr("href"));
     }
   });


   $("#modal-err").hide();

   $('.subscription-group').bind('click', function() {
      $("#selectionGroup").html($(this).text())
   });
  
   $("#subs-url").bind('keyup', function() {
    if (validateUrl($(this).val())) {
      toggleSaveBtn(true);
    }
    else {
      toggleSaveBtn(false);
    }
   }).keyup();

   $(".btn-save").bind('click', function() {
      createSubscription($("#subs-url").val(), 
                        $("#selectionGroup").html()); 
   });

   // initial subscription reading
   $('.feed-link').first().addClass('active');

   // subscription onclick functionality
   $('.feed-link').bind('click', function(){
       $('.feed-link').removeClass('active');
       $(this).addClass('active');
       loadSubscription($(this).attr("id"));
   });

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

   function loadSubscription(subs_id) {
      $.get("/subscriptions/" + subs_id + ".js"
      )
      .done(function(data) { 
        eval(data);
      })
      .fail(function() {
        $("#modal-err .msg").text('We were unable to serve this subscription.');
        $("#modal-err").show(); 
      })
      .always(function(data, textStatus) { }); 
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


