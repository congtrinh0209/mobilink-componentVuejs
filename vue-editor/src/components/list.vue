<template>
  <div class="uploader-list">
    <v-tabs :scrollable="false">
      <v-tabs-bar class="grey-mobilink-panel hidden" dark>
        <v-tabs-item :href="'#tab-file_upload-detail-1'+id">
          <v-badge color="grey darken-1">
            <span slot="badge">{{file_attact_list_file.length}}</span>
            <span>Tài liệu chọn từ máy tính</span>
          </v-badge>
        </v-tabs-item>
        <v-tabs-item @click.prevent.stop="dropboxPicer()" v-if="extensions_upload == 'true'">
          <v-badge color="grey darken-1">
            <span slot="badge">{{file_attact_list_linkD.length}}</span>
            <span>DropBox</span>
          </v-badge>
        </v-tabs-item>
        <v-tabs-item @click.prevent.stop="googlePicker()" v-if="extensions_upload == 'true'">
          <v-badge color="grey darken-1">
            <span slot="badge">{{file_attact_list_linkG.length}}</span>
            <span>GoogleDrive</span>
          </v-badge>
        </v-tabs-item>
        <v-tabs-slider color="primary"></v-tabs-slider>
      </v-tabs-bar>
      
      <v-tabs-items>
        <v-tabs-content :id="'tab-file_upload-detail-1'+id" reverse-transition="slide-y-transition" transition="slide-y-transition">
          <uploader-drop v-if="permission === 'write' || permission === 'owner'">
            <uploader-btn> <v-icon>file_upload</v-icon> Chọn file</uploader-btn>
            <button class="uploader-btn" @click.prevent.stop="dropboxPicer()" v-if="extensions_upload == 'true'"><i class="fa fa-dropbox"></i> DropBox</button>
            <button class="uploader-btn" @click.prevent.stop="googlePicker()" v-if="extensions_upload == 'true'"><i class="fa fa-google"></i> GoogleDrive</button>
            <p style="
                position: absolute;
                top: 15px;
                color: #b3adad;
            ">hoặc kéo thả tài liệu vào đây để tải lên</p>
          </uploader-drop>
          <v-alert outline color="error" icon="warning" :value="apistateupload=== 2">
            {{fileMessageError}}
          </v-alert>
          <v-alert outline color="success" icon="check_circle" :value="apistateupload === 1">
            {{fileMessageSuccess}}
          </v-alert>
          <v-alert outline color="success" icon="check_circle" :value="apistatedropbox === 1">
            {{pickerFileMessageSuccess}}
          </v-alert>
          <slot :file-list="fileList">
            <ul v-if="fileList.length > 0">
              <li v-for="(file, index) in fileList" :key="file.id">
                <uploader-file :file="file" :list="true" :index="index"
                  v-on:handlechildcallfilelist='handlechildcallfilelist'
                ></uploader-file>
              </li>
            </ul>
          </slot>
          <ul class="ul-with-border ul-with-right-icon ul-with-left-icon" v-if="file_attact_list_file.length > 0">
            <li v-for="(item, index) in file_attact_list_file" :key="index">
              <div class="layout wrap">
                <div class="flex xs12 sm8">
                  <i class="fa fa-angle-double-right icon-left" aria-hidden="true"></i>
                  <a href="javascript:;" @click.prevent.stop="downloadReferenceFile(item)" v-if="!item.download_loading">{{item.fileName}}</a>
                  <v-progress-circular indeterminate color="primary" v-else></v-progress-circular>
                </div>
                <div class="flex xs12 sm4 text-right">
                  <v-btn fab dark small color="primary" class="btn--version mr-2" @click.prevent.stop="fileVersionView(item)">
                    {{item.version}}
                  </v-btn>
                  <span>{{item.modifiedDate | datetime}}</span>
                  <v-btn v-if="permission === 'write' || permission === 'owner'" flat icon v-on:click.native.prevent="singleFileUpload(item)"><v-icon>file_upload</v-icon></v-btn>
                  <v-btn v-if="permission === 'write' || permission === 'owner'" flat icon v-on:click.native="fileAttactUploadRemove(item, index)"><v-icon color="red darken-3">clear</v-icon></v-btn>
                  <input type="file" :id="'inputfile_'+item.fileAttachId" style="display:none" v-on:change="singleFileUploadInput($event, item, index)"/>
                </div>
              </div>
            </li>
          </ul>
          <ul class="ul-with-border ul-with-right-icon ul-with-left-icon" v-if="file_attact_list_linkD.length > 0 && extensions_upload == 'true'">
            <li v-for="(item, index) in file_attact_list_linkD" :key="index">
              <div class="layout wrap">
                <div class="flex xs12 sm8">
                  <i class="fa fa-angle-double-right icon-left" aria-hidden="true"></i>
                  <i class="fa fa-dropbox" aria-hidden="true"></i>
                  <a :href="item.sourceUrl" target="_blank" v-if="item.fileName && item.fileName.length > 0">{{item.fileName}}</a>
                  <a :href="item.sourceUrl" target="_blank" v-else>Chưa cập nhật tên tài liệu</a>
                </div>
                <div class="flex xs12 sm4 text-right">
                  <span>{{item.modifiedDate | datetime}}</span>
                  <v-btn target="_blank" :href="item.sourceUrl" flat icon class="py-0 pr-0"><v-icon>file_download</v-icon></v-btn>
                  <v-btn v-if="permission === 'write' || permission === 'owner'" flat icon v-on:click.native="fileAttactRemove(item, index)"><v-icon color="red darken-3">clear</v-icon></v-btn>
                </div>
              </div>
            </li>
          </ul>
          <ul class="ul-with-border ul-with-right-icon ul-with-left-icon" v-if="file_attact_list_linkG.length > 0 && extensions_upload == 'true'">
            <li v-for="(item, index) in file_attact_list_linkG" :key="index">
              <div class="layout wrap">
                <div class="flex xs12 sm8">
                  <i class="fa fa-angle-double-right icon-left" aria-hidden="true"></i>
                  <i class="fa fa-google" aria-hidden="true"></i>
                  <a :href="item.sourceUrl" target="_blank" v-if="item.fileName && item.fileName.length > 0">{{item.fileName}}</a>
                  <a :href="item.sourceUrl" target="_blank" v-else>Chưa cập nhật tên tài liệu</a>
                </div>
                <div class="flex xs12 sm4 text-right">
                  <span>{{item.modifiedDate | datetime}}</span>
                  <v-btn target="_blank" :href="item.sourceUrl" flat icon class="py-0 pr-0"><v-icon>file_download</v-icon></v-btn>
                  <v-btn v-if="permission === 'write' || permission === 'owner'" flat icon v-on:click.native="fileAttactRemove(item, index)"><v-icon color="red darken-3">clear</v-icon></v-btn>
                </div>
              </div>
            </li>
          </ul>
        </v-tabs-content>
      </v-tabs-items>
    </v-tabs>
    <v-dialog v-model="fileVersionDialog" persistent max-width="900" transition="fade-transition">
      <v-card style="min-height: 500px;">
          <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
              <span class="pl-3">Thông tin file đính kèm</span>
              <v-spacer></v-spacer>
              
              <div class="menu" style="display: inline-block;">
                  <div class="menu__activator">
                      <v-btn icon slot="activator" @click.native="fileVersionDialog = false">
                          <v-icon>close</v-icon>
                      </v-btn>
                  </div>
              </div>

          </v-card-title>
          <v-card-text style="padding: 0;padding-top: 50px;">
            <ul class="ul-with-border ul-with-right-icon ul-with-left-icon">
              <li v-for="(item, index) in file_attact_list_file_version" :key="index">
                <div class="layout wrap">
                  <div class="flex xs12 sm6">
                    <i class="fa fa-angle-double-right icon-left" aria-hidden="true"></i>
                    <a :href="item.sourceUrl" target="_blank" v-if="item.fileName && item.fileName.length > 0">{{item.fileName}}</a>
                    <a :href="item.sourceUrl" target="_blank" v-else>Chưa cập nhật tên tài liệu</a>
                  </div>
                  <div class="flex xs12 sm6 text-right">
                    <span>( V {{item.version}}.0 ) </span>
                    <span>{{item.createDate | datetime}}</span> 
                    <strong>{{item.userName}}</strong>
                    <v-btn flat icon class="py-0 pr-0" v-on:click.native="downloadReferenceFileVersion(item)"><v-icon>file_download</v-icon></v-btn>
                  </div>
                </div>
              </li>
            </ul>
          </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
  import UploaderFile from './file.vue'

  const COMPONENT_NAME = 'uploader-list'

  export default {
    name: COMPONENT_NAME,
    props: {
      id: null,
      developerKey: 'AIzaSyBH7gjy2txKyfjuvYSvDQE-n1oI6CvFZ5A',
      clientId: '28087851761-keiiqh7jeutn2h6b3lm1gcj55d4mfau1.apps.googleusercontent.com',
      viewId: 'DOCS',
      class_pk: '',
      class_name: '',
      group_id: 0,
      file_attach_api: '',
      resourceusers_get_api: '',
      extensions_upload: 'true',
      permission: 'read'
    },
    data () {
      return {
        apistatedropbox: 0,
        apistateupload: 0,
        file_attact_list_file: [],
        file_attact_list_linkD: [],
        file_attact_list_linkG: [],
        file_attact_list_file_version: [],
        pickerFileMessageSuccess: 'Tải tài liệu thành công!',
        pickerFileMessageError: 'Tải tài liệu thất bại!',
        fileMessageSuccess: 'Tải tài liệu thành công!',
        fileMessageError: 'Tải tài liệu thất bại!',
        fileVersionDialog: false,
        fileAttachIdTemp: 0
      }
    },
    created () {
      var vm = this
      const config = {
        headers: {
          'groupId': vm.group_id,
          'Accept': 'application/json'
        }
      }
      vm.$nextTick(function () {
        var allFileAttachs = []
        vm.file_attact_list_file = []
        vm.file_attact_list_linkD = []
        vm.file_attact_list_linkG = []
        axios.get(vm.file_attach_api + '/' + vm.class_name + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            allFileAttachs = serializable.data
            for (var key in allFileAttachs) {
              if (allFileAttachs[key].source === 'upload' || allFileAttachs[key].source == '') {
                vm.file_attact_list_file.push(allFileAttachs[key])
              } else if (allFileAttachs[key].source === 'dropbox') {
                vm.file_attact_list_linkD.push(allFileAttachs[key])
              } else if (allFileAttachs[key].source === 'google') {
                vm.file_attact_list_linkG.push(allFileAttachs[key])
              }
            }
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      })
    },
    computed: {
      fileList () {
        console.log('fileList')
        console.log(this.$parent.fileList)
        return this.$parent.fileList
      }
    },
    components: {
      UploaderFile
    },
    methods: {
      fileVersionView: function (item) {
        var vm = this
        vm.fileVersionDialog = !vm.fileVersionDialog
        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        vm.file_attact_list_file_version = []
        vm.fileAttachIdTemp = 0
        axios.get(vm.file_attach_api + '/' + item.fileAttachId + '/versions', config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.file_attact_list_file_version = serializable.data
            vm.fileAttachIdTemp = item.fileAttachId
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      },
      downloadReferenceFileVersion: function (item) {
        var vm = this;
        const config = {
          headers: {
            'groupId': vm.group_id,
          },
          responseType: 'blob'
        }
        axios.get(vm.file_attach_api + '/' + vm.fileAttachIdTemp + '/' + item.version + '.0', config).then(function (response) {
          var url = window.URL.createObjectURL(response.data)
          window.open(url)
        })
          .catch(function (error) {
            console.log(error)
          })
      },
      downloadReferenceFile: function (item) {
        var vm = this;
        item['download_loading'] = true
        const config = {
          headers: {
            'groupId': vm.group_id,
          },
          responseType: 'blob'
        }
        axios.get(vm.file_attach_api + '/' + item.fileAttachId, config).then(function (response) {
          
          var fileName = response.headers['content-disposition'];
          fileName = fileName.split('=')[1];
          fileName = fileName.substring(1, fileName.length-1);

          var a = document.createElement("a");
          document.body.appendChild(a);
          a.style = "display: none";
          var url = window.URL.createObjectURL(response.data)
          a.href = url;
          a.download = fileName;
          a.click();
          window.URL.revokeObjectURL(url);


          //var url = window.URL.createObjectURL(response.data)
          item['download_loading'] = false
          //window.open(url)
        })
          .catch(function (error) {
            console.log(error)
            item['download_loading'] = false
          })
      },
      singleFileUpload: function (item) {
        document.getElementById('inputfile_'+item.fileAttachId).click()
      },
      singleFileUploadInput: function (e, item, index) {	
        var files = e.target.files || e.dataTransfer.files
        var file = files[0]
        var vm = this
        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        var params = new FormData();
        params.append('file', file)
        params.append('fileType', file.type)
        params.append('fileSize', file.size)
        params.append('fileName', file.name)
        params.append('className', vm.class_name)
        params.append('classPK', vm.class_pk)
        /** TODO: giao dien them o check file chinh hay file phu luc */
        params.append('appendix', true)
        axios.put(vm.file_attach_api + '/' + item.fileAttachId,
          params,
          config
        )
        .then(function (response) {
          vm.apistateupload = 1
          item.version = response.data.version
          item.fileName = response.data.fileName
          vm.fileMessageSuccess = 'Cập nhật liệu đính kèm thành công!'
          setTimeout(
            function(){ 
              vm.apistateupload = 0
            }, 
          3000)
        })
        .catch(function (error) {
          console.log(error)
          vm.apistateupload = 2
          vm.fileMessageError = 'Cập nhật tài liệu đính kèm thất bại!'
          setTimeout(
            function(){ 
              vm.apistateupload = 0
            }, 
          3000)
        })
      },
      handlechildcallfilelist: function (index) {
        if (this.fileList.length == index + 1) {
          var vm = this
          const config = {
            headers: {
              'groupId': vm.group_id,
              'Accept': 'application/json'
            }
          }
          var allFileAttachs = []
          vm.file_attact_list_file = []
          vm.file_attact_list_linkD = []
          vm.file_attact_list_linkG = []
          axios.get(vm.file_attach_api + '/' + vm.class_name + '/' + vm.class_pk, config)
          .then(function (response) {
            var serializable = response.data
            if (serializable.hasOwnProperty('data')) {
              allFileAttachs = serializable.data
              for (var key in allFileAttachs) {
                if (allFileAttachs[key].source === 'upload' || allFileAttachs[key].source == '') {
                  vm.file_attact_list_file.push(allFileAttachs[key])
                } else if (allFileAttachs[key].source === 'dropbox') {
                  vm.file_attact_list_linkD.push(allFileAttachs[key])
                } else if (allFileAttachs[key].source === 'google') {
                  vm.file_attact_list_linkG.push(allFileAttachs[key])
                } 
              }
            }
          })
          .catch(function (error) {
            console.log(error)
          })
        }
      },
      fileAttactUploadRemove: function (item, index) {
        var vm = this
        vm.$dialog.confirm('Bạn có muốn xóa tài liệu đính kèm này!', {
          html: true,
          loader: true,
          okText: 'Xác nhận',
          cancelText: 'Quay lại',
          animation: 'fade'
        })
        .then((dialog) => {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          axios.delete(vm.file_attach_api + '/' + item.fileAttachId, config).then(function (response) {
            vm.file_attact_list_file.splice(index, 1)
            vm.apistateupload = 1
            vm.fileMessageSuccess = 'Xoá tài liệu đính kèm thành công!'
            setTimeout(
              function(){ 
                vm.apistateupload = 0
              }, 
            3000)
          })
          .catch(function (error) {
            console.log(error)
            vm.apistateupload = 2
            vm.fileMessageError = 'Xoá tài liệu đính kèm thất bại!'
            setTimeout(
              function(){ 
                vm.apistateupload = 0
              }, 
            3000)
          })
          dialog.close()
        })
        .catch((e) => {
          console.log(e)
        })
      },
      fileAttactRemove: function (item, index) {
        var vm = this
        vm.$dialog.confirm('Bạn có muốn xóa tài liệu đính kèm này!', {
          html: true,
          loader: true,
          okText: 'Xác nhận',
          cancelText: 'Quay lại',
          animation: 'fade'
        })
        .then((dialog) => {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          axios.delete(vm.file_attach_api + '/' + item.fileAttachId, config).then(function (response) {
            vm.file_attact_list_linkD.splice(index, 1)
            vm.apistatedropbox = 1
            vm.pickerFileMessageSuccess = 'Xoá tài liệu đính kèm thành công!'
            setTimeout(
              function(){ 
                vm.apistatedropbox = 0
              }, 
            3000)
          })
          .catch(function (error) {
            console.log(error)
            vm.apistatedropbox = 2
            vm.pickerFileMessageError = 'Xoá tài liệu đính kèm thất bại!'
            setTimeout(
              function(){ 
                vm.apistatedropbox = 0
              }, 
            3000)
          })
          dialog.close()
        })
        .catch((e) => {
          console.log(e)
        })
      },
      dropboxPicer: function () {
        var vm = this
        if (vm.permission === 'write' || vm.permission === 'owner') {
          var options = {
            success: function (files) {
              for (const file of files) {
                const name = file.name
                const url = file.link
                console.log({ name: name, url: url })
                const config = {
                  headers: {
                    'groupId': vm.group_id
                  }
                }
                var params = new URLSearchParams()
                params.append('className', vm.class_name)
                params.append('classPK', vm.class_pk)
                params.append('source', 'dropbox')
                params.append('sourceUrl', url)
                params.append('fileName', name)
                axios.post(vm.file_attach_api,
                  params,
                  config
                )
                .then(function (response) {
                  vm.apistatedropbox = 1
                  vm.pickerFileMessageSuccess = 'Tải tài liệu thành công!'
                  vm.file_attact_list_linkD.push(response.data)
                })
                .catch(function (error) {
                  console.log(error)
                  vm.apistatedropbox = 2
                  vm.pickerFileMessageError = 'Tải tài liệu thất bại!'
                  setTimeout(
                    function(){ 
                      vm.apistatedropbox = 0
                    }, 
                  3000)
                })
              }
            },
            cancel: function () {
            },
            linkType: "direct",
            multiselect: false,
            extensions: ['.pdf', '.doc', '.docx', '.html', '.png', '.jpg'],
          }
          Dropbox.choose(options)
        }
      },
      googlePicker: function () {
        var vm = this
        if (vm.permission === 'write' || vm.permission === 'owner') {
          var setOAuthToken = true
          var scope = [ 'https://www.googleapis.com/auth/drive',
          'https://www.googleapis.com/auth/photos']
          var viewIds = {
            "DOCS":   google.picker.ViewId.DOCS,
            "DOCS_IMAGES": google.picker.ViewId.DOCS_IMAGES,
            "DOCUMENTS": google.picker.ViewId.DOCUMENTS,
            "PRESENTATIONS": google.picker.ViewId.PRESENTATIONS,
            "SPREADSHEETS": google.picker.ViewId.SPREADSHEETS,
            "FORMS": google.picker.ViewId.FORMS,
            "DOCS_IMAGES_AND_VIDEOS": google.picker.ViewId.DOCS_IMAGES_AND_VIDEOS,
            "DOCS_VIDEOS": google.picker.ViewId.DOCS_VIDEOS,
            "FOLDERS": google.picker.ViewId.FOLDERS,
            "PDFS": google.picker.ViewId.PDFS,
            "DOCS_UPLOAD": new google.picker.DocsUploadView(),
            "PHOTO_ALBUMS": google.picker.ViewId.PHOTO_ALBUMS,
            "PHOTOS": google.picker.ViewId.PHOTOS,
            "PHOTO_UPLOAD": google.picker.ViewId.PHOTO_UPLOAD,
            "IMAGE_SEARCH": google.picker.ViewId.IMAGE_SEARCH,
            "MAPS": google.picker.ViewId.MAPS,
            "VIDEO_SEARCH": google.picker.ViewId.VIDEO_SEARCH,
            "WEBCAM": google.picker.ViewId.WEBCAM,
            "YOUTUBE": google.picker.ViewId.YOUTUBE,
            "RECENTLY_PICKED": google.picker.ViewId.RECENTLY_PICKED
          }
          var id = vm.viewId;
          var viewId = viewIds[id];
          var setOAuthToken = true;
          
          if (id === 'IMAGE_SEARCH' || id === 'MAPS' || id === 'VIDEO_SEARCH') {
            setOAuthToken = false;
            vm.createPicker(viewId, setOAuthToken);
          } else {
            if (window.authApiLoaded && !window.oauthToken) {
              window.viewIdForhandleAuthResult = viewId;
              window.gapi.auth.authorize(
                {
                  'client_id': vm.clientId,
                  'scope': scope,
                  'immediate': false
                },
                vm.handleAuthResult
              );
            } else {
              vm.createPicker(viewId, setOAuthToken);
            }
          }
        }
      },
      pickerCallback: function (data) {
        var url = 'nothing';
        var vm = this;
        const config = {
          headers: {
            'groupId': vm.group_id
          }
        }
        if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
          var doc = data[google.picker.Response.DOCUMENTS][0];
          url = doc[google.picker.Document.URL];
          var fileName = doc.name;
          var params = new URLSearchParams()
          params.append('className', vm.class_name)
          params.append('classPK', vm.class_pk)
          params.append('source', 'google')
          params.append('sourceUrl', url)
          params.append('fileName', fileName)
          axios.post(vm.file_attach_api,
            params,
            config
          )
          .then(function (response) {
            vm.apistatedropbox = 1
            vm.pickerFileMessageSuccess = 'Tải tài liệu thành công!'
            vm.file_attact_list_linkG.push(response.data)
          })
          .catch(function (error) {
            console.log(error)
            vm.apistatedropbox = 2
            vm.pickerFileMessageError = 'Tải tài liệu thất bại!'
            setTimeout(
              function(){ 
                vm.apistatedropbox = 0
              }, 
            3000)
          })
        }
        
        axios.get(vm.resourceusers_get_api + '/' + vm.class_name + '/' + vm.class_pk + '?selected=true&sort=fullName', config)
          .then(function (response) {
            var serializable = response.data
            if (serializable.hasOwnProperty('data')) {
              if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
                var doc = data[google.picker.Response.DOCUMENTS][0];
                url = doc[google.picker.Document.URL];
                var fileID = doc[google.picker.Document.ID];
                var role = "reader";
                var type = "user";
                vm.followers = serializable.data
                for (var key in vm.followers) {
                  var emailAddress = vm.followers[key].email;
                  if(emailAddress.length > 0) {
                    var request1 = gapi.client.request({
                      "path": "https://www.googleapis.com/drive/v3/files/" + fileID + "/permissions",
                      "method": "POST",
                      "headers": { "Content-Type": "application/json", "Authorization": "Bearer " + window.oauthToken },
                      "body": { "role": role, "type": type, "emailAddress": emailAddress }
                    }); request1.execute(function(resp) { console.log(resp); });
                  }
                }
              }
            }
          })
          .catch(function (error) {
            console.log(error)
          })
      },
      createPicker: function (viewId, setOAuthToken) {
        var vm = this
        if (window.authApiLoaded && window.pickerApiLoaded) {
          var picker
          if (window.authApiLoaded && window.oauthToken && setOAuthToken) {
            picker = new google.picker.PickerBuilder().addView(viewId)
                .setOAuthToken(window.oauthToken)
                .setDeveloperKey(vm.developerKey).setCallback(
                    vm.pickerCallback).build();
          } else {
            picker = new google.picker.PickerBuilder().addView(viewId)
                .setDeveloperKey(vm.developerKey).setCallback(
                    vm.pickerCallback).build();
          }
          picker.setVisible(true);
        }
      },
      handleAuthResult: function (authResult) {
        var vm = this
        console.log(authResult)
        if (authResult && !authResult.error) {
          window.oauthToken = authResult.access_token;
          vm.createPicker(window.viewIdForhandleAuthResult, true);
        }
      }
    }
  }
</script>

<style>
  .uploader-list {
    position: relative;
  }
  .uploader-list > ul {
    list-style: none;
    margin: 0;
    padding: 0
  }
  .ul-with-border .btn--icon .btn__content {
    padding: 0;
  }
  .ul-with-border .btn--icon .btn__content i.material-icons {
    font-size: 17px;
  }
  .btn--version.btn--floating {
    border-radius: 50%;
    border-top-left-radius: 50%;
    border-top-right-radius: 50%;
    border-bottom-right-radius: 50%;
    border-bottom-left-radius: 50%;
    min-width: 0;
    height: 20px;
    width: 20px;
    padding: 0;
    -webkit-box-shadow: 0 3px 5px -1px rgba(0,0,0,.2), 0 6px 10px 0 rgba(0,0,0,.14), 0 1px 18px 0 rgba(0,0,0,.12);
    box-shadow: 0 3px 5px -1px rgba(0,0,0,.2), 0 6px 10px 0 rgba(0,0,0,.14), 0 1px 18px 0 rgba(0,0,0,.12);
  }
  .btn--version.btn--floating .btn__content {
    padding: 0;
    font-size: 10px;
  }
  .uploader-list .tabs__li .badge {
    background: transparent;
    color: inherit;
  }
  ul.ul-with-border li {
    padding-right: 15px;
  }
  .uploader-btn i.material-icons.icon{
    font-size: 17px;
  }
  body .uploader-drop {
    border-left: 0;
    border-right: 0;
  }
</style>