$(document).on('turbolinks:load', function() {
  $('#course_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('alert'));
    }
  });
  $('#lession_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('alert'));
    }
  });
});
$(document).ready(function(){
  $('#category_id').change(function(){
    var category_id = $(this).val();
    $.get("course/" + category_id,function(data){
      $('#course_id').html(data);
    });
  });
});
