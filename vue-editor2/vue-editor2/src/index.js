import Uploader from './components/uploader.vue'
import UploaderBtn from './components/btn.vue'
import UploaderDrop from './components/drop.vue'
import UploaderUnsupport from './components/unsupport.vue'
import UploaderList from './components/list.vue'
import UploaderFiles from './components/files.vue'
import UploaderFile from './components/file.vue'
import JxAce from './components/ace.vue'
import JxEditor from './components/editor.vue'
import JxRate from './components/rate.vue'
import JxAvatar from './components/upload_avatar.vue'
import JxMobilinkShared from './components/mobilink_shared.vue'
import JxMobilinkOnlineForm from './components/mobilink_online_form.vue'
import JxMobilinkComment from './components/mobilink_comment.vue'
import JxMobilinkApproval from './components/mobilink_approval.vue'
import JxMobilinkStatus from './components/mobilink_status.vue'
import JxMobilinkVoting from './components/mobilink_voting.vue'
import JxMobilinkSharedSelect from './components/mobilink_shared_select.vue'
import JxMobilinkAlbumImage from './components/mobilink_album_image.vue'
import JxMobilinkAlbumImageUse from './components/mobilink_album_image_use.vue'
import JxMobilinkChecklist from './components/mobilink_checklist.vue'
import JxMobilinkDocFileAdd from './components/mobilink_docfile_add.vue'
import JxMobilinkLabels from './components/mobilink_labels.vue'
import JxMobilinkWorkspaceDownload from './components/mobilink_workspace_download.vue'
import JxMobilinkSliderColor from './components/slider_color.vue'
import VuejsDialog from 'vuejs-dialog'
import FullCalendar from './components/fullCalendar.vue'
import EventCard from './components/eventCard.vue'
import MobilinkActivityAdd from './components/mobilink_activity_add.vue'
import MobilinkDateTimePicker from './components/mobilink_date_time_picker.vue'
import MultiLanguage from './common/vue-multilanguage'
import language from './lang/language'
const uploader = {
  version: /* eslint-disable no-undef */ __VERSION__,
  install
}
alert(MobilinkDateTimePicker.name)
if (typeof window !== 'undefined' && window.Vue) {
  window.Vue.use(VuejsDialog)
  window.Vue.use(MultiLanguage, language)
  window.Vue.use(install)
}

export default uploader

function install (Vue) {
  if (install.installed) {
    return
  }
  Vue.component(Uploader.name, Uploader)
  Vue.component(UploaderBtn.name, UploaderBtn)
  Vue.component(UploaderDrop.name, UploaderDrop)
  Vue.component(UploaderUnsupport.name, UploaderUnsupport)
  Vue.component(UploaderList.name, UploaderList)
  Vue.component(UploaderFiles.name, UploaderFiles)
  Vue.component(UploaderFile.name, UploaderFile)
  Vue.component(JxAce.name, JxAce)
  Vue.component(JxEditor.name, JxEditor)
  Vue.component(JxRate.name, JxRate)
  Vue.component(JxAvatar.name, JxAvatar)
  Vue.component(JxMobilinkShared.name, JxMobilinkShared)
  Vue.component(JxMobilinkOnlineForm.name, JxMobilinkOnlineForm)
  Vue.component(JxMobilinkComment.name, JxMobilinkComment)
  Vue.component(JxMobilinkApproval.name, JxMobilinkApproval)
  Vue.component(JxMobilinkStatus.name, JxMobilinkStatus)
  Vue.component(JxMobilinkVoting.name, JxMobilinkVoting)
  Vue.component(JxMobilinkSharedSelect.name, JxMobilinkSharedSelect)
  Vue.component(JxMobilinkAlbumImage.name, JxMobilinkAlbumImage)
  Vue.component(JxMobilinkAlbumImageUse.name, JxMobilinkAlbumImageUse)
  Vue.component(JxMobilinkChecklist.name, JxMobilinkChecklist)
  Vue.component(JxMobilinkDocFileAdd.name, JxMobilinkDocFileAdd)
  Vue.component(JxMobilinkLabels.name, JxMobilinkLabels)
  Vue.component(JxMobilinkWorkspaceDownload.name, JxMobilinkWorkspaceDownload)
  Vue.component(JxMobilinkSliderColor.name, JxMobilinkSliderColor)
  Vue.component(FullCalendar.name, FullCalendar)
  Vue.component(EventCard.name, EventCard)
  Vue.component(MobilinkActivityAdd.name, MobilinkActivityAdd)
  Vue.component(MobilinkDateTimePicker.name, MobilinkDateTimePicker)
}
