var bindSubscriptionNavigation;
var bindSubscriptionGroupListClick;
var getSelectedSubscriptionId;
var setSelectedSubcription;
var loadSidebar;
var updateActiveReadCount;
var decrementActiveReadCount;
var expandGroup;
var collapseGroup;
var loadSubscription;
var setSelectedSubscriptionCountToZero;
var getActiveReadCount;

$(document).ready(function(){
   'use strict';
  
   var refreshIntervalInMinutes = 10;

   setSelectedSubcription = function(subsId){
      $.cookie('selSubscriptionId', subsId);
   };

   getSelectedSubscriptionId = function(){
     var subs_id = $.cookie('selSubscriptionId') || 0;
     return parseInt(subs_id);
   };

   function setGroupCollapsed(groupId, status) {
     $.cookie('group-' + groupId, status);
   }

   function getGroupCollapsed(groupId) {
     return $.cookie('group-' + groupId);
   }

    function toggleSubscriptionButton(active) {
        var el = $("a#trigger");
        var subLbl = "Add subscription";
        var remLbl = "Drop here to remove";
        if (!active) {
          el.addClass("btn-danger");
          el.find("i").removeClass("icon-rss");
          el.find("i").addClass("icon-trash");
          el.html(el.html().replace(subLbl, remLbl));
        }
        else {
          el.removeClass("btn-danger");
          el.find("i").addClass("icon-rss");
          el.find("i").removeClass("icon-trash");
          el.html(el.html().replace(remLbl, subLbl));
        }
    }

   bindSubscriptionGroupListClick = function() {
      $('.subscription-group').bind('click', function() {
        $("#selectionGroup").html($(this).text());
      });
   };

   bindSubscriptionGroupListClick();

   expandGroup = function(groupEl){
      groupEl.nextUntil(".group").toggle(true);
      groupEl.find(".unreadcnt").remove();
      groupEl.html(groupEl.text());
      groupEl.removeClass("collapsed");
      setGroupCollapsed(groupEl.attr("id"), false);
   }
   
   collapseGroup = function(groupEl) {
      groupEl.nextUntil(".group").toggle(false);
      groupEl.html("<i class='icon-plus-sign'></i>" + groupEl.text());
      groupEl.addClass("collapsed");
            //<span class='unreadcnt'>25</span>
      var uCount = 0;
      groupEl.nextUntil(".group").each(function(){
          var itemUnreadCnt = $(this).find(".unreadcnt").text();
          if (itemUnreadCnt.length > 0)
            uCount += parseInt(itemUnreadCnt);
      });

      if (uCount > 0) {
        groupEl.append("<span class='unreadcnt'>" + uCount + "</span>");
      }

      setGroupCollapsed(groupEl.attr("id"), true);
   }

   setSelectedSubscriptionCountToZero = function(){
     var selSubscription = getSelectedSubscriptionId();
     $(".feed-link#" + selSubscription + " .unreadcnt").remove();
   }

   // subscription onclick functionality
   bindSubscriptionNavigation = function() {
    $('.feed-link').bind('click', function(){
       $('.feed-link').removeClass('active');
       $(this).addClass('active');
       $("a.hook").attr('href','');
       loadSubscription($(this).attr("id"));
       $(".loader").show();
    });

    // sidebar group change and subs remove 
     var is_el_out = false;
     $("ul.nav-list").sortable({ 
       cancel: ".group", 
       beforeStop: function( event, ui ) {
          var subs_id = ui.item.attr("id");
          if (!is_el_out) {
            var new_group_id =  ui.item.prevAll(".group").attr("id");
            if (new_group_id == "0")
              new_group_id = "";
            updateSubscriptionGroup(subs_id, new_group_id);
          }
          else {
            // remove subscription
            ui.item.remove();
            removeSubscription(subs_id);
          }
          toggleSubscriptionButton(true);
       },
       activate: function(event, ui) {
        //console.log(ui);
        toggleSubscriptionButton(false);
     },
     out: function(event, ui) {
      is_el_out = true; 
     },
     over: function(event, ui) {
       is_el_out = false;
     }
   });

    //sidebar-nav-fixed
    $(".sidebar-nav-fixed").hover(
    function () {
      $(this).css("overflow-y", "auto");
    },
    function () {
      $(this).css("overflow-y", "hidden");
    }
    );

    // after sidebar load set active again
    $(".feed-link#" + getSelectedSubscriptionId()).addClass('active');

    // group toggle
    $("li.group").bind('click', function(){
        var group = $(".group#" + $(this).attr('id'));
        if ($(this).hasClass('collapsed')) {
          // expand
          expandGroup(group);
        }
        else { //collapse
          collapseGroup(group);
        }
    });

    $("li.group").bind('dblclick', function(){
      var group = $(".group#" + $(this).attr('id'));
      expandGroup(group);
    });

    // set initial group status
    $("li.group").each(function(){
      var groupId = $(this).attr('id');
      if (getGroupCollapsed(groupId) == "true") {
          collapseGroup($(this));
      }
    });
  }
  
  decrementActiveReadCount = function(){
      var unread_cnt = parseInt($(".feed-link.active .unreadcnt").text());
      var feed_active_el = $(".feed-link.active .unreadcnt");
      
      if (unread_cnt > 1)
        feed_active_el.html(unread_cnt - 1);
      else 
        feed_active_el.remove();
   }

   getActiveReadCount = function(){
      if ($(".feed-link.active .unreadcnt").length == 0) return 0;
      return parseInt($(".feed-link.active .unreadcnt").text());
   }

   loadSubscription = function(subs_id) {
      if (subs_id == undefined || parseInt(subs_id) == 0) return;
      
      $("div.feed-view").html('');
      $("#no-entries-banner").remove();
      setSelectedSubcription(subs_id);

      $.ajax({
        url: "/subscriptions/" + subs_id + ".js",
        type: "GET",
        dataType: "text"
      })
      .done(function(data) {
        if (subs_id == getSelectedSubscriptionId())
          eval(data);
      })
      .fail(function(data) {
        if (data.status == 200) return; // not json 
        $("#body-err .msg").text('We were unable to serve this subscription.');
        $("#body-err").show(); 
      })
      .always(function(data, textStatus) { /* empty */ }); 
   }

   var intervalId = null;

   loadSidebar = function() {
      $.ajax({ url: "/sidebar.js"
      , statusCode: {
              401: function() {
                clearInterval(intervalId);
              },
              504: function(){
                loadSidebar(); // call again if timeout
              }
          }
      })
      .done(function(data) { 
        eval(data);
      })
   };
    
   bindSubscriptionNavigation();

   $("ul.nav-list").disableSelection();

    // sidebar refresh
    intervalId = setInterval(loadSidebar, refreshIntervalInMinutes * 60 * 1000);
    // initial load
    loadSidebar();

    var selSubscription = getSelectedSubscriptionId();
    // initial subscription reading
    if (null == selSubscription || $(".feed-link#" + selSubscription).length == 0) {
      selSubscription = $('.feed-link').first().attr("id");
      setSelectedSubcription(selSubscription);
    }

    $(".feed-link#" + selSubscription).click();

    
});
