import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import ImageUploadController from "controllers/image_upload_controller"
application.register("image-upload", ImageUploadController)
eagerLoadControllersFrom("controllers", application)
