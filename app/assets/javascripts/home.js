var bindInviewEntries;
var showRead = false;
var showUnreadText = "<i class='icon-eye-closed'></i> Show only unread";
var showReadText = "<i class='icon-eye-open'></i> Show read";
var updateSubscriptionGroup;
var removeSubscription;

$(document).ready(function(){
   'use strict'; 
   
   $('a.hook').bind('inview', function(e,visible) {
    if( visible ) {
      $.getScript($(this).attr("href"));
     }
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

  // subscription creation
   $("#modal-err").hide();
   $("#modal-info").hide();
   $("#body-err").hide();
   $(".new-group .btn").tooltip();
   $('#new-group-link').click(function(){
     $("div.group-list").hide();
     $("div.new-group").show();
     $("div.new-group").css('display', 'inline');
     toggleSaveBtn(false);
   });

   $('#cancel-group-btn').click(function(){
      toggleGroupSaveControls(false);
   });

   $('#save-group-btn').click(function(){
      createSubscriptionGroup($("#new-group-name").val()); 
   });

   function createSubscription(url, group) {
      isSaving(true);
      $.ajax({
            url: "/subscriptions.json",
            data: initSubscription(url, group),
            type: "POST",
            statusCode: {
              401: function() {
                $("#modal-err").hide();
                $("#modal-info").show();
             }
            }
         }
      )
      .done(function(data) { 
        $('#subscriptionModal').modal('hide'); 
        addNewSubscription(data); 
      })
      .fail(function() {
        $("#modal-err .msg").text('We were unable to create this subscription.');
        $("#modal-err").show(); 
      })
      .always(function(data, status) { isSaving(false); }); 
   }

   function initSubscription(url, group) {
      if (group != 'Group...')
        return {url: url, group: group};
      return {url: url};
   }


   removeSubscription = function(subs_id) {
     if (subs_id === undefined) return;
     $.ajax({url: "/subscriptions/" + subs_id + ".json", 
             type: 'DELETE'
     })
      .done(function(data) { 
        //eval(data);
      })
   }

   updateSubscriptionGroup = function(subs_id, group_id) {
     if (subs_id === undefined) return;
     $.ajax({url: "/subscriptions/" + subs_id + ".json", 
             type: 'PUT',
             data: {
                    'subscription[id]' : subs_id,
                    'subscription[group_id]' : group_id
                   }
     })
      .done(function(data) { 
        //eval(data);
        loadSidebar();
      })
   }

   function createSubscriptionGroup(group_name) {
     if (group_name === undefined) return;
     $.post("/subscription_groups.json", 
             {
              'subscription_group[name]' : group_name
             }
     )
      .done(function(data) {
        var li = "<li class='last'><a class='subscription-group' href='#'>" + group_name + "</a></li>";
        var last_el = $(".group-list ul li.last");
        if (last_el.length == 0) {
          $(".group-list ul .divider").before(li);
        }
        else {
          last_el.after(li);
          last_el.removeClass('last');
        }
        bindSubscriptionGroupListClick(); 
      })
      .always(function(data, textStatus) { toggleGroupSaveControls(false); }); 
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

   function toggleGroupSaveControls(enabled) {
     $("div.group-list").toggle(!enabled);
     $("div.new-group").toggle(enabled);
     toggleSaveBtn(!enabled);

     if (enabled) {
       $("div.new-group").css('display', 'inline');
     }
     else {
      $("#subs-url").keyup();
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

    function isSavingGroup(enabled) {
      $("#save-group-btn").toggle(enabled);
      $("#cancel-group-btn").toggle(enabled);
   }

   function addNewSubscription(data) {
        toggleSaveBtn(true);
        isSaving(false); 
        $("#subs-url").val('');
        $("#selectionGroup").html("Group...");
        loadSidebar();
   }

    // scroll logic
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

    // entry inview binding
    bindInviewEntries = function() {
     $('.entry').bind('inview', function(e,visible) {
      if( !visible && direction == 'down' && $(this).hasClass("unread")) {
       entryWasRead($(this));
      }
     });

     $(".title-link").click(function() {
        var el = $(this).closest("section");
        if (el.hasClass("unread")) {
          entryWasRead(el);
        }
     });
    };

    function entryWasRead(entryEl) {

      $.post("/readentries.json",
      {
         'readentry[entry_id]': entryEl.attr("id"),
         'readentry[subscription_id]': getSelectedSubscriptionId()
      })
      .done(function(data) { 
        entryEl.fadeTo(0, 0.5);
        entryEl.removeClass("unread");
        entryEl.addClass("read");
        decrementActiveReadCount();
      })
    }

   // navigation bar actions
   $(".btn-show-unread").bind('click',function(){
      showRead = !$(this).hasClass("active");
      $.post("/subscriptions/set_show_read.json",
      {
         'state': showRead
      })
      .done(function(data) { 
        $(".btn-show-unread").html(showRead? showUnreadText : showReadText);
        loadSubscription(getSelectedSubscriptionId());
      })
      .fail(function() {
        $("#body-err .msg").text('We can\'t show that right now.');
        $("#body-err").show(); 
      })
   });

    $(".btn-mark-all-read").bind('click',function(){
      showRead = !$(this).hasClass("active");
      $.post("/subscriptions/mark_all_read.json",
      {
         'id': getSelectedSubscriptionId() 
      })
      .done(function(data) { 
        loadSidebar(); 
      })
   });

});


