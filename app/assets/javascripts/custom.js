$(document).on('turbolinks:load', function() {
  $('#course_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('alert'));
    }
  });

  $('#lesson_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('alert'));
    }
  });

  $('.update-result').change(function(){
    $.get('../question_logs/' + $(this).val(), function(data, status) {});
  });

  $('.menu-start').click(function(e){
    $(this).parent().siblings().children('.dropdown-menu').hide();
    $(this).next('ul').toggle();
    e.stopPropagation();
    e.preventDefault();
  });

  $('.container').animate({minHeight:($(window).height() - 200)});
});

$(document).ready(function(){
  $('#category_id').change(function(){
    var category_id = $(this).val();
    $.get('course/' + category_id, function(data){
      $('#course_id').html(data);
    });
  });

  setTimeout(function(){
    $('#flash').remove();
  }, 3000); 
});

$(document).on('turbolinks:load', function() {
  var start = new Date().getTime();
  var isPaused = false;
  function getTimeRemaining(endtime) {
    var t = Date.parse(endtime) - Date.parse(new Date());
    var seconds = Math.floor((t / 1000) % 60);
    var minutes = Math.floor((t / 1000 / 60) % 60);
    var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
    var days = Math.floor(t / (1000 * 60 * 60 * 24));
    return {
      'total': t,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds
    };
  }

  function initializeClock(id, endtime) {
    var clock = document.getElementById(id);
    var daysSpan = clock.querySelector('.days');
    var hoursSpan = clock.querySelector('.hours');
    var minutesSpan = clock.querySelector('.minutes');
    var secondsSpan = clock.querySelector('.seconds');

    function updateClock() {
 
      if(!isPaused) {
        var t = getTimeRemaining(endtime);

        daysSpan.innerHTML = t.days;
        hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
        minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
        secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);

        if (t.total <= 0) {
          clearInterval(timeinterval);
          alert('Time out');
          $('#finish').click();  
        }
      }
    }

    updateClock();
    var timeinterval = setInterval(updateClock, 1000);

    $('#save').click(function(e){
      isPaused = true;
    });
  }

  var created_at = $('#created_at').val();
  if(created_at === undefined){
    return;
  }
  var date_created = new Date(created_at).getTime();
  var spend_time1 = $('#spend_time').val();
  var date_now = new Date().getTime();
  var updated_at = $('#updated_at').val();
  var date_updated = new Date(updated_at).getTime();
  var spend_time = date_updated - spend_time1;
  var time2 = 60*1000 - spend_time;
  var time = date_updated - date_created;
  var time_spend = date_now - date_created;
  var time_remaining = (60*1000) - time_spend;
  var time1 = (60*1000) - time;
  var deadline;
  var saved = $('#saved').val();
  
  if(saved == 'true'){
    deadline = new Date(Date.parse(new Date()) + time1);
  }else if(saved == 'false'){
    deadline = new Date(Date.parse(new Date()) + time1);
  }else{
    deadline = new Date(Date.parse(new Date()) + time_remaining);
  }

  initializeClock('clockdiv', deadline);
});
