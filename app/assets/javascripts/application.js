// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets//sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require tinymce
//= require tinymce/langs/es_MX.js


$( document ).on('turbolinks:load',function() {
  setTimeout(function () {
    tinyMCE.init({
      selector: 'textarea.content-no-editable',
      plugins: 'fullscreen',
      toolbar: 'fullscreen',
      menubar: false,
      width: '100%',
      height: 409,
      language: 'es_MX',
      readonly: 1,
      forced_root_block: false
    })
  }, 10);
});

function initTinyMCE(el) {
  setTimeout(function () {
    tinyMCE.init({
      target: el,
      menubar: "false"
    })
  }, 100);
};

$( document ).on('turbolinks:load',function() {
  setTimeout(function () {
    tinyMCE.init({
      selector: 'textarea.simple-content',
      plugins: 'paste print preview fullpage searchreplace  visualchars fullscreen  table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount',
      toolbar: 'formatselect | bold italic strikethrough forecolor backcolor permanentpen formatpainter | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent | removeformat',
      width: '100%',
      height: 104,
      language: 'es_MX',      
    })
  }, 10);
});

$( document ).on('turbolinks:load',function() {
  setTimeout(function () {
    tinyMCE.init({
      selector: 'textarea',
      plugins: 'paste print preview fullpage searchreplace autolink directionality visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern help',
      toolbar: 'fullscreen | formatselect | bold italic strikethrough forecolor backcolor permanentpen formatpainter | link image media pageembed | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent | removeformat',
      image_advtab: true,
      paste_data_images: true,
      width: '100%',
      height: 409,
      language: 'es_MX',
    })
  }, 10);
});



