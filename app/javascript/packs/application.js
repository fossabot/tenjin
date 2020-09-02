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
import '../styles/application.scss'
import 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'

import flatpickr from 'flatpickr'
import 'flatpickr/dist/flatpickr.min.css'
import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

import './classroom'
import './homework'
import './pages'
import './schools'
import './student_dashboard'
import './teacher_dashboard'
import './users'
import './questions/multiple_choice_question'
import './questions/question_bottom'
import './questions/question_top'
import './questions/short_response_question'
import './questions/import_topic_questions'
import './lessons'
import './questions'
import './customise'
import Rails from '@rails/ujs'

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

require('datatables.net-bs4')
require('datatables.net-buttons-bs4')
require('datatables.net-buttons/js/buttons.html5.js')

require('trix')
require('@rails/actiontext')

$(document).on('turbolinks:load', function () {
  if ($('#notice').text().length) {
    $('#noticeModal').modal()
  }

  if ($('#alert').text().length) {
    $('#alertModal').modal()
  }
})

// Support component names relative to this directory:
var componentRequireContext = require.context('components', true)
var ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)

// Stimulus
const application = Application.start()
const context = require.context('./controllers', true, /\.js$/)
application.load(definitionsFromContext(context))
