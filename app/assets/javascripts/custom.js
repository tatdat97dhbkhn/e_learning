$(document).on('turbolinks:load', function() {
  $('#course_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('alert'));
    }
  });

  var path_now = window.location.pathname;
  if(path_now.match("lesson_logs")){
    $('body').css('background-image', 'none');
  }

  $('table').addClass('table table-hover');

  $('#lesson_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('alert'));
    }
  });

  $('.update-result').change(function(){
    $.get('/question_logs/' + $(this).val(), function(data, status) {});
  });

  $('.menu-start').click(function(e){
    $(this).parent().siblings().children('.dropdown-menu').hide();
    $(this).next('ul').toggle();
    e.stopPropagation();
    e.preventDefault();
  });

  $('.container').animate({minHeight:($(window).height() - 200)});

  if($('.manage-menu').length != 0){
    $('.manage-menu a').each(function(){
      if(window.location.pathname.includes($(this).attr('href').split('/')[1])){
        $(this).addClass('active');
      }
    });
  }
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
