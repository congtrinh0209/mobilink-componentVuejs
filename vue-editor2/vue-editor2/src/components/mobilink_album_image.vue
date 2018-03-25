<template>
  <div>
    
  <v-carousel interval="2000">
    <v-carousel-item v-for="item in items" v-bind:key="item.albumFileId" v-bind:src="item.src" ></v-carousel-item>
  </v-carousel>
  <v-btn block flat class="my-0 grey lighten-3" v-on:click.native="showAlbumFileUploadDialog()">
    <v-icon>file_upload</v-icon>
    Tải hình ảnh lên
  </v-btn>
  <v-dialog v-model="albumFileUploadDialog" persistent max-width="900" transition="fade-transition" v-if="albumFileUploadDialogState === id">
    <v-card>
      <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
            <span class="pl-3">Tải ảnh vào album</span>
            <v-spacer></v-spacer>
            
            <div class="menu" style="display: inline-block;">
                <div class="menu__activator">
                    <v-btn icon slot="activator" @click.native="albumFileUploadDialog = false">
                        <v-icon>close</v-icon>
                    </v-btn>
                </div>
            </div>

        </v-card-title>
        <v-card-text style="padding-top: 60px;">
          <uploader-drop>
            <uploader-btn> <v-icon>file_upload</v-icon> Tải lên</uploader-btn>
            <p style="
                position: absolute;
                top: 15px;
                width: 100%;
                text-align: center;
                color: #b3adad;
            ">hoặc kéo thả tài liệu vào đây để tải lên</p>
          </uploader-drop>
          <v-alert outline color="error" icon="warning" :value="apistateupload=== 2">
            {{fileMessageError}}
          </v-alert>
          <v-alert outline color="success" icon="check_circle" :value="apistateupload === 1">
            {{fileMessageSuccess}}
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
                  <span>{{item.modifiedDate | datetime}}</span>
                  <v-btn flat icon color="red darken-3" v-on:click.native="fileAttactUploadRemove(item, index)"><v-icon>clear</v-icon></v-btn>
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
import axios from 'axios'
import UploaderFile from './file.vue'
const COMPONENT_NAME = 'jx-mobilink-album-image'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    album_api: '',
    auto: false
  },
  data () {
    return {
      albumFileUploadDialogState: 0,
      albumFileUploadDialog: false,
      apistateupload: 0,
      file_attact_list_file: [],
      fileMessageSuccess: 'Tải tài liệu thành công!',
      fileMessageError: 'Tải tài liệu thất bại!',
      fileAttachIdTemp: 0,
      items: []
    }
  },
  computed: {
    fileList () {
      return this.$parent.fileList
    }
  },
  created () {
    var vm = this
    const config = {
      headers: {
        'groupId': vm.group_id
      }
    }
    vm.$nextTick(function () {
      if (vm.auto) {
        vm.showAlbumFileUploadDialog()
      }
      if (vm.album_api != null) {
        console.log(vm.items)
        axios.get(vm.album_api + '/' + vm.class_name + '/' + vm.class_pk, config)
        .then(function (response) {
          var serializable = response.data
          if (serializable.hasOwnProperty('data')) {
            vm.file_attact_list_file = serializable.data
            vm.items = serializable.data
            console.log(vm.class_pk)
            console.log(vm.items)
          }
        })
        .catch(function (error) {
          console.log(error)
        })
      }
    })
  },
  components: {
    UploaderFile
  },
  methods: {
    showAlbumFileUploadDialog: function () {
      this.albumFileUploadDialogState = this.id
      this.albumFileUploadDialog = true
      var prevewConfig = {
        className: this.class_name,
        classPK: this.class_pk,
        groupId: this.group_id
      }
      console.log(this.albumFileUploadDialog)
      this.$emit('init-album-file-upload', prevewConfig)
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
      axios.get(vm.album_api + '/' + item.albumFileId, config).then(function (response) {
        var url = window.URL.createObjectURL(response.data)
        item['download_loading'] = false
        window.open(url)
      })
        .catch(function (error) {
          console.log(error)
          item['download_loading'] = false
        })
    },
    fileAttactUploadRemove: function (item, index) {
      var vm = this
      vm.$dialog.confirm('Bạn có muốn xóa ảnh đính kèm này!', {
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
        axios.delete(vm.album_api + '/' + item.albumFileId, config).then(function (response) {
          setTimeout(
            function(){ 
              axios.get(vm.album_api + '/' + vm.class_name + '/' + vm.class_pk, config)
              .then(function (response) {
                var serializable = response.data
                if (serializable.hasOwnProperty('data')) {
                  vm.file_attact_list_file = serializable.data
                  vm.items = serializable.data
                  vm.apistateupload = 1
                  vm.fileMessageSuccess = 'Xoá tài liệu đính kèm thành công!'
                  setTimeout(
                    function(){ 
                      vm.apistateupload = 0
                    }, 
                  3000)
                }
              })
              .catch(function (error) {
                console.log(error)
              })
            }, 
          1000)
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
    handlechildcallfilelist: function (index) {
      if (this.fileList.length == index + 1) {
        var vm = this
        const config = {
          headers: {
            'groupId': vm.group_id,
            'Accept': 'application/json'
          }
        }
        setTimeout(
          function(){ 
            axios.get(vm.album_api + '/' + vm.class_name + '/' + vm.class_pk, config)
            .then(function (response) {
              var serializable = response.data
              if (serializable.hasOwnProperty('data')) {
                vm.file_attact_list_file = serializable.data
                vm.items = serializable.data
              }
            })
            .catch(function (error) {
              console.log(error)
            })
          }, 
        1000)
        
      }
    }
  }
}
</script>

<style>

</style>
