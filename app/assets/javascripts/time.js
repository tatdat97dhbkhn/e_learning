$(document).on('turbolinks:load', function() {
  var isPaused = false;
  function getTimeRemaining(endtime) {
    var t = Date.parse(endtime) - Date.parse(new Date());
    var seconds = Math.floor((t / 1000) % 60);
    var minutes = Math.floor((t / 1000 / 60) % 60);
    return {
      'total': t,
      'minutes': minutes,
      'seconds': seconds
    };
  }

  function initializeClock(id, endtime) {
    var clock = document.getElementById(id);
    var minutesSpan = clock.querySelector('.minutes');
    var secondsSpan = clock.querySelector('.seconds');

    function updateClock() {
  
      if(!isPaused) {
        var t = getTimeRemaining(endtime);

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

  if($('.start_time').length){
    var date_now = new Date().getTime();
    var date_created = new Date($('.created_at').val()).getTime();
    var date_updated = new Date($('.updated_at').val()).getTime();
    var time_total = $('.time_total').val() * 1000;
    var status_save = $('.status_save').val();
    var status_pass = $('.status_pass').val();
    var status = get_status(status_save, status_pass);
    var deadline;

    if(status){
      if(status == 1){
        var time_remain = time_total - date_updated + date_created;
      }else{
        var time_remain = time_total - date_now + date_created;
      }
      deadline = new Date(Date.parse(new Date()) + time_remain);
      initializeClock('clockdiv', deadline);
    }
  }
});

function get_status(save, pass){
  if(pass.length != 0){
    return 0; //finished
  }else if(save == "true"){
    return 1; //saved
  }else{
    return 2; //unfinished
  }
}
