$(document).on('turbolinks:load', function() {
  $(document).on('click', '.close-answer', function(){
    $(this).parent().remove();
    check_btn($('.chk_correct'), $('.add_answer'), 9, true);
    check_btn($('.chk_correct'), $('.close-answer'), 3, false);
  });

  $(document).on('click', '.add_answer', function(){
    check_btn($('.sub_answer'), $('.add_answer'), 9, true);
    $('.close-answer:hidden').show();
  });

  $('.add_question').click(function(event){
    valid_question(event);
  });

  if(window.location.pathname.includes('edit')){
    $('.close-answer').hide();
    $('.add_answer').hide();
    $('.answer_content').attr('disabled','true');
    $('.sub_answer :checkbox').attr('disabled','true');
  }

  $(document).on('click', '#sub-field', function(event){
    var field = $(this).data('field');
    var new_id = $('.chk_correct').length;
    $('.sub_answer').append(field.replace(/hello/g, new_id));
    event.preventDefault();
  });
});

function check_btn(selector, btn, num, condi){
  ori = condi ? 1 : -1;
  if(selector.length*ori > num*ori){
    btn.hide();
  }else{
    btn.show();
  }
}

function get_length_text (selector){
  return selector.val().length;
}

function get_text_filed_not_empty(class_name){
  num = 0;

  $(class_name).each(function(){
    if (get_length_text($(this)) > 0){
      num++;
    }
  });
  return num;
}

function valid_check_box(selector, class_name){
  if(get_length_text(selector.siblings(class_name)) > 0){
    return true
  }
}

function get_valid_check_box(selectors, class_name){
  num = 0;

  selectors.each(function(){
    if(valid_check_box($(this), class_name)){
      num++;
    }
  });
  return num;
}

function valid_question(event){
  flag = true;
  message = '';

  if($(':selected').val().length == 0){
    flag = false;
    message += 'Please choose a category \n'
  }

  if(get_length_text($('.question_content')) == 0){
    flag = false;
    message += 'Question is empty \n'
  }

  if(get_length_text($('.question_meaning')) == 0){
    flag = false;
    message += 'Question\'s content is empty\n'
  }

  if(get_text_filed_not_empty('.answer_content') < 2){
    flag = false;
    message += 'At least 2 answer/ 1 question \n'
  }
  
  if(get_valid_check_box($(':checkbox:checked'), '.answer_content') == 0){
    flag = false;
    message += 'At least 1 correct answer/ 1 question'
  }

  if (!flag){
    alert(message);
    event.preventDefault();
  }
}
