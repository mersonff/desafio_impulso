// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import RemovalsController from "./removals_controller.js"
import NestedForm from 'stimulus-rails-nested-form'
import SearchAddressController from "./search_address_controller";

eagerLoadControllersFrom("controllers", application)
application.register("removals", RemovalsController)
application.register('nested-form', NestedForm)
application.register('search-address', SearchAddressController)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
