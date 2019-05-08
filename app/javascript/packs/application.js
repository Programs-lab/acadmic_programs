/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import 'application.scss';
import './tinymce/langs/es_MX.js'
console.log('Hello World from Webpacker')

// entiities
require('./hello_vue');
require('./sign_up');
require('./user_form');
require('./shared');
require('./home');
require('./flash');
require('./companies');
require('./procedure_types');
require('./medical_record');
require('./working_weeks');
require('./user_no_registered');
require('./appointments');
require('./scheduled_appointments');

//components

require('./components/tab');
require('./components/nav');
require('./components/modal');
require('./components/dropdown');
require('./components/collapse');
