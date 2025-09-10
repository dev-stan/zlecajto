import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { UltimateTurboModalController } from "ultimate_turbo_modal"

eagerLoadControllersFrom("controllers", application)
application.register("modal", UltimateTurboModalController)

import BurgerMenuController from "./burger_menu_controller"
application.register("burger-menu", BurgerMenuController)