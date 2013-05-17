$(document).ready(function(){
   
   $('a.hook').bind('inview', function(e,visible) {
    if( visible ) {
      $.getScript($(this).attr("href"));
     }
   });

   $('.entry').bind('inview', function(e,visible) {
    if( !visible && direction == 'down') {
      $(this).fadeTo(0, 0.5);
      console.log($(this).attr("id"));
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

   // subscription onclick functionality
   $('.feed-link').bind('click', function(){
       $('.feed-link').removeClass('active');
       $(this).addClass('active');
       loadSubscription($(this).attr("id"));
   });

   // initial subscription reading
   $('.feed-link').first().click();
   $(".entry.read").fadeTo(1, 0.5);

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

    // scroll logic

    'use strict';

    var lastScrollTop = 0,
        st,
        direction;

    function detectDirection() {

        st = window.pageYOffset;

        if (st > lastScrollTop) {
            direction = "down";
        } else {
            direction = "up";
        }

        lastScrollTop = st;

        return  direction;

    }

    $(window).bind('scroll', function() {
        detectDirection();
    });

});


